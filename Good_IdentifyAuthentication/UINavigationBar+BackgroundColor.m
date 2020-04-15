//
//  UINavigationBar+BackgroundColor.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/9.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "UINavigationBar+BackgroundColor.h"
#import <objc/runtime.h>

@implementation UINavigationBar (BackgroundColor)
static char overlayKey = '\0';
- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)tru_setBackgroudColor:(UIColor *)backgroudColor{
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        if (kDevice_Is_iPhoneX) {
            self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 45)];
        }
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;    // Should not set `UIViewAutoresizingFlexibleHeight`
        [[self.subviews firstObject] insertSubview:self.overlay atIndex:0];
        //        [self.subviews insertSubview:self.overlay atIndex:0];
        if(self.subviews.count==0){
            [self addSubview:self.overlay];
            self.overlay.frame = CGRectMake(0, -20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)+ 20 );
            if (kDevice_Is_iPhoneX) {
                self.overlay.frame = CGRectMake(0, -44, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 45);
            }
            //            [[self.subviews firstObject] insertSubview:self.overlay atIndex:0];
        }
    }else{
        [self.overlay.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
    self.overlay.backgroundColor = backgroudColor;
//    if (!self.overlay) {
//        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
//        self.overlay.userInteractionEnabled = NO;
//        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;    // Should not set `UIViewAutoresizingFlexibleHeight`
//        [[self.subviews firstObject] insertSubview:self.overlay atIndex:0];
//    }else{
//        [self.overlay.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [obj removeFromSuperview];
//        }];
//    }
//    self.overlay.backgroundColor = backgroudColor;
}
-(void)didAddSubview:(UIView *)subview{
    [super didAddSubview:subview];
    if(@available(iOS 12.0,*)){
        if (self.subviews.count >= 3) {
            //            YCLog(@"tabbar.subviews = %@",self.subviews);
            //            int i = 0;
            //            for (UIView *view in self.subviews) {
            //                if ([view isKindOfClass:[UIView class]]) {
            //                    i++;
            //                }
            //
            //            }
            //            YCLog(@"uiviewclasscount = %d",i);
            if (self.subviews[1]!=self.overlay) {
                [self insertSubview:self.overlay aboveSubview:[self.subviews firstObject]];
            }
        }
    }
}

- (void)tru_setBackgroudColors:(NSArray *)backgroudColors{
    UIColor *startcolor = [backgroudColors firstObject];
    UIColor *endcolor = [backgroudColors lastObject];
    UIGraphicsBeginImageContext(self.bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    [path closePath];
    [self drawLinearGradient:context path:path.CGPath startColor:startcolor.CGColor endColor:endcolor.CGColor];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        self.overlay.userInteractionEnabled = NO;
       
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;    // Should not set `UIViewAutoresizingFlexibleHeight`
        [[self.subviews firstObject] insertSubview:self.overlay atIndex:0];
    }
    imgView.frame = self.overlay.bounds;
    [self.overlay addSubview:imgView];
    
}


- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), 0);
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
@end
