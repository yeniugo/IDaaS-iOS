//
//  WebLoginTableViewBackImage.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2020/4/22.
//  Copyright © 2020 zyc. All rights reserved.
//

#import "WebLoginTableViewBackImage.h"

@implementation WebLoginTableViewBackImage
+ (UIImage *)createImageWithFrame:(CGRect)frame{
    // 描述矩形
        CGRect rect = frame;
        
        // 开启位图上下文
        UIGraphicsBeginImageContext(rect.size);
        // 获取位图上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        // 使用color演示填充上下文
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        // 渲染上下文
        CGContextFillRect(context, rect);
        
        CGMutablePathRef path = CGPathCreateMutable();
        //2-1.设置起始点
        CGPathMoveToPoint(path, NULL, 139, 70);
        //2-2.设置目标点
        CGPathAddLineToPoint(path, NULL, 139, frame.size.height);
    //    CGPathAddLineToPoint(path, NULL, 50, 200);
        
        CGPathCloseSubpath(path);
        //3.将路径添加到上下文
        CGContextAddPath(context, path);
        
        CGContextSetRGBFillColor(context, 0, 229.0/255.0, 229.0/255.0, 229.0/255.0);
        CGContextSetRGBStrokeColor(context, 229.0/255.0, 229.0/255.0, 229.0/255.0,1.0);
        
        CGContextSetLineWidth(context, 1.0f);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGPathRelease(path);
        // 从上下文中获取图片
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        // 结束上下文
        UIGraphicsEndImageContext();
        
        return image;
}
@end
