//
//  TRUAuthenticateBtn.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/31.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUAuthenticateBtn.h"
#import "TRURoundNumberBtn.h"
#import "UIImage+Color.h"
@interface TRUAuthenticateBtn()

//@property (nonatomic,strong) CALayer *shadowLayer;
@property (nonatomic,strong) TRURoundNumberBtn *roundBtn;
@end

@implementation TRUAuthenticateBtn



-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor whiteColor];
        UIImageView *iconImageView = [[UIImageView alloc] init];
        self.iconImageView = iconImageView;
        [self addSubview:iconImageView];
        UILabel *textLabel = [[UILabel alloc] init];
        self.textLabel = textLabel;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightThin];
        [self addSubview:textLabel];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds =YES;
//        self.backgroundColor = [UIColor whiteColor];
        
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(233, 240, 243)] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(233, 240, 243)] forState:UIControlStateSelected];
        self.roundBtn = [TRURoundNumberBtn buttonWithType:UIButtonTypeCustom];
        self.roundBtn.hidden = YES;
        [self addSubview:self.roundBtn];
        
    }
    return self;
}

- (void)setAuthNumber:(NSInteger)number{
    YCLog(@"number = %d",number);
    if (number==0) {
        self.roundBtn.hidden = YES;
    }else{
        self.roundBtn.hidden = NO;
//        self.roundBtn.titleLabel.text = [NSString stringWithFormat:@"%ld",number];
//        [self.roundBtn setTitle:[NSString stringWithFormat:@"%ld",number] forState:UIControlStateNormal];
        [self.roundBtn setAuthNumber:number];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)layoutSubviews{
    [super layoutSubviews];
    
//    self.shadowLayer.frame = self.bounds;
//    self.layer.frame = self.frame;
    CGFloat iconImageH = 32*PointHeightRatio6;
    CGFloat iconImageW = 40*PointHeightRatio6;
    CGFloat iconImageX = (self.bounds.size.width - iconImageW)/2;
    CGFloat iconImageY = self.bounds.size.height*0.32;
    self.iconImageView.frame = CGRectMake(iconImageX, iconImageY, iconImageW, iconImageH);
    
    CGFloat textLabelH = 16;
    CGFloat textLabelW = self.bounds.size.width;
    CGFloat textLabelX = 0;
    CGFloat textLabelY = self.bounds.size.height*0.8-textLabelH;
    self.textLabel.frame = CGRectMake(textLabelX, textLabelY, textLabelW, textLabelH);
    
    CGFloat roundBtnW = self.roundBtn.frame.size.width;
    CGFloat roundBtnH = self.roundBtn.frame.size.height;
    CGFloat roundBtnX = self.bounds.size.width - roundBtnW - 10;
    CGFloat roundBtnY = 10;
    self.roundBtn.frame = CGRectMake(roundBtnX, roundBtnY, roundBtnW, roundBtnH);
    YCLog(@"TRURoundNumberBtn.frame = %@,TRUAuthenticateBtn.frame = %@",NSStringFromCGRect(self.roundBtn.frame),NSStringFromCGRect(self.frame));
}


@end
