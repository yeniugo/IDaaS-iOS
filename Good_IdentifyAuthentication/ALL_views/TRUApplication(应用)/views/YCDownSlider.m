//
//  YCDownSlider.m
//  lottie_jsonTest
//
//  Created by zyc on 2017/10/23.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "YCDownSlider.h"
#import <Lottie/Lottie.h>
@implementation YCDownSlider
{
    UIButton *downBtn;
    
    LOTAnimationView *lbImageView;
    
    CGFloat topSpace;
    
    CGFloat blockLength;
    
    CGFloat currentValue;

}



- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{

    topSpace = 15;
    blockLength = 220 - 2*topSpace - 46;
    UIImageView *bgImageVidew = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 220)];
    [self addSubview:bgImageVidew];
    bgImageVidew.image = [UIImage imageNamed:@"pushSliderbg.jpg"];
    
    lbImageView = [LOTAnimationView animationNamed:@"pushjiantou.json"];
    [self addSubview:lbImageView];
    lbImageView.frame = CGRectMake(25, 90, 20, 80);
    lbImageView.loopAnimation = YES;
    [lbImageView play];
    
    downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downBtn.backgroundColor = [UIColor clearColor];
//    downBtn.adjustsImageWhenHighlighted = NO;
    [downBtn setImage:[UIImage imageNamed:@"pushSliderimg.jpg"] forState:UIControlStateNormal];
    downBtn.frame = CGRectMake(12, 15, 46, 46);
    [self addSubview:downBtn];
    
    UIPanGestureRecognizer *downButtonPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(downButtonPanAction:)];
    [downButtonPan setMaximumNumberOfTouches:1];
    [downBtn addGestureRecognizer:downButtonPan];
}

- (void)downButtonPanAction:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan locationInView:self];
    static CGFloat lastY ;
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            [self bringSubviewToFront:downBtn];
            lastY = point.y;
            break;
            
        case UIGestureRecognizerStateChanged:{
            CGFloat Y = (point.y -topSpace);
            if (point.y <= topSpace*2) {
                Y = 15.f;
            }else if (point.y >= (topSpace +blockLength)){
                Y = topSpace +blockLength;
            }else{
                Y = point.y - topSpace;
            }
            lastY = Y;
            currentValue = Y/179.f;
            [self didcurrentDownBtnValueChanged];
            downBtn.frame = CGRectMake(12, Y, 46, 46);
            if (Y != 15) {
                lbImageView.hidden = YES;
            }else{
                lbImageView.hidden = NO;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            //判断提示图片是否出现
            if (lastY != 15) {
                lbImageView.hidden = YES;
            }else{
                lbImageView.hidden = NO;
            }
            [self didcurrentDownBtnValueEnd];
            break;
        }
        default:
            break;
    }
}

- (void)didcurrentDownBtnValueChanged{
    if (self.sliderValueChanged) {
        self.sliderValueChanged(currentValue);
    }
}
- (void)didcurrentDownBtnValueEnd{
    if (self.sliderValueEnd) {
        self.sliderValueEnd(currentValue);
    }
}


@end
