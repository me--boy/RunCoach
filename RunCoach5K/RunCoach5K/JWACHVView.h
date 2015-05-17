//
//  JWACHVView.h
//  RunCoach5K
//
//  Created by YQ-011 on 8/12/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    KJWACHVViewSmall,
    KJWACHVViewBig
}KJWACHVViewType;

@interface JWACHVView : UIControl

- (id)initWithFrame:(CGRect)frame
           ACHV:(NSDictionary *)achc
               Type:(NSInteger)type;

@end
