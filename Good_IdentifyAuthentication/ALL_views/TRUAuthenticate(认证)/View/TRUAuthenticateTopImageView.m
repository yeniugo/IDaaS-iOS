//
//  TRUAuthenticateTopImageView.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/31.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUAuthenticateTopImageView.h"
#import "TRUCompanyAPI.h"
#import <YYWebImage.h>
@interface TRUAuthenticateTopImageView()
@property (nonatomic,strong) UIImageView *backgroundImageView;
@end

@implementation TRUAuthenticateTopImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
        self.backgroundImageView = backgroundImageView;
        [self addSubview:backgroundImageView];
        if (kDevice_Is_iPhoneX) {
            backgroundImageView.image = [UIImage imageNamed:@"bannerX"];
        }else{
            backgroundImageView.image = [UIImage imageNamed:@"banner"];
        }
        self.logImageView = [[UIImageView alloc] init];
//        self.logImageView.image = [UIImage imageNamed:@"shanreniIcon"];
        NSString *imgurlstr = [TRUCompanyAPI getCompany].logo_url;
//        [self.logImageView yy_setImageWithURL:[NSURL URLWithString:imgurlstr] placeholder:[UIImage imageNamed:@"shanreniIcon"]];
        self.logImageView.image = [UIImage imageNamed:@"shanreniIcon"];
        [self addSubview:self.logImageView];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 15)];
        self.titleLabel.text = @"“临商认证”您的身份安全守护者";
        self.titleLabel.textColor = [UIColor whiteColor];
//        self.titleLabel.adjustsFontSizeToFitWidth=YES;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        self.detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 12)];
        self.detailsLabel.textColor = [UIColor whiteColor];
        self.detailsLabel.font = [UIFont systemFontOfSize:12];
        self.detailsLabel.textAlignment = NSTextAlignmentCenter;
//        self.detailsLabel.adjustsFontSizeToFitWidth=YES;
        [self addSubview:self.detailsLabel];
    }
    return self;
}

- (void)setAuthNumber:(NSInteger)number{
    NSLog(@"今日验证次数:  %ld",number);
    self.detailsLabel.text = [NSString stringWithFormat:@"今日认证次数:  %ld",number];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundImageView.frame = self.bounds;
    CGFloat imageW,imageH;
    imageW  = 102;
    imageH  = 102;
    self.logImageView.frame = CGRectMake((self.bounds.size.width-imageW)/2, (self.bounds.size.height-imageH)/2,imageW ,imageH);
    
    self.titleLabel.centerX = self.bounds.size.width/2;
    self.titleLabel.centerY = self.logImageView.centerY + imageH/2 ;
    if (kDevice_Is_iPhoneX) {
        self.titleLabel.centerY = self.logImageView.centerY + imageH/2 ;
    }
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.detailsLabel.text = @"今日认证次数:  0";
    self.detailsLabel.centerX = self.bounds.size.width/2;
    self.detailsLabel.centerY = self.titleLabel.centerY + 20;
}

@end
