//
//  JWVerticalSliderView.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/23/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//


#import "JWVerticalSliderView.h"

const float margin = 10.f;//进度条起点
const float progressBarLength = 295.f;//进度条长度
const float progressBarWidh = 16.f;//宽度
const int progressColor[12] = {235, 190, 32, 236, 136, 30, 243, 186, 121, 102, 159, 194};//三个一组，组成颜色
const float thumbViewCenterX = 60.f;
//右边竖向的Slider

@interface JWVerticalSliderView (){
    float allstageSum;//总时间
    CGPoint lastLocation;//上次移动的位置
}

@property (nonatomic, weak) UIImageView *thumbImageView;//滑块的imageVierw
@property (nonatomic, weak) UIView *thumbView;//滑块的Control
@property (nonatomic) BOOL canMove;//true，进入可移动状态
@property (nonatomic) float value;//滑动的偏移量
@property (nonatomic, copy) VerticalSliderValueChangeBlock verticalSliderBlack;//当改变阶段时候用来回调
@property (nonatomic, strong) NSArray *stagesValue;//所有阶段的值
@property (nonatomic, strong) NSArray *stagesFrameY;//每个阶段的开始的y值；


@end


@implementation JWVerticalSliderView

@synthesize canMove = _canMove;
@synthesize value = _value;
@synthesize verticalSliderBlack = _verticalSliderBlack;
@synthesize stagesValue = _stagesValue;
@synthesize selectIndex = _selectIndex;
@synthesize stagesFrameY = _stagesFrameY;

-(void)setAction:(VerticalSliderValueChangeBlock)action{
    //设置回调事件
    self.verticalSliderBlack = action;
}

- (void)dealloc
{
#ifdef RUN_DEBUG
    NSLog(@"%s",__FUNCTION__);
#endif
}

- (id)initWithStagesValue:(NSArray *)values total:(float)allTime
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.stagesValue = values;
        allstageSum = allTime;
        self.selectIndex = 0;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, 80, 325)];
    if (self) {
        // Initialization code
        [self loadSubView];
        UILongPressGestureRecognizer *LongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(longPress:)];
        [self.thumbView addGestureRecognizer:LongPress];
        LongPress.minimumPressDuration = .3f;//默认值 0.5
        LongPress.allowableMovement = 30.f;
        self.backgroundColor = [UIColor clearColor];//在dewaRect中不知道怎么画出来
    }
    return self;
}

-(void)loadSubView{
    UIView *control = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    control.userInteractionEnabled = YES;
    control.center = CGPointMake(thumbViewCenterX, margin);
    [self addSubview:control];
    self.thumbView = control;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"running_unselect_ringht_slider"]];
    [control addSubview:imageView];
    imageView.center = CGPointMake(control.bounds.size.width/2 - 25, control.bounds.size.height/2);
    self.thumbImageView = imageView;
    
}

-(void)layoutSubviews{
    float begin = [[self.stagesFrameY objectAtIndex:_selectIndex] floatValue];
    float end = [[self.stagesFrameY objectAtIndex:_selectIndex + 1] floatValue];
    float  y = (begin + end)/2;
    self.thumbView.center = CGPointMake(thumbViewCenterX, y);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //根据所有阶段值，画出进度条
    //按比例画出
    UIImage *bgImage = [UIImage imageNamed:@"running_right_progress_bar_bg"];
    [bgImage drawAtPoint:CGPointMake(margin - 6, margin - 6)];
    
    NSArray *typeArray = [_stagesValue objectAtIndex:0];
    NSArray *timeArray = [_stagesValue objectAtIndex:1];
    
    float y = margin;
    
    NSMutableArray *arrayY = [[NSMutableArray alloc] initWithCapacity:typeArray.count];
    for (int i = 0 ; i < typeArray.count; i ++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        float time = [[timeArray objectAtIndex:i] floatValue];
        float height = time/allstageSum * progressBarLength;
        CGRect frame = CGRectMake(margin, y, progressBarWidh, height -1);
        // 设置颜色
        NSString *str = [typeArray objectAtIndex:i];
        int colorIndex = 0;
        if ([str isEqualToString:@"Warm up"]) {
            colorIndex = 0;
        }else if ([str isEqualToString:@"Run"]){
            colorIndex = 1;
        }else if ([str isEqualToString:@"Walk"]){
            colorIndex = 2;
        }else if ([str isEqualToString:@"Cool down"]){
            colorIndex = 3;
        }
        CGContextSetFillColorWithColor(context, [kRGB255UIColor(progressColor[0 + colorIndex * 3], progressColor[1 + colorIndex * 3], progressColor[2 + colorIndex * 3], 1.f) CGColor]);
        addRoundedRectToPath(context, frame, 3.0f, 3.0f);
        //保存下来，以便以后判断用
        [arrayY addObject:[NSNumber numberWithFloat:y]];
        y += height;
        CGContextFillPath(context);
    }
    [arrayY addObject:[NSNumber numberWithFloat:margin + progressBarLength]];
    self.stagesFrameY = arrayY;
    [self setNeedsLayout];
}

// 画出圆角矩形背景
static void addRoundedRectToPath(CGContextRef context, CGRect rect,
                                 float ovalWidth,float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) { // 1
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context); // 2
    CGContextTranslateCTM (context, CGRectGetMinX(rect), // 3
                           CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight); // 4
    fw = CGRectGetWidth (rect) / ovalWidth; // 5
    fh = CGRectGetHeight (rect) / ovalHeight; // 6
    CGContextMoveToPoint(context, fw, fh/2); // 7
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1); // 8
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // 9
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // 10
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // 11
    CGContextClosePath(context); // 12
    CGContextRestoreGState(context); // 13
}

#pragma mark - get/set

-(void)setSelectIndex:(NSInteger )selectIndex{
    NSArray *array = [self.stagesValue objectAtIndex:0];
    if (selectIndex >= array.count) {
        return;
    }
    _selectIndex = selectIndex;
    [self setNeedsLayout];
}


#pragma mark - action

-(void)longPress:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        self.canMove = YES;
        [self.thumbImageView setImage:[UIImage imageNamed:@"running_select_ringht_slider"]];
        lastLocation = [gestureRecognizer locationInView:self];//取相对于父视图的位置
    }else if([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        self.canMove = NO;
        [self.thumbImageView setImage:[UIImage imageNamed:@"running_unselect_ringht_slider"]];
        [self moveToStageCenter];
    }else if([gestureRecognizer state] == UIGestureRecognizerStateChanged){
        if (self.canMove) {
            CGPoint location = [gestureRecognizer locationInView:self];//取相对于父视图的位置
            float dy = location.y - lastLocation.y;
            if (self.thumbView.center.y + dy < margin + progressBarLength && self.thumbView.center.y + dy> margin) {
                self.thumbView.frame = CGRectOffset(self.thumbView.frame, 0, dy);
                lastLocation = location;
            }
        }

    }
}


-(void)moveToStageCenter{
    for (int i = 0; i < self.stagesFrameY.count  - 1; i ++) {
        float begin = [[self.stagesFrameY objectAtIndex:i] floatValue];
        float end = [[self.stagesFrameY objectAtIndex:i + 1] floatValue];
        if (self.thumbView.center.y >= begin && self.thumbView.center.y <= end) {
            int tmp = self.selectIndex;
            self.selectIndex = i;
            if (i != tmp) {
                _verticalSliderBlack(self);
            }
            return;
        }
    }
}

@end
