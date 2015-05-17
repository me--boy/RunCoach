//
//  UIBarButtonItem+Addtions.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/10/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Addtions)

+(id)barButtonItemWithCustomImage:(UIImage *)image target:(id)target action:(SEL)action;
+(id)barButtonItemWithCustomImage:(UIImage *)image target:(id)target action:(SEL)action Offset:(float)offset;
@end
