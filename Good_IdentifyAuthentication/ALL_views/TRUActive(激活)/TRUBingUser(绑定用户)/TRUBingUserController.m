//
//  TRUBingUserController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/11/10.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUBingUserController.h"
#import "NSString+Regular.h"
#import "NSString+Trim.h"
#import "xindunsdk.h"
#import "TRUTimerButton.h"
#import "TRUUserAPI.h"
#import "JPUSHService.h"
#import "TRUAddPersonalInfoViewController.h"
#import "TRUhttpManager.h"
#import "TRUUserLoginInfoModel.h"
#import "IQKeyboardManager.h"
#import "UIButton+Touch.h"
@interface TRUBingUserController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *numView;

@property (weak, nonatomic) IBOutlet UITextField *inputoneTF;

@property (weak, nonatomic) IBOutlet UITextField *inputphonemailTF;
@property (weak, nonatomic) IBOutlet UITextField *inputpasswordTF;//验证码
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UILabel *AccountTwoAuthLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verifyBtnTopConstraint;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, assign,getter=isTwoTimeAuth) BOOL twoTimeAuth;//二次验证登录次数

@property (nonatomic,strong) TRUUserLoginInfoModel *loginModel;

@property (nonatomic,copy) NSString *authType;

@end

@implementation TRUBingUserController
{
    BOOL isPhone;
    BOOL isEmail;
    BOOL isEmployee;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _numView.hidden = YES;
    _sendBtn.hidden = YES;
    _iphoneEmialView.hidden = YES;
    self.verifyBtnTopConstraint.constant = -30.0;
    [IQKeyboardManager sharedManager].enable = YES;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"绑定";
//    if (self.isRegister) {
//        self.title = @"登录";
//    }else{
//        self.title = @"绑定";
//    }
    self.title = @"登录";
    isEmail = isPhone = isEmployee = NO;
    _inputpasswordTF.secureTextEntry = YES;
    [_inputoneTF addTarget:self action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [_sendBtn setBackgroundColor:DefaultColor];
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.layer.cornerRadius = 5.0;
    _sendBtn.timeInterval = 0.5;
}

-(void)valueChanged:(UITextField *)field{
    NSString  *str = field.text;
    if (str.length) {
        self.numView.hidden = NO;
    }
//    if ([str isPhone]) {
//        isPhone = YES;
//        isEmployee = NO;
//        isEmail = NO;
//        _numView.hidden = YES;
//        _sendBtn.hidden = NO;
//        _iphoneEmialView.hidden = NO;
//    }else if ([str isEmail]){
//        isPhone = NO;
//        isEmployee = NO;
//        isEmail = YES;
//        _numView.hidden = YES;
//        _sendBtn.hidden = NO;
//        _iphoneEmialView.hidden = NO;
//    }else{
//        isPhone = NO;
//        isEmployee = YES;
//        isEmail = NO;
//        _numView.hidden = NO;
//        _sendBtn.hidden = YES;
//        _iphoneEmialView.hidden = YES;
//    }
}

- (IBAction)eyeBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _inputpasswordTF.secureTextEntry = sender.selected;
}

#pragma mark -验证
- (IBAction)VerifyBtnClick:(UIButton *)sender {
    if (self.isTwoTimeAuth) {
        [self.view endEditing:YES];
        if (_inputoneTF.text.length == 0){
            [self showHudWithText:@"用户名不能为空"];
            [self hideHudDelay:1.5f];
            return;
        }
        if (_inputpasswordTF.text.length == 0 && isEmployee) {
            [self showHudWithText:@"请输入业务系统密码"];
            [self hideHudDelay:1.5f];
            return;
        }
        
        if (_inputphonemailTF.text.length == 0 && isEmployee == NO) {
            [self showHudWithText:@"请输入您收到的验证码"];
            [self hideHudDelay:1.5f];
            return;
        }
        
        if (isEmail) {//邮箱验证
            [self verifyJpushId:@"email"];
        }
        if (isPhone) {//手机验证
            [self verifyJpushId:@"phone"];
        }
        if (isEmployee) {//员工号验证
            //        [self verifyJpushId:@"employeenum"];
            //        先去判定是否审批
            [self requestCodeForUserEmployeenum:_inputoneTF.text type:@"employeenum"];
        }
    }else{
        NSString *account = self.inputoneTF.text;
        NSString *password = self.inputpasswordTF.text;
        __weak typeof(self) weakself = self;
        NSString *str = [NSString stringWithFormat:@"{\"account\":\"%@\",\"password\":\"%@\"}",account,password];
        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        NSString *para = [xindunsdk getParamsWithencryptText:str user:account];
        NSDictionary *paramsDic = @{@"params" : para};
        [TRUhttpManager sendCIMSRequestWithUrlRegiste:[baseUrl stringByAppendingString:@"/mapi/01/init/xibUser"] withParts:paramsDic onResult:^(int error, id responseBody) {
            [weakself hideHudDelay:0.0];
            NSDictionary *dicc = nil;
            if(0==error && responseBody){
//                YCLog(@"success");
                NSDictionary *dic = responseBody;
                dicc = [xindunsdk decodeServerResponse:dic[@"response_body"]];
                if ([dicc[@"code"] intValue] == 0) {
                    TRUUserLoginInfoModel *model = [TRUUserLoginInfoModel modelWithDic:dicc[@"resp"][@"userinfo"]];
                    weakself.authType = dicc[@"resp"][@"authType"];
                    weakself.loginModel = model;
                    weakself.twoTimeAuth = YES;
                    weakself.AccountTwoAuthLabel.hidden = NO;
                    weakself.iphoneEmialView.hidden = NO;
                    weakself.sendBtn.hidden = NO;
                    weakself.inputoneTF.userInteractionEnabled = NO;
                    weakself.numView.userInteractionEnabled = NO;
                    NSString *showText;
                    if ([weakself.authType isEqualToString:@"email"]) {
                        showText = model.email;
                        isEmail = YES;
                        isEmployee = NO;
                        isPhone = NO;
                    }else if ([weakself.authType isEqualToString:@"phone"]) {
                         showText = model.phone;
                        isPhone = YES;
                        isEmployee = NO;
                        isEmail = NO;
                    }
                    if (IS_IPHONE_4_OR_LESS ) {
                        self.verifyBtnTopConstraint.constant = 40;
                    }else{
                        self.verifyBtnTopConstraint.constant = 80;
                    }
                    NSString *authStr;
                    if ([self.authType isEqualToString:@"email"]) {
                        authStr = @"邮箱";
                    }else if([self.authType isEqualToString:@"phone"]){
                        authStr = @"手机号";
                    }else{
                        authStr = @"工号";
                    }
                    weakself.AccountTwoAuthLabel.text = [NSString stringWithFormat:@"%@ : %@",authStr,showText];
                }
            }else if(-5004 == error){
                [weakself showHudWithText:@"网络错误，请稍后重试"];
                [weakself hideHudDelay:2.0];
            }else if(9001 == error){
                [weakself showHudWithText:@"激活码不正确，请确认后重新输入"];
                [weakself hideHudDelay:2.0];
            }else if (9019 == error){
                [weakself deal9019Error];
            }else if (9011 == error){
                NSString *msg = responseBody[@"msg"];
                if([msg length]){
                    [weakself showHudWithText:msg];
                    [weakself hideHudDelay:2.0];
                    
                }
            }else{
                NSString *err = [NSString stringWithFormat:@"其他错误（%d）",error];
                [weakself showHudWithText:err];
                [weakself hideHudDelay:2.0];
            }
        }];
    }
    
}

-(void)verifyJpushId:(NSString *)type{
    NSString *activeNumber = _inputphonemailTF.text.alltrim;
    if(isEmployee){
        activeNumber = _inputpasswordTF.text.alltrim;
    }else if(isPhone){
        activeNumber = _inputphonemailTF.text.alltrim;
    }
    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pushID = [stdDefaults objectForKey:@"TRUPUSHID"];
    [self showHudWithText:@"正在激活..."];
    if (!pushID || pushID.length == 0) {//说明pushid获取失败
        pushID = @"12123edfadcac";
        [self active4User:activeNumber pushID:pushID type:type];
    }else{
        if ([type isEqualToString:@"employeenum"]) {
            [self active4User:self.inputpasswordTF.text.trim pushID:pushID type:type];
        }else{
            [self active4User:activeNumber pushID:pushID type:type];
        }
    }
}


- (IBAction)sendCodeBtnClcik:(UIButton *)sender {
    
    if (_inputoneTF.text.length == 0) {
        [self showHudWithText:@"请输入您的手机号/邮箱"];
        [self hideHudDelay:1.5f];
        return;
    }
    NSString *str = _inputoneTF.text;
    if (isPhone) {//是手机号
        [self requestCodeForUser:str type:@"phone"];
    }else if (isEmail){//是邮箱
        [self requestCodeForUser:str type:@"email"];
    }else{
        [self showHudWithText:@"请输入正确的手机号/邮箱"];
        [self hideHudDelay:1.5f];
        return;
    }
    
}

-(void)hiddenWithfalsh:(NSInteger)teger{
    if (teger == 0) {
        _numView.hidden = YES;
        _sendBtn.hidden = YES;
        _iphoneEmialView.hidden = YES;
    }else if (teger == 1){//输入的是手机号或者邮箱
        _numView.hidden = YES;
        _sendBtn.hidden = NO;
        _iphoneEmialView.hidden = NO;
    }else if (teger == 2){//输入的是员工号
        _numView.hidden = NO;
        _sendBtn.hidden = YES;
        _iphoneEmialView.hidden = YES;
    }
}
- (void)active4User:(NSString *)activeNumber pushID:(NSString *)pushID type:(NSString *)type{
    __weak typeof(self) weakSelf = self;
    NSString *userStr;
    if (isEmail) {
        userStr = self.loginModel.email;
        if (userStr.length==0) {
            [weakSelf hideHudDelay:0.0];
            [self showConfrimCancelDialogViewWithTitle:@"" msg:@"您的账号没有预留邮箱，请联系管理员" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
                //                [self.navigationController popViewControllerAnimated:YES];
            } cancelBlock:nil];
            return;
        }
    }else if(isPhone){
        userStr = self.loginModel.phone;
        if (userStr.length==0) {
            [weakSelf hideHudDelay:0.0];
            [self showConfrimCancelDialogViewWithTitle:@"" msg:@"您的账号没有预留手机号，请联系管理员" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
                //                [self.navigationController popViewControllerAnimated:YES];
            } cancelBlock:nil];
            return;
        }
    }else{
        userStr = @"";
    }
    
    NSString *singStr = [NSString stringWithFormat:@",\"userno\":\"%s\",\"pushid\":\"%s\",\"type\":\"%s\",\"authcode\":\"%s\"", [userStr.trim UTF8String],[pushID UTF8String], [type UTF8String],[activeNumber UTF8String]];
    NSString *para = [xindunsdk encryptBySkey:userStr.trim ctx:singStr isType:YES];
    NSDictionary *paramsDic = @{@"params" : para};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/active"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        [weakSelf hideHudDelay:0.0];
        NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
        if (errorno == 0) {
            NSString *userId = nil;
            int err = [xindunsdk privateVerifyCIMSInitForUserNo:self.inputoneTF.text.trim response:dic[@"resp"] userId:&userId];
            
            if (err == 0) {
                //同步用户信息
                NSString *paras = [xindunsdk encryptByUkey:userId ctx:nil signdata:nil isDeviceType:NO];
                NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
                [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getuserinfo"] withParts:dictt onResult:^(int errorno, id responseBody) {
                    NSDictionary *dicc = nil;
                    if (errorno == 0 && responseBody) {
                        dicc = [xindunsdk decodeServerResponse:responseBody];
                        if ([dicc[@"code"] intValue] == 0) {
                            dicc = dicc[@"resp"];
                            //用户信息同步成功
                            TRUUserModel *model = [TRUUserModel modelWithDic:dicc];
                            model.userId = userId;
                            [TRUUserAPI saveUser:model];
                            if ([self checkPersonInfoVC:model]) {//yes 表示需要完善信息
                                TRUAddPersonalInfoViewController *infoVC = [[TRUAddPersonalInfoViewController alloc] init];
                                if ([type isEqualToString:@"phone"]) {
                                    infoVC.phone = model.phone;
                                }else if ([type isEqualToString:@"email"]){
                                    infoVC.email = model.email;
                                }else{
                                    infoVC.employeenum = model.employeenum;//员工号
                                }
                                [weakSelf.navigationController pushViewController:infoVC animated:YES];
                            }else{//同步信息成功，信息完整，跳转页面
#pragma clang diagnostic ignored "-Wundeclared-selector"
                                id delegate = [UIApplication sharedApplication].delegate;
                                if ([delegate respondsToSelector:@selector(changeLoginRootVC)]) {
                                    [delegate performSelector:@selector(changeLoginRootVC)];
                                }
                            }
                        }
                    }
                }];
            }
        }else if(-5004 == errorno){
            [self showHudWithText:@"网络错误，请稍后重试"];
            [self hideHudDelay:2.0];
        }else if(9001 == errorno){
            [self showHudWithText:@"激活码不正确，请确认后重新输入"];
            [self hideHudDelay:2.0];
        }else if (9019 == errorno){
            [self deal9019Error];
        }else{
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
            [self showHudWithText:err];
            [self hideHudDelay:2.0];
        }
    }];
}



#pragma mark -获取验证码

-(void)requestCodeForUser:(NSString *)user type:(NSString *)type{
    
    __weak typeof(self) weakself = self;
    NSString *userStr;
    if (isEmail) {
        userStr = self.loginModel.email;
        if (userStr.length==0) {
            [self showConfrimCancelDialogViewWithTitle:@"" msg:@"您的账号没有预留邮箱，请联系管理员" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
//                [self.navigationController popViewControllerAnimated:YES];
            } cancelBlock:nil];
            return;
        }
        
    }else if(isPhone){
        userStr = self.loginModel.phone;
        if (userStr.length==0) {
            [self showConfrimCancelDialogViewWithTitle:@"" msg:@"您的账号没有预留手机号，请联系管理员" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
//                [self.navigationController popViewControllerAnimated:YES];
            } cancelBlock:nil];
            return;
        }
    }else{
        userStr = @"";
    }
    [self showHudWithText:@"正在申请激活码..."];
    NSString *signStr = [NSString stringWithFormat:@",\"userno\":\"%s\",\"type\":\"%s\"}", [userStr.trim UTF8String], [type UTF8String]];
    NSString *para = [xindunsdk encryptBySkey:userStr.trim ctx:signStr isType:NO];
    NSDictionary *paramsDic = @{@"params" : para};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/apply4active"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        [weakself hideHudDelay:0.0];
        if (0 == errorno) {
            YCLog(@"发送成功");
            //第一次申请 也就是第一次进入这个页面，开始倒计时
            [self showHudWithText:@"发送成功"];
            [self hideHudDelay:2.0];
            self.sendBtn.enabled = NO;
            [self startTimer];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self showHudWithText:@"发送成功"];
//                [self hideHudDelay:2.0];
//                self.sendBtn.enabled = NO;
//                [self startTimer];
//            });
            
        }else if (-5004 == errorno){
            [self showHudWithText:@"网络错误，请稍后重试"];
            [self hideHudDelay:2.0];
        }else if (9019 == errorno){
            [self deal9019Error];
        }else if (9021 == errorno){
            self.sendBtn.enabled = NO;
            [self startTimer];
            [self deal9021ErrorWithBlock:nil];
        }else if (9022 == errorno){
            [self deal9022ErrorWithBlock:nil];
        }else if (9023 == errorno){
            [self stopTimer];
            [self deal9023ErrorWithBlock:nil];
        }else if (9026 == errorno){
            [self stopTimer];
            
        }else{
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
            [self showHudWithText:err];
            [self hideHudDelay:2.0];
        }
    }];
}

-(void)requestCodeForUserEmployeenum:(NSString *)user type:(NSString *)type{
    [self showHudWithText:@"正在申请激活..."];
    __weak typeof(self) weakself = self;
    NSString *signStr = [NSString stringWithFormat:@",\"userno\":\"%s\",\"type\":\"%s\"}", [self.inputoneTF.text.trim UTF8String], [type UTF8String]];
    NSString *para = [xindunsdk encryptBySkey:self.inputoneTF.text.trim ctx:signStr isType:NO];
    NSDictionary *paramsDic = @{@"params" : para};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/apply4active"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        [weakself hideHudDelay:0.0];
        if (0 == errorno) {
            YCLog(@"发送成功");
            //第一次申请 也就是第一次进入这个页面，开始倒计时
            [weakself verifyJpushId:@"employeenum"];
            
        }else if (-5004 == errorno){
            [weakself showHudWithText:@"网络错误，请稍后重试"];
            [weakself hideHudDelay:2.0];
        }else if (9019 == errorno){
            [weakself deal9019Error];
        }else if (9021 == errorno){
            weakself.sendBtn.enabled = NO;
            [weakself startTimer];
            [weakself deal9021ErrorWithBlock:nil];
        }else if (9022 == errorno){
            [weakself deal9022ErrorWithBlock:nil];
        }else if (9023 == errorno){
            [weakself stopTimer];
            [weakself deal9023ErrorWithBlock:nil];
        }else if (9026 == errorno){
            [weakself stopTimer];
            
        }else{
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
            [weakself showHudWithText:err];
            [weakself hideHudDelay:2.0];
        }
    }];
}

- (BOOL)checkPersonInfoVC:(TRUUserModel *)model{
    
    if (model.phone.length>0 || model.email.length>0) {
        return NO;
    }else{
        return YES;
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
    
    if (totalTime >= 1) {
        totalTime -- ;
        NSString *leftTitle  = [NSString stringWithFormat:@"已发送(%ds)",totalTime];
        [self.sendBtn setTitle:leftTitle forState:UIControlStateNormal];
    }else{
        totalTime = 60;
        [self.sendBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        self.sendBtn.enabled = YES;
        [self stopTimer];
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopTimer];
    [IQKeyboardManager sharedManager].enable = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

