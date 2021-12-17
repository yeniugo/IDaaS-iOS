//
//  TRURegisterViewController.m
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/12/14.
//  Copyright © 2021 zyc. All rights reserved.
//

#import "TRURegisterViewController.h"
//#import "Masonry/Masonry.h"
@interface TRURegisterViewController ()
@property (nonatomic,weak) UIView *emailBGView;
@property (nonatomic,weak) UIView *phoneBGView;
@property (nonatomic,weak) UIButton *emailBtn;
@property (nonatomic,weak) UIButton *phoneBtn;
@property (nonatomic,weak) NSTimer *timer;
@property (nonatomic,weak) UIButton *verifyBtn;
@end

@implementation TRURegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"aaa=%d",__IPHONE_OS_VERSION_MIN_REQUIRED);
    // Do any additional setup after loading the view.
    self.title = @"注册";
    
    UILabel *showIDLB = [[UILabel alloc] init];
    [self.view addSubview:showIDLB];
    showIDLB.text = @"请填写个人信息";
    
    UITextField *nameTF = [[UITextField alloc] init];
    nameTF.placeholder = @"请输入姓名";
    UIView *nameLine = [[UIView alloc] init];
    nameLine.backgroundColor = RGBCOLOR(224, 224, 224);
    [self.view addSubview:nameTF];
    [self.view addSubview:nameLine];
    
    UITextField *idcardTF = [[UITextField alloc] init];
    idcardTF.placeholder = @"请输入证件号码";
    UIView *idcardLine = [[UIView alloc] init];
    idcardLine.backgroundColor = RGBCOLOR(224, 224, 224);
    [self.view addSubview:idcardTF];
    [self.view addSubview:idcardLine];
    
    UILabel *showBindLB = [[UILabel alloc] init];
    [self.view addSubview:showBindLB];
    showBindLB.text = @"请选择验证方式";
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [phoneBtn setImage:[UIImage imageNamed:@"registerSelect"] forState:UIControlStateNormal];
    [phoneBtn setImage:[UIImage imageNamed:@"registerSelect"] forState:UIControlStateSelected];
    [phoneBtn setTitle:@"手机号" forState:UIControlStateNormal];
    [phoneBtn setTitle:@"手机号" forState:UIControlStateSelected];
    [phoneBtn setTitleColor:RGBCOLOR(159, 159, 159) forState:UIControlStateNormal];
    [phoneBtn setTitleColor:RGBCOLOR(58, 58, 58) forState:UIControlStateSelected];
    [phoneBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
//    [phoneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    UIButton *emailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [emailBtn addTarget:self action:@selector(emailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [emailBtn setImage:[UIImage imageNamed:@"registerSelect"] forState:UIControlStateNormal];
    [emailBtn setImage:[UIImage imageNamed:@"registerSelect"] forState:UIControlStateSelected];
    [emailBtn setTitle:@"邮箱" forState:UIControlStateNormal];
    [emailBtn setTitle:@"邮箱" forState:UIControlStateSelected];
    [emailBtn setTitleColor:RGBCOLOR(159, 159, 159) forState:UIControlStateNormal];
    [emailBtn setTitleColor:RGBCOLOR(58, 58, 58) forState:UIControlStateSelected];
    [emailBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
//    [emailBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    self.phoneBtn = phoneBtn;
    self.emailBtn = emailBtn;
    
    [self.view addSubview:phoneBtn];
    [self.view addSubview:emailBtn];
    
    UIView *phoneBGView = [[UIView alloc] init];
    self.phoneBGView = phoneBGView;
    [self.view addSubview:phoneBGView];
    
    UILabel *countryLB = [[UILabel alloc] init];
    countryLB.numberOfLines = 0;
    countryLB.text = @"+86";
    countryLB.textColor = RGBCOLOR(58, 58, 58);
    UIImageView *phoneIcon = [[UIImageView alloc] init];
    UITextField *phoneTF = [[UITextField alloc] init];
    phoneTF.placeholder = @"请输入手机号                                                          ";
    phoneTF.backgroundColor = [UIColor blueColor];
    UIView *phoneLine = [[UIView alloc] init];
    phoneLine.backgroundColor = RGBCOLOR(224, 224, 224);
    
//    UIImageView *verifytIcon = [[UIImageView alloc] init];
    UITextField *verifyTF = [[UITextField alloc] init];
    verifyTF.placeholder = @"请输入验证码";
    verifyTF.backgroundColor = [UIColor orangeColor];
    UIButton *verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verifyBtn addTarget:self action:@selector(verifyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [verifyBtn.layer setMasksToBounds:YES];
    [verifyBtn.layer setCornerRadius:5.0];
    verifyBtn.backgroundColor = DefaultGreenColor;
    self.verifyBtn = verifyBtn;
//    [verifyBtn setImage:nil forState:UIControlStateNormal];
//    [verifyBtn setImage:nil forState:UIControlStateSelected];
    UIView *verifyLine = [[UIView alloc] init];
    verifyLine.backgroundColor = RGBCOLOR(224, 224, 224);
    
    [phoneBGView addSubview:countryLB];
    [phoneBGView addSubview:phoneIcon];
    [phoneBGView addSubview:phoneTF];
    [phoneBGView addSubview:phoneLine];
//    [phoneBGView addSubview:verifytIcon];
    [self.view addSubview:verifyTF];
    [self.view addSubview:verifyBtn];
    [self.view addSubview:verifyLine];
    
    UIView *emailBGView = [[UIView alloc] init];
    self.emailBGView = emailBGView;
    [self.view addSubview:emailBGView];
    
    UITextField *emailTF = [[UITextField alloc] init];
    emailTF.placeholder = @"请输入邮箱前缀";
    UILabel *emailHost= [[UILabel alloc] init];
    emailHost.text = @"@chinacoal.com";
    UIView *emailLine = [[UIView alloc] init];
    
//    UITextField *emailVerifyTF = [[UITextField alloc] init];
//    emailVerifyTF.placeholder = @"请输入验证码";
//    UIButton *emailVerifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIView *emailVerifyLine = [[UIView alloc] init];
    
    [emailBGView addSubview:emailTF];
    [emailBGView addSubview:emailHost];
    [emailBGView addSubview:emailLine];
//    [emailBGView addSubview:emailVerifyTF];
//    [emailBGView addSubview:emailVerifyBtn];
//    [emailBGView addSubview:emailVerifyLine];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.backgroundColor = DefaultGreenColor;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitle:@"下一步" forState:UIControlStateHighlighted];
    [self.view addSubview:nextBtn];
    
    [showIDLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.top.equalTo(self.view.mas_topMargin).offset(20);
    }];
    [nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.top.equalTo(showIDLB.mas_bottom).offset(25);
        make.right.equalTo(self.view).offset(-40);
    }];
    [nameLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(nameTF.mas_bottom).offset(15);
        make.height.equalTo(@(1));
    }];
    [idcardTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(nameTF.mas_bottom).offset(40);
    }];
    [idcardLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(idcardTF.mas_bottom).offset(15);
        make.height.equalTo(@(1));
    }];
    [showBindLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.top.equalTo(idcardLine.mas_bottom).offset(35);
    }];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.top.equalTo(showBindLB.mas_bottom).offset(20);
    }];
    [emailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneBtn.mas_right).offset(60);
        make.centerY.equalTo(phoneBtn);
    }];
    [phoneBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(phoneBtn.mas_bottom);
//        make.height.equalTo(@(100));
    }];
    [emailBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(phoneBGView);
    }];
    [countryLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneBGView).offset(50);
//        make.leading.equalTo(@50);
        make.top.equalTo(phoneBGView).offset(30);
//        make.top.mas_equalTo(30);
    }];
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(countryLB.mas_trailing).mas_offset(10);
        make.trailing.equalTo(@-40);
        make.top.equalTo(phoneBGView).offset(30);
    }];
    [phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneBGView).offset(50);
        make.right.equalTo(phoneBGView).offset(-50);
        make.top.equalTo(phoneTF.mas_bottom).offset(15);
        make.height.equalTo(@(1));
        make.bottom.equalTo(phoneBGView.mas_bottom).offset(-5);
    }];
    [emailHost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(emailBGView).offset(-40);
        make.centerY.equalTo(countryLB);
    }];
    [emailLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(phoneLine);
    }];
    [emailTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(emailBGView).offset(50);
        make.right.equalTo(emailHost.mas_left).offset(-10);
        make.centerY.equalTo(countryLB);
    }];
    [verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(100));
        make.height.equalTo(@(40));
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(phoneTF.mas_bottom).offset(30);
    }];
    [verifyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(verifyBtn.mas_left).offset(-10);
        make.centerY.equalTo(verifyBtn);
    }];
    [verifyLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(phoneLine);
        make.top.equalTo(verifyBtn.mas_bottom).offset(10);
    }];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(40));
        make.right.equalTo(@(-40));
        make.top.equalTo(verifyLine.mas_bottom).offset(40);
        make.height.equalTo(@(50));
    }];
}

- (void)verifyBtnClick:(UIButton *)btn{
    // 手机号
    if (self.phoneBtn.selected) {
        
    }else{ // 邮箱
        
    }
}

- (void)phoneBtnClick:(UIButton *)btn{
    self.phoneBGView.hidden = NO;
    self.emailBGView.hidden = YES;
    self.phoneBtn.selected = YES;
    self.emailBtn.selected = NO;
}

- (void)emailBtnClick:(UIButton *)btn{
    self.phoneBGView.hidden = YES;
    self.emailBGView.hidden = NO;
    self.phoneBtn.selected = NO;
    self.emailBtn.selected = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
