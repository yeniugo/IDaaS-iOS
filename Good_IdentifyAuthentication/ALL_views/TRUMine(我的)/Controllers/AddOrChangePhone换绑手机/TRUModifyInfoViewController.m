//
//  TRUModifyInfoViewController.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2016/12/26.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import "TRUModifyInfoViewController.h"
#import "TRUBaseNavigationController.h"
#import "TRUUserAPI.h"
#import "xindunsdk.h"


@interface TRUModifyInfoViewController ()<UITextFieldDelegate>
@property (nonatomic, weak) UITextField *authField;//验证码
@property (nonatomic, weak) UITextField *phoneField;//手机号
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) UIButton *getAuthButton;//获取验证码按钮
@property (nonatomic, weak) UILabel *titlePhoneLable;
@property (nonatomic, weak) UILabel *titleAuthcodeLable;
@property (nonatomic, weak) UIButton *authOldBindNewBtn;
@property (nonatomic, assign) BOOL isAuthNewPhone;
@end

@implementation TRUModifyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNav];
    [self commonInit];
    self.isAuthNewPhone = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated{
    
}

- (void)setUpNav{
    if ([self.navigationController isKindOfClass:[TRUBaseNavigationController class]]) {
        __weak typeof(self) weakSelf = self;
        TRUBaseNavigationController *nav = (TRUBaseNavigationController *)self.navigationController;
        __weak typeof(nav) weakNav = nav;
        nav.backBlock = ^(){
            if (weakSelf.timer) [weakSelf stopTimer];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            weakNav.backBlock = nil;
        };
    }
    
}
- (void)commonInit{

    self.title = @"换绑手机";
    
    UIView *viewone = [[UIView alloc] initWithFrame:CGRectMake(0, 84, SCREENW, 70)];
    [self.view addSubview:viewone];
    viewone.backgroundColor = [UIColor whiteColor];
    
    
    
    UILabel *phoneL = [[UILabel alloc] init];
    phoneL.text = @"原手机";
    phoneL.font = [UIFont systemFontOfSize:15];
    [phoneL sizeToFit];
    [viewone addSubview:self.titlePhoneLable = phoneL];
    
    //原手机号/新手机号
    UITextField *phoneF = [[UITextField alloc] init];
    phoneF.text = [self convertPhone];
    phoneF.font = [UIFont systemFontOfSize:15];
    phoneF.enabled = NO;
    [viewone addSubview:self.phoneField = phoneF];
    
    
    UIView *viewtwo = [[UIView alloc] initWithFrame:CGRectMake(0, 156, SCREENW, 70)];
    [self.view addSubview:viewtwo];
    viewtwo.backgroundColor = [UIColor whiteColor];
    
    UILabel *authL = [[UILabel alloc] init];
    authL.text = @"验证码 ";
    authL.font = [UIFont systemFontOfSize:15];
    [authL sizeToFit];
    [viewtwo addSubview:self.titleAuthcodeLable = authL];
    
    
    //验证码
    UITextField *authcodeField = [[UITextField alloc] init];
    authcodeField.placeholder = @"请输入验证码";
    authcodeField.font = [UIFont systemFontOfSize:15];
    [authcodeField addTarget:self action:@selector(authcodeFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [viewtwo addSubview:self.authField = authcodeField];
    authcodeField.delegate = self;
    
    
    //获取验证码按钮
    UIButton *authBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [authBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    authBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [authBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [authBtn setBackgroundColor:DefaultColor];
    [authBtn addTarget:self action:@selector(btnGetAuthCode:) forControlEvents:UIControlEventTouchUpInside];
    authBtn.layer.masksToBounds = YES;
    authBtn.layer.cornerRadius = 3.f;
    [viewone addSubview:self.getAuthButton = authBtn];
    
    
    
    //验证后绑定新手机按钮
    UIButton *bindNewPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bindNewPhoneBtn setTitle:@"验证后绑定新手机号" forState:UIControlStateNormal];
    [bindNewPhoneBtn setBackgroundColor:RGBCOLOR(191, 191, 191)];
    [bindNewPhoneBtn addTarget:self action:@selector(bindNewPhoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    bindNewPhoneBtn.enabled = NO;
    [self.view addSubview:self.authOldBindNewBtn = bindNewPhoneBtn];
    bindNewPhoneBtn.layer.masksToBounds = YES;
    bindNewPhoneBtn.layer.cornerRadius = 3.f;
    bindNewPhoneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    NSString *attrText = @"如当前号码不用或丢失，请 联系管理员";
    NSMutableAttributedString *sts = [[NSMutableAttributedString alloc] initWithString:attrText attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor], NSFontAttributeName: [UIFont systemFontOfSize:14.0 * PointHeightRatio6]}];
    
    NSRange range = [attrText rangeOfString:@"联系管理员"];
    [sts addAttribute:NSForegroundColorAttributeName value:DefaultColor range:range];
    
    
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.attributedText = sts;
    [self.view addSubview:tipLabel];
    
    
    if (kDevice_Is_iPhoneX) {
        viewone.frame = CGRectMake(0, 84+20, SCREENW, 70);
        viewtwo.frame = CGRectMake(0, 156+20, SCREENW, 70);
    }else{
        viewone.frame = CGRectMake(0, 84, SCREENW, 70);
        viewtwo.frame = CGRectMake(0, 156, SCREENW, 70);
    }
    
    
    [phoneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@20);
        make.width.equalTo(@(phoneL.width));
        make.height.equalTo(@30);
    }];
    
    [phoneF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneL.mas_right).offset(20.f);
        make.right.equalTo(authBtn.mas_left);
        make.height.equalTo(@30);
        make.top.equalTo(phoneL);
    }];
    [authBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewone).offset(-20.f);
        make.height.equalTo(@30);
        make.width.equalTo(@105);
        make.centerY.equalTo(phoneF);
    }];
    
    
    [authL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@20);
        make.width.equalTo(@(authL.width));
        make.height.equalTo(@30);
    }];
    [authcodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(authL.mas_right).offset(20.f);
        make.height.equalTo(authL);
        make.right.equalTo(viewtwo).offset(-20.f);
        make.top.equalTo(authL);
    }];
    
    [bindNewPhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(viewtwo.mas_bottom).offset(30);
        make.height.equalTo(@44);
        make.width.equalTo(@160);
    }];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-20);
    }];
    
}

- (void)btnGetAuthCode:(UIButton *)btn{
     __weak typeof(self) weakself = self;
    [self.view endEditing:YES];
    NSString *userid = [TRUUserAPI getUser].userId;
    if (!self.isAuthNewPhone) {
        [self startTimer];
        btn.enabled = NO;
        [xindunsdk getCIMSAuthcode4Update:userid authType:@"2" onResult:^(int error, id response) {
            if (error == 0) {
                [weakself.authField becomeFirstResponder];
            }else if (-5004 == error){
                [weakself showHudWithText:@"网络错误，请稍后重试"];
                [weakself hideHudDelay:2.0];
                
            }else if (9019 == error){
                [weakself deal9019Error];
            }else{
                NSString *err = [NSString stringWithFormat:@"获取验证码失败（%d）",error];
                [weakself showHudWithText:err];
                [weakself hideHudDelay:2.0];
            }
            
        }];
        
        return;
    }else{
        NSString *phone = self.phoneField.text;
        
        if (phone.length == 0) {
            [self showHudWithText:@"请输入新手机的手机号"];
            [self hideHudDelay:2.0];
            return;
        }
        if (phone.length <11) {
            [self showHudWithText:@"请输入正确的手机号"];
            [self hideHudDelay:2.0];
            return;
        }
        
        [self startTimer];
        btn.enabled = NO;
        [xindunsdk requestCIMSAuthCodeForUser:userid phone:phone type:@"1" onResult:^(int error, id response) {
            if (error == 0) {
                [weakself.authField becomeFirstResponder];
            }else if (-5004 == error){
                [weakself showHudWithText:@"网络错误，请稍后重试"];
                [weakself hideHudDelay:2.0];
                
            }else if (9019 == error){
                [weakself deal9019Error];
            }else{
                NSString *err = [NSString stringWithFormat:@"获取验证码失败（%d）",error];
                [weakself showHudWithText:err];
                [weakself hideHudDelay:2.0];
            }
        }];
    }
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >2) {
        [self.authOldBindNewBtn setBackgroundColor:DefaultColor];
        self.authOldBindNewBtn.enabled = YES;
    }else{
        [self.authOldBindNewBtn setBackgroundColor:RGBCOLOR(191, 191, 191)];
        self.authOldBindNewBtn.enabled = NO;
    }
    return YES;
}

- (void)contentTextChange:(UITextField *)field{
    BOOL enable = ![field.text isEqualToString:self.contentText] && field.text.length != 0;
    
    [self.navigationItem.rightBarButtonItem setEnabled:enable];
}

- (void)bindNewPhoneBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
     __weak typeof(self) weakself = self;
    NSString *userid =[TRUUserAPI getUser].userId;
    NSString *authcode = self.authField.text;
    if (!self.isAuthNewPhone) {
        if (authcode.length == 0) {
            [self showHudWithText:@"验证码不能空"];
            [self hideHudDelay:2.0];
            return;
        }
        [self showActivityWithText:@""];
        btn.enabled = NO;
        [xindunsdk checkCIMSAuchcode4Update:userid authcode:authcode onResult:^(int error, id response) {
            btn.enabled = YES;
            [weakself hideHudDelay:0];
            if (error == 0) {
                weakself.titlePhoneLable.text = @"新手机";
                weakself.phoneField.enabled = YES;
                weakself.phoneField.text = @"";
                weakself.phoneField.placeholder = @"请输入新手机号";
                weakself.authField.text = @"";
                [weakself.phoneField becomeFirstResponder];
                [weakself.authOldBindNewBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
                weakself.isAuthNewPhone = YES;
                
                weakself.getAuthButton.enabled = YES;
                [weakself stopTimer];
            }else if (-5004 == error){
                [weakself showHudWithText:@"网络错误，请稍后重试"];
                [weakself hideHudDelay:2.0];
                
            }else if (9019 == error){
                [weakself deal9019Error];
            }else{
                NSString *err = [NSString stringWithFormat:@"校验验证码失败（%d）",error];
                [weakself showHudWithText:err];
                [weakself hideHudDelay:2.0];
            }
            
        }];
        return;
    }else{
        NSString *phone = self.phoneField.text;
        if (phone.length == 0) {
            [self showHudWithText:@"手机号不能空"];
            [self hideHudDelay:2.0];
            return;
        }
        if (authcode.length == 0) {
            [self showHudWithText:@"验证码不能空"];
            [self hideHudDelay:2.0];
            return;
        }
        [self showActivityWithText:@""];
        btn.enabled = NO;
        [xindunsdk requestCIMSUserInfoSync2ForUser:userid info:phone type:@"phone" authcode:authcode onResult:^(int error) {
            btn.enabled = YES;
            [weakself hideHudDelay:0];
            if (error == 0) {
                TRUUserModel *model = [TRUUserAPI getUser];
                model.phone = phone;
                [TRUUserAPI saveUser:model];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changephonesuccess" object:nil];
                [weakself.navigationController popViewControllerAnimated:YES];
            }else if (-5004 == error){
                [weakself showHudWithText:@"网络错误，请稍后重试"];
                [weakself hideHudDelay:2.0];
                
            }else if (9004 == error){
                [weakself showHudWithText:@"该手机号已经绑定其他账户，请换绑其他手机号"];
                [weakself hideHudDelay:2.0];
                
            }else if (9019 == error){
                [weakself deal9019Error];
            }else{
                NSString *err = [NSString stringWithFormat:@"绑定新手机失败（%d）",error];
                [weakself showHudWithText:err];
                [weakself hideHudDelay:2.0];
            }
            
        }];
    }
    
    
}

- (void)startTimer{
    
    __weak typeof(self) weakSelf = self;
    [weakSelf stopTimer];
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:weakSelf selector:@selector(startButtonCount) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.timer = timer;
    [timer fire];
 
}
- (void)stopTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        totalTime = 60;
    }
    
}
static int totalTime = 60;
- (void)startButtonCount{
    
    if (totalTime > 1) {
        totalTime -- ;
        NSString *leftTitle  = [NSString stringWithFormat:@"已发送(%ds)",totalTime];
        [self.getAuthButton setTitle:leftTitle forState:UIControlStateDisabled];
    }else{
        totalTime = 60;
        [self stopTimer];
        self.getAuthButton.enabled = YES;
    }
   
    
}
- (NSString *)convertPhone{
    NSString *phone = [TRUUserAPI getUser].phone;
    return phone;
}
- (void)authcodeFieldValueChanged:(UITextField *)field{
    self.authOldBindNewBtn.enabled = field.text.length > 0;
}
@end
