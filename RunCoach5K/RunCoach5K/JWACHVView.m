//
//  JWACHVView.m
//  RunCoach5K
//
//  Created by YQ-011 on 8/12/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWACHVView.h"
#import "JWACHVManager.h"

@interface JWACHVView ()

@property (nonatomic, copy)NSDictionary *achv;
@property (nonatomic)NSInteger type;

@end

@implementation JWACHVView

-(id)initWithFrame:(CGRect)frame
              ACHV:(NSDictionary *)achc
              Type:(NSInteger)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.achv = achc;
        self.type = type;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIImage *image;
    if (_type == KJWACHVViewSmall) {
        UIImage *bgImage = [UIImage imageNamed:@"achv_table"];
        [bgImage drawAtPoint:CGPointMake(0, rect.size.height - 36)];
        image = [UIImage imageNamed:[JWACHVManager achvImageName:_achv]];
    }else{
        UIImage *bgImage = [UIImage imageNamed:@"achv_information_table"];//size:235,120
        [bgImage drawAtPoint:CGPointMake(0, rect.size.height - 120)];
        image = [UIImage imageNamed:[JWACHVManager achvBigImageName:_achv]];
    }
    [image drawAtPoint:(CGPoint){(rect.size.width - image.size.width) / 2, 0}];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [kRGB255UIColor(39, 39, 39, 1.f) CGColor]);
    if (_type == KJWACHVViewSmall) {
        NSString *str = [_achv objectForKey:kACHVDisplayName];
        int fontSize = 12;
        CGSize makeSize;
        CGSize maxSize = CGSizeMake(75, 30);
        for (; fontSize >= 9; fontSize--) {
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:maxSize];
            makeSize = size;
            if (size.height <= 15) {
                break;
            }
        }
#ifdef ACHIEVEMENTS_DEBUG
        NSLog(@"%s%d",__FUNCTION__,fontSize);
#endif
        [str drawInRect:CGRectMake((85 - makeSize.width)/ 2, 90 - makeSize.height, makeSize.width, makeSize.height)
               withFont:[UIFont systemFontOfSize:fontSize]
          lineBreakMode:NSLineBreakByWordWrapping
              alignment:UITextAlignmentCenter];
         
    }else{
        if ([[_achv objectForKey:kACHVFinish] doubleValue]) {
            NSDate *date = [_achv objectForKey:kACHVFinishDate];
            NSString *dateStr = [NSDateFormatter localizedStringFromDate:date
                                                               dateStyle:NSDateFormatterLongStyle
                                                               timeStyle:NSDateFormatterNoStyle];
            [dateStr drawInRect:CGRectMake(20, 150, 200, 15)
                       withFont:[UIFont systemFontOfSize:12]
                  lineBreakMode:NSLineBreakByWordWrapping
                      alignment:NSTextAlignmentCenter];
            
        }
        NSString *message = [_achv objectForKey:kACHVMessage];
        
        //CGRectMake(25, 170, 200, 60)
        
        int fontSize = 13;
        CGSize makeSize;
        CGSize maxSize = CGSizeMake(196, 120);
        for (; fontSize >= 9; fontSize--) {
            CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:maxSize];
            makeSize = size;
            if (size.height <= 70) {
                break;
            }
        }
#ifdef ACHIEVEMENTS_DEBUG
        NSLog(@"%s%d",__FUNCTION__,fontSize);
#endif
        [message drawInRect:CGRectMake((235 - makeSize.width)/ 2, 168, makeSize.width, makeSize.height)
               withFont:[UIFont systemFontOfSize:fontSize]
          lineBreakMode:NSLineBreakByWordWrapping
              alignment:UITextAlignmentLeft];
    }
    
}


@end
