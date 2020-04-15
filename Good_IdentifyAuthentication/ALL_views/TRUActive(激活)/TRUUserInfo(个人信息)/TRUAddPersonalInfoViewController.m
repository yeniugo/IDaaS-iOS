//
//  TRUAddPersonalInfoViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/11/22.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUAddPersonalInfoViewController.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import "TRUTimerButton.h"
#import "NSString+Regular.h"
#import "TRUFingerGesUtil.h"
#import "TRUhttpManager.h"
@interface TRUAddPersonalInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (nonatomic, weak) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *phoneEView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *eyebtn;


@end

@implementation TRUAddPersonalInfoViewController
{
    BOOL isPhone;
    BOOL isEmail;
    BOOL isOther;
    NSString *codeType;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hiddenWithfalsh:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
    isPhone = isEmail = isOther = NO;
    codeType = @"";
    [_phoneTF addTarget:self action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
}
-(void)valueChanged:(UITextField *)field{
    NSString *str = field.text;
    if ([str isPhone]) {
        isPhone = YES;
        isEmail = NO;
        isOther = NO;
        [self hiddenWithfalsh:1];
    }else if ([str isEmail]){
        isPhone = NO;
        isEmail = YES;
        isOther = NO;
        [self hiddenWithfalsh:1];
    }else{
        isPhone = NO;
        isOther = YES;
        isEmail = NO;
        [self hiddenWithfalsh:2];
    }
}
//判断控制相应view的显示
-(void)hiddenWithfalsh:(NSInteger)teger{
    if (teger == 0) {//刚出现是，默认
        self.passwordView.hidden = YES;
        self.phoneEView.hidden = YES;
        self.codeBtn.hidden = YES;
    }else if (teger == 1){//输入的是手机号或者邮箱
        _passwordView.hidden = YES;
        self.codeBtn.hidden = NO;
        _phoneEView.hidden = NO;
    }else if (teger == 2){//输入的是员工号
        _passwordView.hidden = NO;
        self.codeBtn.hidden = YES;
        _phoneEView.hidden = YES;
    }
}

#pragma mark - 验证码
- (IBAction)codeBtnClick:(UIButton *)sender {
    if (self.phoneTF.text.length == 0) {
        [self showHudWithText:@"请输入正确的账号"];
        [self hideHudDelay:2.0];
        return;
    }
    if (isEmail) {
        codeType = @"email";
        [self requestEmailAuthCode];
    }
    if (isPhone) {
        codeType = @"phone";
        [self requestPhoneAuthCode];
    }
}
- (void)requestEmailAuthCode{
    NSString *userNo = [TRUUserAPI getUser].userId;
    __weak typeof(self) weakself = self;
    NSString *sign = [NSString stringWithFormat:@"%@%@",self.phoneTF.text,@"1"];
    NSArray *ctxx = @[@"mail",self.phoneTF.text,@"authtype",@"1"];
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *para = [xindunsdk encryptByUkey:userNo ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *paraDic = @{@"params":para};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/getmailcode"] withParts:paraDic onResult:^(int error, id responseBody) {
    //[xindunsdk requestCIMSEmailCode:userNo email:self.phoneTF.text authType:@"1" onResult:^(int error) {
        if (0 == error) {
            [weakself showHudWithText:@"邮件验证码已发送，请输入验证码"];
            [weakself hideHudDelay:2.0];
            [self startTimer];
            self.codeBtn.enabled = NO;
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
- (void)requestPhoneAuthCode{
    
    NSString *userNo = [TRUUserAPI getUser].userId;
    __weak typeof(self) weakself = self;
    [xindunsdk requestCIMSAuthCodeForUser:userNo phone:self.phoneTF.text type:@"2" onResult:^(int error, id response) {
        if (0 == error) {
            [weakself showHudWithText:@"手机验证码已发送，请输入验证码"];
            [weakself hideHudDelay:2.0];
            [self startTimer];
            self.codeBtn.enabled = NO;
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

#pragma mark - 完成
- (IBAction)doneBtnClick:(UIButton *)sender {
    if (_phoneTF.text.length == 0) {
        [self showHudWithText:@"请输入您的账号"];
        [self hideHudDelay:1.5f];
        return;
    }
    
    if (_passwordView.hidden == NO && isOther == YES && _passwordTF.text.length == 0) {
        [self showHudWithText:@"请输入业务系统密码"];
        [self hideHudDelay:1.5f];
        return;
    }
    
    __weak typeof(self) weakself = self;
    NSString *authcode;
    if (_codeBtn.hidden == YES) {
        authcode = _passwordTF.text;
    }else{
        authcode = _codeTF.text;
    }
    if (authcode.length == 0 && _codeBtn.hidden == NO) {
        [self showHudWithText:@"请输入验证码"];
        [self hideHudDelay:2.0];
        return;
    }
    [self.view endEditing:YES];
       
    if (codeType.length == 0 && _passwordView.hidden == NO) {
        codeType = @"employeenum";
        
    }
    
    
    NSString *userNo = [TRUUserAPI getUser].userId;
    [self showHudWithText:@"请稍后..."];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@",self.phoneTF.text,codeType,authcode];
    NSArray *ctxx = @[@"userno",self.phoneTF.text,@"type",codeType,@"authcode",authcode];
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *para = [xindunsdk encryptByUkey:userNo ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *paraDic = @{@"params":para};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/userinfosync2"] withParts:paraDic onResult:^(int error, id responseBody) {
    //[xindunsdk requestCIMSUserInfoSync2ForUser:userNo info:self.phoneTF.text type:codeType authcode:authcode onResult:^(int error) {
        [weakself hideHudDelay:0];
        if (error == 0) {
            [self stopTimer];
            TRUUserModel *user = [TRUUserAPI getUser];
            if ([codeType isEqualToString:@"phone"]) {
                user.phone = weakself.phoneTF.text;
            }else if ([codeType isEqualToString:@"email"]){
                user.email = weakself.phoneTF.text;
            }else if ([codeType isEqualToString:@"employeenum"]){
                user.employeenum = weakself.phoneTF.text;
            }
            [TRUUserAPI saveUser:user];
            //先用应用window
            
            UIWindow *window =  [UIApplication sharedApplication].windows[0];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            id delegate = [UIApplication sharedApplication].delegate;
            if(self.isFirstRegist){
                if ([delegate respondsToSelector:@selector(changeRootVC)]) {
                    [delegate performSelector:@selector(changeRootVC)];
                }
            }else{
                if (window.rootViewController == weakself.navigationController) {
                    if ([delegate respondsToSelector:@selector(changeRootVC)]) {
                        [delegate performSelector:@selector(changeRootVC)];
                    }
                    
                }else{
                    
                    [weakself.navigationController dismissViewControllerAnimated:NO completion:^{
                        if ([delegate respondsToSelector:@selector(changeRootVC)]) {
                            [delegate performSelector:@selector(changeRootVC)];
                        }
                    }];
                }
            }
            
#pragma clang diagnostic pop
        }else if(error == -5004){
            [weakself showHudWithText:@"网络错误，请稍后重试"];
            [weakself hideHudDelay:2.0];
        }else if (9019 == error){
            [weakself deal9019Error];
        }else{
            NSString *err = [NSString stringWithFormat:@"同步信息失败（%d）",error];
            [weakself showHudWithText:err];
            [weakself hideHudDelay:2.0];
        }
        
    }];
    
}

- (IBAction)eyeBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _passwordTF.secureTextEntry = sender.selected;
}

-(void)customUI{
    self.title = @"完善用户信息";
    // 完善信息默认 在三种之外的另外两种随便选
    [self.numLabel setTextColor:DefaultColor];
    if (self.phone.length > 0) {
        NSString *textStr = @"您的手机号为:";
        self.textLabel.text = textStr;
        self.numLabel.text = self.phone;
        self.phoneTF.placeholder = [NSString stringWithFormat:@"请输入您的邮箱/员工号"];
    }
    if (self.email.length > 0) {
        NSString *textStr = @"您的邮箱为:";
        self.textLabel.text = textStr;
        self.numLabel.text = self.email;
        self.phoneTF.placeholder = [NSString stringWithFormat:@"请输入您的手机号/员工号"];
    }
    if (self.employeenum.length > 0) {
        NSString *textStr = @"您的工号为:";
        self.textLabel.text = textStr;
        self.numLabel.text = self.employeenum;
        self.phoneTF.placeholder = [NSString stringWithFormat:@"请输入您的手机号/邮箱"];
    }
    
    _passwordTF.secureTextEntry = YES;
    
    [self setUpNav];
    
    _codeBtn.layer.masksToBounds = YES;
    _codeBtn.layer.cornerRadius = 5.0;
    
}

- (void)setUpNav{
    UIImage *img = [[UIImage imageNamed:@"backbtn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:img forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(showDialog) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = left;
}
- (void)showDialog{
    __weak typeof(self) weakself = self;
    
    [self showConfrimCancelDialogViewWithTitle:@"" msg:@"如果您现在返回，需重新进行设备绑定流程" confrimTitle:@"确定" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
        if (weakself.isStart) {
            if ([TRUUserAPI getUser].userId) {
                [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
                [TRUUserAPI deleteUser];
                [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
            }
            //跳转激活页面
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            id delegate = [UIApplication sharedApplication].delegate;
            if ([delegate respondsToSelector:@selector(changeAvtiveRootVC)]) {
                [delegate performSelector:@selector(changeAvtiveRootVC) withObject:nil];
            }
#pragma clang diagnostic pop
        }else{
            if (weakself.isScan) {
                if ([TRUUserAPI getUser].userId) {
                    [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
                    [TRUUserAPI deleteUser];
                    [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
                }
                if (weakself.backBlocked) {
                    weakself.backBlocked();
                }
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            }else{
                if ([TRUUserAPI getUser].userId) {
                    [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
                    [TRUUserAPI deleteUser];
                    [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
                }
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    } cancelBlock:^{}];
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
    
    if (totalTime >= 1) {
        totalTime -- ;
        NSString *leftTitle  = [NSString stringWithFormat:@"已发送(%ds)",totalTime];
        [self.codeBtn setTitle:leftTitle forState:UIControlStateNormal];
    }else{
        totalTime = 60;
        [self.codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        self.codeBtn.enabled = YES;
        [self stopTimer];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopTimer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
} 
@end
