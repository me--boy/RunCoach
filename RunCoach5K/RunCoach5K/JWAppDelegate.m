//
//  JWAppDelegate.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/3/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWAppDelegate.h"
#import "SWRevealViewController.h"
#import "JWRearViewController.h"
#import "JWRunViewController.h"
#import "JWNavigationController.h"
#import "JWHourglassView.h"
#import "JWAppSetting.h"
#import "JWTutorialsManager.h"
#import "NoticeManager.h"
#import "TB_Reminder.h"
#import "Appirater.h"
#import "JWInAppPurchaseManager.h"


BOOL isInForeground = YES;//全局变量，标识应用是否在前台,仅在在这个文件范围内可以改变，

@implementation JWAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+(BOOL)applicationIsInForeground{
    return isInForeground;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //沙漏初始化需要较长时间，提前初始化
    [JWHourglassView shareHourglassUse:NO];
    
    JWRearViewController *rearViewCon = [[JWRearViewController alloc] init];
    JWRunViewController *runViewController = [[JWRunViewController alloc] init];
    JWNavigationController *nav = [[JWNavigationController alloc] initWithRootViewController:runViewController];
    
    JWNavigationController *navRear= [[JWNavigationController alloc] initWithRootViewController:rearViewCon];
    
    SWRevealViewController *revealViewCon = [[SWRevealViewController alloc] initWithRearViewController:navRear
                                                                                   frontViewController:nav];
    revealViewCon.toggleAnimationDuration = 0.3;
    [revealViewCon revealToggleAnimated:NO];
    self.window.rootViewController = revealViewCon;
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    isInForeground = YES;//进入前台
    JWAppSetting *appSetting = [JWAppSetting shareAppSetting];
    [appSetting appInitializeSettings];
    [Appirater appLaunched];
    
    if (SYSTEM_VERSTION_VALUE >= 7.0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    isInForeground = NO;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    isInForeground = NO;//进入后台
    
    TB_Reminder *reminder = [NoticeManager oneReminder];
    [NoticeManager cancelAllNotices];
    if ([reminder.enable doubleValue]) {
        [NoticeManager idForScheduleNotice:reminder];
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
#ifdef VERSION_FREE
    //for free
    if (![[JWInAppPurchaseManager shareInAppPurchaseManager] haveToBuyWithId:kInAppPurchaseProUpgradeADsProductId]) {
        NSInteger adCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"adCount"];
        adCount++;
        if (adCount >= 10 || adCount <0) {
            adCount = 0;
            if ([[JWInAppPurchaseManager shareInAppPurchaseManager] canMakePurchasesWithId:kInAppPurchaseProUpgradeADsProductId] && [[JWInAppPurchaseManager shareInAppPurchaseManager] canMakePurchases]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade"
                                                               message:[NSString stringWithFormat:@"Do you want to remove ads for %@?",[[JWInAppPurchaseManager shareInAppPurchaseManager] priceStringWithId:kInAppPurchaseProUpgradeADsProductId]]
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                     otherButtonTitles:@"Buy", nil];
                [alert show];
                alert.tag = 111;
            }
            
        }
        [[NSUserDefaults standardUserDefaults] setInteger:adCount forKey:@"adCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
#endif
    isInForeground = YES;//进入前台
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    isInForeground = YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RunCoach5K" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RunCoach5K.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - UIalert delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
#ifdef VERSION_FREE
    if (alertView.tag == 111) {
        if (buttonIndex == 1) {
            [[JWInAppPurchaseManager shareInAppPurchaseManager] purchaseProUpgradeWithId:kInAppPurchaseProUpgradeADsProductId];
        }
    }
#endif
}

@end
