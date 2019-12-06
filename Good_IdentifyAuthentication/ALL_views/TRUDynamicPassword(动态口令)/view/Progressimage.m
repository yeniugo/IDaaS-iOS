//
//  progressimage.m
//  coreanimatetest
//
//  Created by hukai on 2019/4/10.
//  Copyright © 2019 hukai. All rights reserved.
//

#import "Progressimage.h"

@interface Progressimage ()
{
    float angle;
}
@end

@implementation Progressimage

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    angle = 270.0/60;
    return self;
}

- (void)setProgress:(float)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //获得处理的上下文
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 1);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
//    CGContextSetRGBStrokeColor(context, 255.0 / 255.0, 0 / 255.0, 0 / 255.0, 1.0);
    UIColor *backgroundcolor = DefaultGreenColor;
    UIColor *showcolor = [UIColor yellowColor];
    CGFloat radius = self.bounds.size.width>self.bounds.size.height?self.bounds.size.height/2.0:self.bounds.size.width/2.0;
    
    for (int i = 0; i < 60; i++) {
        CGContextBeginPath(context);
//        NSLog(@"progress = %f,progress*60= %.2f",self.progress,self.progress*60);
        if (self.progress*60>=i) {
//            color = [UIColor redColor];
            CGFloat *components =  CGColorGetComponents(backgroundcolor.CGColor);
            CGContextSetRGBStrokeColor(context, components[0], components[1], components[2], 1.0);
        }else{
//            color = [UIColor blueColor];
//            CGFloat *components =  CGColorGetComponents(showcolor.CGColor);
//            NSLog(@"%.2f,%.2f,%.2f",components[0], components[1], components[2]);
            NSString *RGBValue = [NSString stringWithFormat:@"%@",showcolor];
            NSArray *RGBArr = [RGBValue componentsSeparatedByString:@" "];
            CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.05);
        }
//        self.transform = CGAffineTransformMakeRotation(angle*i);
//        CGContextRotateCTM(context,-M_PI*0.75/30*i);
//        [self drawlinewithcontext:context];
        CGFloat lastangle = -angle*(i)-135-angle*0.5;
        CGContextMoveToPoint(context, radius+0.95*radius*cos(M_PI/180*lastangle)+0.05*0.95*radius, radius-0.95*radius*sin(M_PI/180*lastangle));  //起点坐标
        CGContextAddLineToPoint(context, radius+radius*0.8*cos(M_PI/180*lastangle)+0.05*0.95*radius, radius-radius*0.8*sin(M_PI/180*lastangle));
//        CGContextRotateCTM(context,0);
        CGContextStrokePath(context);
    }
    
//    CGContextRotateCTM(context,M_PI*0.75/30);
//    [self drawlinewithcontext:context];
//    CGContextStrokePath(context);
//    self.transform = CGAffineTransformMakeRotation(0);
//    CGContextRotateCTM(context,-M_PI_4);
//    [self drawline2];
//    CGContextRotateCTM(context,0);
}

- (void)drawlinewithcontext:(CGContextRef)context{
//    CGContextRef context = UIGraphicsGetCurrentContext();
      //线的颜色
    
    CGFloat radius = 100;
    CGContextMoveToPoint(context, 100, radius);  //起点坐标
    CGContextAddLineToPoint(context, 100, radius - 60);   //终点坐标
//    CGContextMoveToPoint(context, 20, radius);
//    CGContextAddLineToPoint(context, 20, radius - 60);
//    CGContextStrokePath(context);
}

- (void)drawLine
{
    //1.获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //2.设置当前上下问路径
    //设置起始点
    float radius=200;
    CGMutablePathRef path = CGPathCreateMutable();
    //2-1.设置起始点
    CGPathMoveToPoint(path, NULL, 0, radius);
    //2-2.设置目标点
    CGPathAddLineToPoint(path, NULL, 0, radius);
    
    CGPathAddLineToPoint(path, NULL, 0, radius - 60);
    //封闭路径
    //第一种方法
    //CGPathAddLineToPoint(path, NULL, 50, 50);
    //第二张方法
    CGPathCloseSubpath(path);
    //3.将路径添加到上下文
    CGContextAddPath(context, path);
    //4.设置上下文属性
    //4.1.设置线条颜色
    /*
     red 0～1.0  red / 255
     green 0～1.0  green / 255
     blue 0～1.0  blue / 255
     plpha   透明度  0 ～ 1.0
     0 完全透明
     1.0 完全不透明
     提示：在使用rgb设置颜色时。最好不要同时指定rgb和alpha,否则会对性能造成影响。
     
     线条和填充默认都是黑色
     */
    CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1.0);
    //设置填充颜色
    CGContextSetRGBFillColor(context, 0, 1.0, 0, 1.0);
    //4.2 设置线条宽度
    CGContextSetLineWidth(context, 3.0f);
    //设置线条顶点样式
    CGContextSetLineCap(context, kCGLineCapRound);
    //设置连接点的样式
    CGContextSetLineJoin(context, kCGLineJoinRound);
    //设置线条的虚线样式
    /*
     虚线的参数：
     phase：相位，虚线的起始位置＝通常使用 0 即可，从头开始画虚线
     lengths:长度的数组
     count ： lengths 数组的个数
     */
    CGFloat lengths[2] = {20.0,10.0};
    CGContextSetLineDash(context, 0, lengths, 3);
    //5.绘制路径
    /*
     kCGPathStroke:划线（空心）
     kCGPathFill: 填充（实心）
     kCGPathFillStroke：即划线又填充
     */
    CGContextDrawPath(context, kCGPathFillStroke);
    //6.释放路径
    CGPathRelease(path);
}


@end
