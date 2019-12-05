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
#import "AppDelegate.h"
@interface TRUAuthenticateTopImageView()
@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,assign) int number;
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
        NSString *imgurlstr;
        if (isCustom) {
            imgurlstr = nil;
        }else{
            imgurlstr = [TRUCompanyAPI getCompany].logo_url;
        }
        [self.logImageView yy_setImageWithURL:[NSURL URLWithString:imgurlstr] placeholder:[UIImage imageNamed:@"shanreniIcon"]];
        [self addSubview:self.logImageView];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 15)];
        self.titleLabel.text = @"“IDA”您的身份安全守护者";
        self.titleLabel.textColor = [UIColor whiteColor];
//        self.titleLabel.adjustsFontSizeToFitWidth=YES;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        self.detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 12)];
        self.detailsLabel.textColor = [UIColor whiteColor];
        self.detailsLabel.font = [UIFont systemFontOfSize:12];
        if (IS_IPAD) {
            self.detailsLabel.font = [UIFont systemFontOfSize:20];
        }
        self.detailsLabel.textAlignment = NSTextAlignmentCenter;
//        self.detailsLabel.adjustsFontSizeToFitWidth=YES;
        [self addSubview:self.detailsLabel];
        self.number = 0;
    }
    return self;
}

- (void)setAuthNumber:(NSInteger)number{
    NSLog(@"今日验证次数:  %ld",number);
    self.detailsLabel.text = [NSString stringWithFormat:@"今日认证次数:  %ld",number];
    self.number = number;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundImageView.frame = self.bounds;
    CGFloat imageW,imageH;
    imageW  = 90;
    imageH  = 90;
    self.logImageView.frame = CGRectMake((self.bounds.size.width-imageW)/2, (self.bounds.size.height-imageH)/2,imageW ,imageH);
    
    self.titleLabel.centerX = self.bounds.size.width/2;
    self.titleLabel.centerY = self.logImageView.centerY + imageH/2 + 20 ;
    if (kDevice_Is_iPhoneX) {
        self.titleLabel.centerY = self.logImageView.centerY + imageH/2 +20;
    }
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    if (IS_IPAD) {
        self.titleLabel.font = [UIFont systemFontOfSize:24];
    }
    self.detailsLabel.text = [NSString stringWithFormat:@"今日认证次数:  %d",self.number];
    self.detailsLabel.centerX = self.bounds.size.width/2;
    self.detailsLabel.centerY = self.titleLabel.centerY + 20;
    
    if (IS_IPAD) {
        
        self.logImageView.width = 140.0/568.0*self.bounds.size.height;
        self.logImageView.height = self.logImageView.width;
        self.logImageView.centerX = self.bounds.size.width/2;
        self.logImageView.centerY = 275.0/568.0*self.bounds.size.height;
        self.titleLabel.y = 414.5/568.0*self.bounds.size.height;
        self.detailsLabel.y = 467.5/568.0*self.bounds.size.height;
    }
}

@end
