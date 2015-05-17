//
//  BSPageControl.m
//  Money Monitor
//
//  Created by YQ006 on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JWPageControl.h"

@implementation JWPageControl


- (void) dealloc
{
#ifdef ACHIEVEMENTS_DEBUG
    NSLog(@"%s",__FUNCTION__);
#endif
}

- (void) updateDots
{
    NSArray* dotViews = self.subviews;
    for(int i = 0; i < dotViews.count; ++i)
    {
        id content = [dotViews objectAtIndex:i];
        if ([content isKindOfClass:[UIImageView class]]) {
            UIImageView* dot = content;
            // Set image
            dot.image = (i == self.currentPage) ? [UIImage imageNamed:@"page_select"] : [UIImage imageNamed:@"page"];
        }
    }
}

- (void) setNumberOfPages:(NSInteger)numberOfPages {
    [super setNumberOfPages:numberOfPages];
    
    [self updateDots];
}

/** override to update dots */
- (void) setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    
    // update dot views
    [self updateDots];
}

/** override to update dots */
- (void) updateCurrentPageDisplay
{
    [super updateCurrentPageDisplay];
    
    // update dot views
    [self updateDots];
}

- (void) endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event 
{
    [super endTrackingWithTouch:touch withEvent:event];
    
    [self updateDots];
}

@end
