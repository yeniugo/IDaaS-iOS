//
//  UIImage+Resize.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/19.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)
- (UIImage *)stretchImageWithFLeftCapWidth:(CGFloat)fLeftCapWidth
                             fTopCapHeight:(CGFloat)fTopCapHeight
                                 desWidth:(CGFloat)desWidth
                                 desHeight:(CGFloat)desHeight
                             sLeftCapWidth:(CGFloat)sLeftCapWidth
                             sTopCapHeight:(CGFloat)sTopCapHeight
{
    UIImage *image1 = [self stretchableImageWithLeftCapWidth:fLeftCapWidth topCapHeight:fTopCapHeight];
    CGSize imageSize = self.size;
    CGFloat tpw = desWidth * 0.5 + imageSize.width * 0.5;
    CGFloat tw = tpw > desWidth ? desWidth : tpw;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(tw, desHeight), NO, [UIScreen mainScreen].scale);
    [image1 drawInRect:CGRectMake(0, 0, tw, desHeight)];
    UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image2 stretchableImageWithLeftCapWidth:sLeftCapWidth topCapHeight:sTopCapHeight];
}
- (UIImage *)resizeImageWithSize:(CGSize)size{

    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片  
    return scaledImage;
}
@end
