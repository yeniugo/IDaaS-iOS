//
//  TRUTabBar.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/10.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUTabBar.h"
#import "TRUButton.h"
#import "UIImage+Resize.h"
#import "UIColor+HEX.h"
#import "UIView+FrameExt.h"

@interface TRUTabBar ()
@property (nonatomic, weak) TRUButton *scanLoginBtn;
@property (nonatomic, weak) UIImageView *bgImgView;
@end

@implementation TRUTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit{
    
    UIColor *normalColor = [UIColor colorWithHex:@"0x777777"];
    UIColor *selectColor = [UIColor colorWithHex:@"0x2669E7"];
    TRUButton *scanLoginBtn = [TRUButton buttonWithType:UIButtonTypeCustom];
    [scanLoginBtn setImage:[UIImage imageNamed:@"scanlogin_normal"] forState:UIControlStateNormal];
     [scanLoginBtn setImage:[UIImage imageNamed:@"scanlogin_selected"] forState:UIControlStateHighlighted];
    [scanLoginBtn setTitleColor:normalColor forState:UIControlStateNormal];
    [scanLoginBtn setTitleColor:selectColor forState:UIControlStateHighlighted];
    scanLoginBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [scanLoginBtn setTitle:@"扫一扫" forState:UIControlStateNormal];
    [scanLoginBtn addTarget:self action:@selector(scanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.scanLoginBtn = scanLoginBtn];
    
    
    self.backgroundImage = [UIImage new];
//    self.clipsToBounds = YES;
    self.shadowImage = [UIImage new];
    UIImage *img = [UIImage imageNamed:@"tabbarbg"];
    
    CGFloat tw = [UIScreen mainScreen].bounds.size.width;
    CGFloat iw = img.size.width;
    if (tw > iw) {
        CGFloat th = tw / iw * img.size.height;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(tw, th), NO, [UIScreen mainScreen].scale);
        [img drawInRect:CGRectMake(0, 0, tw, th)];
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
   

    UIImageView *imagev = [[UIImageView alloc] initWithFrame:self.bounds];
    imagev.contentMode = UIViewContentModeCenter;
    imagev.image = img;
//    imagev.y = -39.0;
    imagev.userInteractionEnabled = YES;
    [self insertSubview:self.bgImgView = imagev atIndex:0];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.bgImgView.frame = self.bounds;
    self.bgImgView.y = -20.0;
    // 2.设置其他tabbarButton的frame
    CGFloat tabBarButtonW = self.width / 5;
    CGFloat tabBarButtonIndex = 0;
    self.scanLoginBtn.size = CGSizeMake(tabBarButtonW, self.height + self.height * 0.5);
    // 1.设置扫描按钮的位置
    self.scanLoginBtn.centerX = self.width*0.5;
    self.scanLoginBtn.centerY = self.height*0.5 - self.height * 0.3;
    
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置x
            child.x = tabBarButtonIndex * tabBarButtonW;
            // 设置宽度
            child.width = tabBarButtonW;
            // 增加索引
            tabBarButtonIndex++;
            if (tabBarButtonIndex == 2) {
                tabBarButtonIndex++;
            }
        }
    }
}
- (void)scanButtonClick:(UIButton *)btn{
    if ([self.scanButtonDelegate respondsToSelector:@selector(scanQRButtonClick)]) {
        [self.scanButtonDelegate scanQRButtonClick];
    }
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
  
//    CGPoint currentP = [self.scanLoginBtn convertPoint:point toView:self];
//    if ([self.scanLoginBtn pointInside:currentP withEvent:event]) {
//        return self.scanLoginBtn;
//    }
//
//    return [super hitTest:point withEvent:event];
    if (self.hidden || self.alpha <= 0.01 || !self.userInteractionEnabled) return nil;
    CGPoint btnP = [self.scanLoginBtn convertPoint:point fromView:self];
    if ([self.scanLoginBtn pointInside:btnP withEvent:event]) {
        return self.scanLoginBtn;
    }
    
    return [super hitTest:point withEvent:event];

}

@end
