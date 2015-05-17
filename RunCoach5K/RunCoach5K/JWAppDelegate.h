//
//  JWAppDelegate.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/3/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JWRevealManager;

@interface JWAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readonly, strong, nonatomic)JWRevealManager *revealManager;


+ (BOOL)applicationIsInForeground;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
