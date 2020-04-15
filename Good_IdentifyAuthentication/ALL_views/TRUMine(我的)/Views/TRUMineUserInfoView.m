//
//  TRUMineUserInfoView.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/26.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUMineUserInfoView.h"
#import "TRUUserInfoModel.h"
#import "TRUUserModel.h"
#import "TRUUserAPI.h"

@implementation TRUMineUserInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self customUI];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3.f;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.f;
        [self setModel];
    }
    return self;
}

-(void)setModel{
    TRUUserModel *userModel = [TRUUserAPI getUser];
    self.nameLabel.text = userModel.realname;
    self.departmentLabel.text = userModel.department;
    self.phoneLabel.text = userModel.phone;
    self.userNumLabel.text = userModel.employeenum;
    self.emailLabel.text = userModel.email;
    
    _userImageView.image = [UIImage imageNamed:@"personicon"];
}

-(void)customUI{
    
    CGFloat viewWidth = self.frame.size.width;
    
    CGFloat gap = 15.f;
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, viewWidth, 20)];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.text = @"个人信息";
    titlelabel.textColor = [UIColor darkGrayColor];
    titlelabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:titlelabel];
    //黑线
    UILabel *linelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, viewWidth, 1)];
    linelabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:linelabel];
    
    /******************/
    
    if (SCREENW == 320) {
        _userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth - 15 - 55, 40, 55, 55)];
        _userImageView.layer.masksToBounds = YES;
        _userImageView.layer.cornerRadius = 55/2.f;
    }else{
        _userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth - 15 - 70, 45, 70, 70)];
        _userImageView.layer.masksToBounds = YES;
        _userImageView.layer.cornerRadius = 35.f;
    }
    
    
    [self addSubview:_userImageView];
    
    
    CGFloat KfontSize = 13;
    CGFloat KgapH = 10;
    CGFloat kLabelY = 40;
    //姓名
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(gap, kLabelY, 30, 20)];
    label1.text = @"姓名";
    label1.font = [UIFont systemFontOfSize:KfontSize];
    [self addSubview:label1];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*gap +40, kLabelY, 120, 20)];
    _nameLabel.textColor = [UIColor darkGrayColor];
    _nameLabel.font = [UIFont systemFontOfSize:KfontSize];
    [self addSubview:_nameLabel];
    
    //部门
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(gap, kLabelY + (20 + KgapH), 30, 20)];
    label2.text = @"部门";
    label2.font = [UIFont systemFontOfSize:KfontSize];
    [self addSubview:label2];
    
    _departmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*gap +40, kLabelY + (20 + KgapH), 120, 20)];
    _departmentLabel.textColor = [UIColor darkGrayColor];
    _departmentLabel.font = [UIFont systemFontOfSize:KfontSize];
    [self addSubview:_departmentLabel];
    
    //邮箱
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(gap, kLabelY +(20 + KgapH) *2, 30, 20)];
    label3.text = @"邮箱";
    label3.font = [UIFont systemFontOfSize:KfontSize];
    [self addSubview:label3];
    
    _emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*gap +40, kLabelY + (20 + KgapH) *2, 180, 20)];
    _emailLabel.textColor = [UIColor darkGrayColor];
    _emailLabel.font = [UIFont systemFontOfSize:KfontSize];
    [self addSubview:_emailLabel];
    
    
    //员工号
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(gap, kLabelY + (20 + KgapH) *3, 80, 20)];
    label4.text = @"域账号";
    label4.font = [UIFont systemFontOfSize:KfontSize];
    [self addSubview:label4];
    _userNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*gap +40, kLabelY + (20 + KgapH) *3, 120, 20)];
    _userNumLabel.textColor = [UIColor darkGrayColor];
    _userNumLabel.font = [UIFont systemFontOfSize:KfontSize];
    [self addSubview:_userNumLabel];
    
    
    //手机号
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(gap, kLabelY + (20 + KgapH) *4, 50, 20)];
    label5.text = @"手机号";
    label5.font = [UIFont systemFontOfSize:KfontSize];
    [self addSubview:label5];
    
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*gap +40, kLabelY + (20 + KgapH) *4, 120, 20)];
    _phoneLabel.textColor = [UIColor darkGrayColor];
    _phoneLabel.font = [UIFont systemFontOfSize:KfontSize];
    [self addSubview:_phoneLabel];
    
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setImage:[UIImage imageNamed:@"identify_jiantou"] forState:UIControlStateNormal];
    changeBtn.frame = CGRectMake(SCREENW - 4*gap - 15, kLabelY + (20 + KgapH) *4 -5, 30, 30);
    [self addSubview:changeBtn];
    changeBtn.hidden = YES;
    [changeBtn addTarget:self action:@selector(changePhoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)changePhoneBtnClick{
    if (_changePhoneBlock) {
        _changePhoneBlock();
    }
}

@end
