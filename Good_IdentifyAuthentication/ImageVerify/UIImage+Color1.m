//
//  UIImage+Color1.m
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/12/20.
//  Copyright © 2021 zyc. All rights reserved.
//

#import "UIImage+Color1.h"

@implementation UIImage (Color1)
+ (UIImage *) ly_imageWithColor:(UIColor *)color {
    return [UIImage ly_imageWithColor:color Size:CGSizeMake(4.0f, 4.0f)];
}

+ (UIImage *) ly_imageWithColor:(UIColor *)color Size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image ly_stretched];
}

+ (UIImage *)  ly_imageWithFillColor:(UIColor *)FillColor lineColor:(UIColor *)lineColor Size:(CGSize)size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    UIColor * color1 = [UIColor yellowColor];
        //使用上面设置的颜色进行填充.
    [color1 setFill];
//    CGContextRef context =UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:10.0];
    [FillColor setFill];
    [lineColor setStroke];
    path.lineWidth = 2;
    [path fill];
    [path stroke];
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return [image ly_stretched];
}

- (UIImage *) ly_stretched
{
    CGSize size = self.size;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(truncf(size.height-1)/2, truncf(size.width-1)/2, truncf(size.height-1)/2, truncf(size.width-1)/2);
    
    return [self resizableImageWithCapInsets:insets];
}
@end
