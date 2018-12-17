//
//  TRUDynamicCodeLabel.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/14.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUDynamicCodeLabel.h"

@implementation TRUDynamicCodeLabel

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //        [self drawTextInRect:frame];
        //        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}
- (void)setText:(NSString *)text{
    [super setText:text];
    //手动调用drawRect方法
    [self setNeedsDisplay];
}
//
-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth ;
    [self setNeedsDisplay];
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

-(void)setSpacing:(CGFloat)spacing{
    _spacing = spacing;
    [self setNeedsDisplay];
}

-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    [self setNeedsDisplay];
}
- (void)setFont:(UIFont *)font{
    [super setFont:font];
    [self setNeedsLayout];
}
- (void)drawTextInRect:(CGRect)rect{
    
    
    //计算每位验证码/密码的所在区域的宽和高
    float width = (rect.size.width - (self.text.length+1) * self.spacing - self.midSpacing)/ (float)self.text.length ;
    float height = rect.size.height;
    
    // 画矩形边框
    for (int i = 0; i < self.text.length; i++) {
        //        int counti = i > 4 ? (i -1) : i;
        CGRect tempRect = CGRectMake(i * (width +self.spacing) + self.spacing + self.lineWidth, self.lineWidth, width - self.lineWidth*2, height - self.lineWidth*2);
       
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:tempRect cornerRadius:self.cornerRadius];
        
        CGContextAddPath(context, bezierPath.CGPath);
        
        [RGBCOLOR(223, 223, 223) setFill];
        CGContextAddPath(context, bezierPath.CGPath);
        CGContextFillPath(context);
        
    }
    
    // 将每位验证码/密码绘制到指定区域
    for (int i = 0; i < self.text.length; i++) {
        CGRect tempRect = CGRectMake(i * (width +self.spacing)+self.spacing +self.lineWidth, self.lineWidth, width - self.lineWidth * 2, height - self.lineWidth*2);
        
       
        // 遍历验证码/密码的每个字符
        NSString *charecterString = [NSString stringWithFormat:@"%c", [self.text characterAtIndex:i]];
        // 设置验证码/密码的现实属性
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        attributes[NSFontAttributeName] = self.font;
        attributes[NSForegroundColorAttributeName] = self.textColor;
        // 计算每位验证码的绘制起点
        // 计算每位验证码的在指定样式下的size
        CGSize characterSize = [charecterString sizeWithAttributes:attributes];
        CGPoint vertificationCodeDrawStartPoint = CGPointMake(CGRectGetMidX(tempRect) - characterSize.width /2, CGRectGetMidY(tempRect) - characterSize.height /2);
        // 绘制验证码
        [charecterString drawAtPoint:vertificationCodeDrawStartPoint withAttributes:attributes];
        
    }
}

@end
