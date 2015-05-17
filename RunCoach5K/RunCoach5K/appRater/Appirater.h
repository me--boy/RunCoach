/*
 This file is part of Appirater.
 Copyright (c) 2010, Arash Payan
 All rights reserved.
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */
/*
 * Appirater.h
 * appirater
 *
 * Created by Arash Payan on 9/5/09.
 * http://arashpayan.com
 * Copyright 2010 Arash Payan. All rights reserved.
 */

#import <Foundation/Foundation.h>
extern NSString *const kAppiraterLaunchDate;
extern NSString *const kAppiraterLaunchCount;
extern NSString *const kAppiraterCurrentVersion;
extern NSString *const kAppiraterRatedCurrentVersion;
extern NSString *const kAppiraterDeclinedToRate;


#define DAYS_UNTIL_PROMPT 2 // double
/*
 Users will need to launch the same version of the app this many times before
 they will be prompted to rate it.
 */
#define LAUNCHES_UNTIL_PROMPT 5 // integer
/*
 'YES' will show the Appirater alert everytime. Useful for testing how your message
 looks and making sure the link to your app's review page works.
 */
#define APPIRATER_DEBUG NO

@class AppRaterView;

@interface Appirater : NSObject <UIActionSheetDelegate> {
	UIAlertView *successAlert;
}
@property (nonatomic, strong) UIAlertView *successAlert;
@property (nonatomic, strong) AppRaterView *appRateView;

+ (void)appLaunched;
+(void)BtnPressed:(int)btnIndex;
+(void)removeObject;
@end












