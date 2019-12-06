//
//  MYCircleView.m
//  DrawCircleDemo
//
//  Created by hukai on 2019/7/19.
//  Copyright © 2019 hukai. All rights reserved.
//

#import "MYCircleView.h"

@interface MYCircleView()
@property (nonatomic,assign) CGFloat BottomCircle;
@property (nonatomic,strong) CAShapeLayer *CircleLayer;
@property (nonatomic,strong) CAShapeLayer *ArcLayer;
@property (nonatomic, strong) UIBezierPath *CirclePath;
@property (nonatomic, strong) UIBezierPath *ArcPath;
@end

@implementation MYCircleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.BottomCircle = MIN(frame.size.width, frame.size.height) - 2*MAX(CircleBottomLineWidth, CircleTopLineWidth);
        CAShapeLayer *BottomLayer = [CAShapeLayer layer];
        UIBezierPath *BottomPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(MIN(frame.size.width, frame.size.height) / 2.0, MIN(frame.size.width, frame.size.height) / 2.0) radius:self.BottomCircle / 2.0 startAngle:0 endAngle:2 * M_PI clockwise:NO];
        BottomLayer.strokeColor = CircleBottomColor.CGColor;
        BottomLayer.fillColor = [UIColor clearColor].CGColor;
        BottomLayer.lineWidth = CircleBottomLineWidth;
        BottomLayer.path = BottomPath.CGPath;
        [self.layer addSublayer:BottomLayer];
        self.CircleLayer  = [CAShapeLayer layer];
        self.CircleLayer.lineWidth = 0;
        self.CircleLayer.strokeColor = [UIColor clearColor].CGColor;
        self.CircleLayer.fillColor = CircleTopCicleFillColor.CGColor;
//        self.CircleLayer.shadowColor = CircleTopCicleShadowColor.CGColor;
//        self.CircleLayer.shadowOffset = CGSizeZero;
//        self.CircleLayer.shadowOpacity = 1.0;
//        self.CircleLayer.shadowRadius = CircleShadowRadio;
//        [self.layer addSublayer:self.CircleLayer];
        self.ArcLayer  = [CAShapeLayer layer];
        self.ArcLayer.lineWidth = CircleTopLineWidth;
        self.ArcLayer.lineCap = kCALineCapRound;
        self.ArcLayer.strokeColor = DefaultGreenColor.CGColor;
        self.ArcLayer.fillColor = [UIColor clearColor].CGColor;
//        self.ArcLayer.shadowColor = CircleTopCicleShadowColor.CGColor;
//        self.ArcLayer.shadowOffset = CGSizeZero;
//        self.ArcLayer.shadowOpacity = 1.0;
//        self.ArcLayer.shadowRadius = CircleShadowRadio;
        [self.layer addSublayer:self.ArcLayer];
    }
    return self;
}

- (void)setPercent:(CGFloat)percent{
    _percent = percent;
    [self resetCircleLayer];
}

- (void)resetCircleLayer{
//    [self.CirclePath removeAllPoints];
    CGFloat percent = self.percent;
    CGFloat startAngle = -M_PI_2 + 2*M_PI*percent;
    CGFloat endAngle = -M_PI_2;
    CGFloat radius = self.BottomCircle/2.0;
    CGFloat centerRadio = (MIN(self.frame.size.width, self.frame.size.height))/2.0;
    CGPoint center1 = CGPointMake(centerRadio+radius*cos(startAngle),centerRadio+radius*sin(startAngle));
    CGPoint center2 = CGPointMake(centerRadio,centerRadio);
    UIBezierPath *centerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(centerRadio+radius*cos(startAngle)-CircleTopCicleRadio,centerRadio+radius*sin(startAngle)-CircleTopCicleRadio,2*CircleTopCicleRadio,2*CircleTopCicleRadio) cornerRadius:CircleTopCicleRadio];
//    self.CirclePath = centerPath;
    self.CircleLayer.path = centerPath.CGPath;
    self.CircleLayer.shadowPath = centerPath.CGPath;
    
    
    UIBezierPath *ArcPath = [UIBezierPath bezierPath];
//    ArcPath.lineCapStyle = kCGLineCapRound;
    [ArcPath addArcWithCenter:center2 radius:self.BottomCircle/2.0 startAngle:endAngle endAngle:startAngle clockwise:NO];
    
//    self.ArcPath = ArcPath;
    self.ArcLayer.path = ArcPath.CGPath;
    self.ArcLayer.shadowPath = (__bridge CGPathRef _Nullable)ArcPath;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
