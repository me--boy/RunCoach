//
//  JWSegmentedControl.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/11/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWSegmentedControl.h"

@interface JWSegmentedControl ()

@property (nonatomic, copy)ActionBlock actionBlock;
@property (nonatomic, copy)NSArray *images;//unselect
@property (nonatomic, copy)NSArray *selectedImage;//selected


@end

@implementation JWSegmentedControl

@synthesize actionBlock = _actionBlock;

- (void)dealloc
{
#ifdef SETTING_DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithImages:(NSArray *)images SelectImages:(NSArray *)selectImages{
    self = [super init];
    if (self) {
        self.images = images;
        self.selectedImage = selectImages;
        
        UIImage * image = [self.images objectAtIndex:0];
        CGSize size = image.size;
        self.frame = CGRectMake( 0, 0, size.width * self.images.count, size.height);
        for (int i = 0; i < self.images.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * size.width, 0, size.width, size.height)];
            button.backgroundColor = [UIColor colorWithPatternImage:[self.images objectAtIndex:i]];
            button.adjustsImageWhenHighlighted = NO;
            button.tag = i;
            [button addTarget:self
                       action:@selector(buttonPressed:)
             forControlEvents:UIControlEventTouchDown];
            [self addSubview:button];
        }
        self.selectedIndex = 0;
        
    }
    return self;
}

- (void)addaction:(ActionBlock)action{
    self.actionBlock = action;
}

-(void)buttonPressed:(id)sender{
    if (![sender isKindOfClass:[UIButton class]]) {
        return;
    }
    UIButton *button = (UIButton *)sender;
    self.selectedIndex = button.tag;
    if (_actionBlock) {
        _actionBlock(self);
    }
}


-(void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *unselectedButton = (UIButton *)view;
            if (unselectedButton.tag != selectedIndex) {
                unselectedButton.backgroundColor = [UIColor colorWithPatternImage:self.images[unselectedButton.tag]];
                unselectedButton.userInteractionEnabled = YES;
            }else{
                unselectedButton.backgroundColor = [UIColor colorWithPatternImage:self.selectedImage[unselectedButton.tag]];
                unselectedButton.userInteractionEnabled = NO;
            }
            
        }
    }
}

@end
