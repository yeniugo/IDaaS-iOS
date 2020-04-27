//
//  TRUWebLoginTopView.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2020/4/22.
//  Copyright © 2020 zyc. All rights reserved.
//

#import "TRUWebLoginTopView.h"
#import "UIView+FrameExt.h"
@interface TRUWebLoginTopView()
@property (nonatomic,strong) UILabel *ipLeftLB;
@property (nonatomic,strong) UILabel *ipRightLB;
@property (nonatomic,strong) UILabel *loginTimeLeftLB;
@property (nonatomic,strong) UILabel *loginTimeRightLB;
@property (nonatomic,strong) UILabel *authTypeLeftLB;
@property (nonatomic,strong) UILabel *authTypeRightLB;
@property (nonatomic,strong) UILabel *authTimeLeftLB;
@property (nonatomic,strong) UILabel *authTimeRightLB;
@end

@implementation TRUWebLoginTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    self.ipLeftLB = [[UILabel alloc] init];
    self.ipLeftLB.font = [UIFont systemFontOfSize:14.0];
    self.ipLeftLB.textColor = RGBCOLOR(51, 51, 51);
    self.ipLeftLB.text = @"登录IP";
    [self addSubview:self.ipLeftLB];
    self.ipRightLB = [[UILabel alloc] init];
    self.ipRightLB.font = [UIFont systemFontOfSize:14.0];
    self.ipRightLB.textColor = RGBCOLOR(119, 119, 119);
    self.ipRightLB.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.ipRightLB];
    self.loginTimeLeftLB = [[UILabel alloc] init];
    self.loginTimeLeftLB.font = [UIFont systemFontOfSize:14.0];
    self.loginTimeLeftLB.textColor = RGBCOLOR(51, 51, 51);
    self.loginTimeLeftLB.text = @"登录时间";
    [self addSubview:self.loginTimeLeftLB];
    self.loginTimeRightLB = [[UILabel alloc] init];
    self.loginTimeRightLB.font = [UIFont systemFontOfSize:14.0];
    self.loginTimeRightLB.textColor = RGBCOLOR(119, 119, 119);
    self.loginTimeRightLB.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.loginTimeRightLB];
    self.authTypeLeftLB = [[UILabel alloc] init];
    self.authTypeLeftLB.font = [UIFont systemFontOfSize:14.0];
    self.authTypeLeftLB.textColor = RGBCOLOR(51, 51, 51);
    self.authTypeLeftLB.text = @"认证方式";
    [self addSubview:self.authTypeLeftLB];
    self.authTypeRightLB = [[UILabel alloc] init];
    self.authTypeRightLB.font = [UIFont systemFontOfSize:14.0];
    self.authTypeRightLB.textColor = RGBCOLOR(119, 119, 119);
    self.authTypeRightLB.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.authTypeRightLB];
    self.authTimeLeftLB = [[UILabel alloc] init];
    self.authTimeLeftLB.font = [UIFont systemFontOfSize:14.0];
    self.authTimeLeftLB.textColor = RGBCOLOR(51, 51, 51);
    self.authTimeLeftLB.text = @"会话时长";
    [self addSubview:self.authTimeLeftLB];
    self.authTimeRightLB = [[UILabel alloc] init];
    self.authTimeRightLB.font = [UIFont systemFontOfSize:14.0];
    self.authTimeRightLB.textColor = RGBCOLOR(119, 119, 119);
    self.authTimeRightLB.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.authTimeRightLB];
    return self;
}

- (void)setViewDic:(NSDictionary *)viewDic{
    _viewDic = viewDic;
    self.ipRightLB.text = viewDic[@"ipAddr"];
    self.loginTimeRightLB.text = viewDic[@"loginTime"];
    self.authTypeRightLB.text = viewDic[@"authWay"];
    self.authTimeRightLB.text = viewDic[@"sessionTime"];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.ipLeftLB.centerY = self.frame.size.height*0.2;
    self.ipLeftLB.x = 20;
    self.ipLeftLB.width = 65;
    self.ipLeftLB.height = 15;
    self.ipRightLB.centerY = self.frame.size.height*0.2;
    self.ipRightLB.x = 80+10;
    self.ipRightLB.width = SCREENW - 80 - 30 -10;
    self.ipRightLB.height = 15;
    self.loginTimeLeftLB.centerY = self.frame.size.height*0.4;
    self.loginTimeLeftLB.x = 20;
    self.loginTimeLeftLB.width = 65;
    self.loginTimeLeftLB.height = 15;
    self.loginTimeRightLB.centerY = self.frame.size.height*0.4;
    self.loginTimeRightLB.x = 80+10;
    self.loginTimeRightLB.width = SCREENW - 80 - 30-10;
    self.loginTimeRightLB.height = 15;
    self.authTypeLeftLB.centerY = self.frame.size.height*0.6;
    self.authTypeLeftLB.x = 20;
    self.authTypeLeftLB.width = 65;
    self.authTypeLeftLB.height = 15;
    self.authTypeRightLB.centerY = self.frame.size.height*0.6;
    self.authTypeRightLB.x = 80+10;
    self.authTypeRightLB.width = SCREENW - 80 - 30-10;
    self.authTypeRightLB.height = 15;
    self.authTimeLeftLB.centerY = self.frame.size.height*0.8;
    self.authTimeLeftLB.x = 20;
    self.authTimeLeftLB.width = 65;
    self.authTimeLeftLB.height = 15;
    self.authTimeRightLB.centerY = self.frame.size.height*0.8;
    self.authTimeRightLB.x = 80+10;
    self.authTimeRightLB.width = SCREENW - 80 - 30-10;
    self.authTimeRightLB.height = 15;
}

@end
