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
#import "TRUCompanyAPI.h"
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
//    [self hiddenWithfalsh:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
    isPhone = isEmail = isOther = NO;
    NSString *modeStr = [TRUCompanyAPI getCompany].activation_mode;
    if (modeStr.length == 3) {//完善方式(1:邮箱,2:手机,3:工号)
        NSArray *arr = [modeStr componentsSeparatedByString:@","];
        NSString *str = arr[1];
        if ([str isEqualToString:@"1"]) {
            isEmail = YES;
            _passwordView.hidden = YES;
            self.codeBtn.hidden = NO;
            _phoneEView.hidden = NO;
            self.phoneTF.placeholder = [NSString stringWithFormat:@"请输入您的邮箱"];
        }else if ([str isEqualToString:@"2"]){
            isPhone = YES;
            _passwordView.hidden = YES;
            self.codeBtn.hidden = NO;
            _phoneEView.hidden = NO;
            self.phoneTF.placeholder = [NSString stringWithFormat:@"请输入您的手机号"];
        }else if ([str isEqualToString:@"3"]){
            isOther = YES;
            _passwordView.hidden = NO;
            self.codeBtn.hidden = YES;
            _phoneEView.hidden = YES;
            self.phoneTF.placeholder = [NSString stringWithFormat:@"请输入您的工号"];
        }
    }else{
        [_phoneTF addTarget:self action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    }
    codeType = @"";
    
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
    NSString *str = self.phoneTF.text;
    if ([str isEmail] && isEmail == YES) {
        codeType = @"email";
        [self requestEmailAuthCode];
    }
    if ([str isPhone] && isPhone == YES) {
        codeType = @"phone";
        [self requestPhoneAuthCode];
    }
}
- (void)requestEmailAuthCode{
    NSString *userNo = [TRUUserAPI getUser].userId;
    __weak typeof(self) weakSelf = self;
    
    NSString *sign = [NSString stringWithFormat:@"%@%@",self.phoneTF.text,@"1"];
    NSArray *ctxx = @[@"mail",self.phoneTF.text,@"authtype",@"1"];
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *para = [xindunsdk encryptByUkey:userNo ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *paraDic = @{@"params":para};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/getmailcode"] withParts:paraDic onResult:^(int errorno, id responseBody) {
        [weakSelf hideHudDelay:0.0];
        if (0 == errorno) {
            [weakSelf showHudWithText:@"邮件验证码已发送，请输入验证码"];
            [weakSelf hideHudDelay:2.0];
            [weakSelf startTimer];
            weakSelf.codeBtn.enabled = NO;
        }else if (-5004 == errorno){
            [weakSelf showHudWithText:@"网络错误，请稍后重试"];
            [weakSelf hideHudDelay:2.0];
        }else if (9019 == errorno){
            [weakSelf deal9019Error];
        }else{
            NSString *err = [NSString stringWithFormat:@"获取验证码失败（%d）",errorno];
            [weakSelf showHudWithText:err];
            [weakSelf hideHudDelay:2.0];
        }
    }];

}
- (void)requestPhoneAuthCode{
    
    NSString *userNo = [TRUUserAPI getUser].userId;
    __weak typeof(self) weakSelf = self;
    
    NSString *sign = [NSString stringWithFormat:@"%@%@",self.phoneTF.text,@"2"];
    NSArray *ctxx = @[@"phone",self.phoneTF.text,@"authtype",@"2"];
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *para = [xindunsdk encryptByUkey:userNo ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *paraDic = @{@"params":para};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/getauthcode"] withParts:paraDic onResult:^(int errorno, id responseBody) {
        [weakSelf hideHudDelay:0.0];
        if (0 == errorno) {
            [weakSelf showHudWithText:@"手机验证码已发送，请输入验证码"];
            [weakSelf hideHudDelay:2.0];
            [weakSelf startTimer];
            weakSelf.codeBtn.enabled = NO;
        }else if (-5004 == errorno){
            [weakSelf showHudWithText:@"网络错误，请稍后重试"];
            [weakSelf hideHudDelay:2.0];
        }else if (9019 == errorno){
            [weakSelf deal9019Error];
        }else{
            NSString *err = [NSString stringWithFormat:@"获取验证码失败（%d）",errorno];
            [weakSelf showHudWithText:err];
            [weakSelf hideHudDelay:2.0];
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
        [self showHudWithText:@"请输入密码"];
        [self hideHudDelay:1.5f];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
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
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/userinfosync2"] withParts:paraDic onResult:^(int errorno, id responseBody) {
        [weakSelf hideHudDelay:0];
        if (errorno == 0 ) {
            if(responseBody){
                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                int code = [dic[@"code"] intValue];
                if (code == 0) {
                    [weakSelf stopTimer];
                    TRUUserModel *user = [TRUUserAPI getUser];
                    if ([codeType isEqualToString:@"phone"]) {
                        user.phone = weakSelf.phoneTF.text;
                    }else if ([codeType isEqualToString:@"email"]){
                        user.email = weakSelf.phoneTF.text;
                    }else if
                        ([codeType isEqualToString:@"employeenum"]){
                            user.employeenum = weakSelf.phoneTF.text;
                        }
                    [TRUUserAPI saveUser:user];
                    //先用应用window
                    
                    UIWindow *window =  [UIApplication sharedApplication].windows[0];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                    id delegate = [UIApplication sharedApplication].delegate;
                    
                    if (window.rootViewController == weakSelf.navigationController) {
                        if ([delegate respondsToSelector:@selector(changeRootVCWithInfo)]) {
                            [delegate performSelector:@selector(changeRootVCWithInfo)];
                        }
                        return;
                    }else{
                        
                        [weakSelf.navigationController dismissViewControllerAnimated:NO completion:^{
                            if ([delegate respondsToSelector:@selector(changeRootVCWithInfo)]) {
                                [delegate performSelector:@selector(changeRootVCWithInfo)];
                            }
                        }];
                        return;
                    }
#pragma clang diagnostic pop
                }else{
                    [weakSelf showHudWithText:@"用户信息解析失败"];
                    [weakSelf hideHudDelay:2.0];
                }
            }
            UIWindow *window =  [UIApplication sharedApplication].windows[0];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            id delegate = [UIApplication sharedApplication].delegate;
            
            if (window.rootViewController == weakSelf.navigationController) {
                if ([delegate respondsToSelector:@selector(changeRootVCWithInfo)]) {
                    [delegate performSelector:@selector(changeRootVCWithInfo)];
                }
                return;
            }else{
                
                [weakSelf.navigationController dismissViewControllerAnimated:NO completion:^{
                    if ([delegate respondsToSelector:@selector(changeRootVCWithInfo)]) {
                        [delegate performSelector:@selector(changeRootVCWithInfo)];
                    }
                }];
                return;
            }
#pragma clang diagnostic pop
        }else if(errorno == -5004){
            [weakSelf showHudWithText:@"网络错误，请稍后重试"];
            [weakSelf hideHudDelay:2.0];
        }else if (9019 == errorno){
            [weakSelf deal9019Error];
        }else{
            NSString *err = [NSString stringWithFormat:@"同步信息失败（%d）",errorno];
            [weakSelf showHudWithText:err];
            [weakSelf hideHudDelay:2.0];
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
    
    NSString *modeStr = [TRUCompanyAPI getCompany].activation_mode;
    
    
    
    if (modeStr.length == 3) {//完善方式(1:邮箱,2:手机,3:工号)
        NSArray *arr = [modeStr componentsSeparatedByString:@","];
        NSString *str = arr[0];
        if ([str isEqualToString:@"1"]) {
            NSString *textStr = @"您的邮箱为:";
            self.textLabel.text = textStr;
            self.numLabel.text = [TRUUserAPI getUser].email;
        }else if ([str isEqualToString:@"2"]){
            NSString *textStr = @"您的手机号为:";
            self.textLabel.text = textStr;
            self.numLabel.text = [TRUUserAPI getUser].phone;
        }else if ([str isEqualToString:@"3"]){
            NSString *textStr = @"您的工号为:";
            self.textLabel.text = textStr;
            self.numLabel.text = [TRUUserAPI getUser].employeenum;
        }
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
    __weak typeof(self) weakSelf = self;
    
    [self showConfrimCancelDialogViewWithTitle:@"" msg:@"如果您现在返回，需重新进行设备绑定流程" confrimTitle:@"确定" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
        if (weakSelf.isStart) {
            if ([TRUUserAPI getUser].userId) {
                [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
                [TRUUserAPI deleteUser];
                [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
                [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
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
            if (weakSelf.isScan) {
                if ([TRUUserAPI getUser].userId) {
                    [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
                    [TRUUserAPI deleteUser];
                    [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
                    [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
                }
                if (weakSelf.backBlocked) {
                    weakSelf.backBlocked();
                }
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }else{
                
                [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
                [TRUUserAPI deleteUser];
                [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
                [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
                
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
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
