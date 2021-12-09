//
//  TRUAuthBtn.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/8/19.
//  Copyright © 2019 zyc. All rights reserved.
//

#import "TRUAuthBtn.h"

@implementation TRUAuthBtn

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(254, 199, 200 ,1.0 );
//        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16*PointWidthRatioX];
//        self.titleLabel.textColor = RGBCOLOR(255, 255, 255);
        [self setTitleColor:RGBCOLOR(206, 42, 43) forState:UIControlStateNormal];
//        self.titleLabel.frame = CGRectMake(20*PointWidthRatioX, 23*PointWidthRatioX, 292*PointWidthRatioX, 15*PointWidthRatioX);
        [self setImage:[UIImage imageNamed:@"blueArrow"] forState:UIControlStateNormal];
//        self.imageView.frame = CGRectMake(332*PointWidthRatioX, 23*PointWidthRatioX, 23*PointWidthRatioX, 15*PointWidthRatioX);
    }
    return self;
}

- (void)setButtonTitle:(NSString *)string{
//    self.titleLabel.text = string;
    [self setTitle:string forState:UIControlStateNormal];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(20*PointWidthRatioX, 23*PointWidthRatioX, 292*PointWidthRatioX, 15*PointWidthRatioX);
    self.imageView.frame = CGRectMake(332*PointWidthRatioX, 23*PointWidthRatioX, 23*PointWidthRatioX, 15*PointWidthRatioX);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
