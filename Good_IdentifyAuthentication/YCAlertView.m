//
//  YCAlertView.m
//  YCAlertView
//
//  Created by zyc on 2017/11/1.
//  Copyright © 2017年 YC. All rights reserved.
//

#import "YCAlertView.h"
#define TagValue  3333
#define ALPHA  0.2 //背景
#define AlertTime 0.3 //弹出动画时间
#define DropTime 0.5 //落下动画时间




@interface YCAlertView()

@property(nonatomic,strong)UILabel *titleLB;
@property(nonatomic,strong)UITextView *ContentLB;
@property(nonatomic,strong)UIButton *cancleBtn;
@property(nonatomic,strong)UIButton *sureBtn;



@end

@implementation YCAlertView


-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title alertMessage:(NSString *)msg confrimBolck:(void (^)())confrimBlock cancelBlock:(void (^)())cancelBlock{
    if (self = [super initWithFrame:frame]) {
        [self customUIwith:frame title:title message:msg];
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
    }
    return self;
}


-(void)customUIwith:(CGRect)frame title:(NSString *)title message:(NSString *)msg{
    UIImageView *bgimageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    bgimageview.image = [UIImage imageNamed:@"alertbg"];
    [self addSubview:bgimageview];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
    _ContentLB = [[UITextView alloc] initWithFrame:CGRectMake(12, 20, 230, 80)];
    _ContentLB.editable = NO;
    _ContentLB.textColor = [UIColor darkGrayColor];
    _ContentLB.font = [UIFont systemFontOfSize:15];
    [self addSubview:_ContentLB];
    
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancleBtn setBackgroundImage:[UIImage imageNamed:@"alertCanclebtn"] forState:UIControlStateNormal];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _cancleBtn.frame = CGRectMake(20, 120, 70, 30);
    [self addSubview:_cancleBtn];
    [_cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureBtn setBackgroundImage:[UIImage imageNamed:@"alertSuerbtn"] forState:UIControlStateNormal];
    [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sureBtn.frame = CGRectMake(150, 120, 70, 30);
    [self addSubview:_sureBtn];
    [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];

    _titleLB.text = title;
    _ContentLB.text = msg;
    
}

-(void)cancleBtnClick{
    [self hide];
    if (_cancleBlock) {
        _cancleBlock();
    }
}
-(void)sureBtnClick{
    [self hide];
    if (_sureBlock) {
        _sureBlock();
    }
}


-(void)show{
    if (self.superview) {
        [self removeFromSuperview];
    }
    [self addViewInWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.center = [UIApplication sharedApplication].keyWindow.center;
    self.alpha = 0;
    self.transform = CGAffineTransformScale(self.transform,0.1,0.1);
    [UIView animateWithDuration:AlertTime animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    }];
}


/**
 加入背景view
 */
-(void)addViewInWindow{
    UIView *oldView = [[UIApplication sharedApplication].keyWindow viewWithTag:TagValue];
    if (oldView) {
        [oldView removeFromSuperview];
    }
    UIView *v = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    v.tag = TagValue;
    [self addGuesture:v];
    v.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    [[UIApplication sharedApplication].keyWindow addSubview:v];
    
}
//添加背景view手势
-(void)addGuesture:(UIView *)vi{
    vi.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [vi addGestureRecognizer:tap];
}

//弹出隐藏
-(void)hide{
    if (self.superview) {
        [UIView animateWithDuration:AlertTime animations:^{
            self.transform = CGAffineTransformScale(self.transform,0.1,0.1);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self hideAnimationFinish];
        }];
    }
}
-(void)hideAnimationFinish{
    UIView *bgvi = [[UIApplication sharedApplication].keyWindow viewWithTag:TagValue];
    if (bgvi) {
        [bgvi removeFromSuperview];
    }
    [self removeFromSuperview];
}
@end
