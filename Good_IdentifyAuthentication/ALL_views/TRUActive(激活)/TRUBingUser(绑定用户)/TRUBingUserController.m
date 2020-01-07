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
#import "TRUCompanyAPI.h"
#import "TRULicenseAgreementViewController.h"
#import "TRUhttpManager.h"
#import "AppDelegate.h"
#import "TRUTokenUtil.h"
@interface TRUBingUserController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *numView;

@property (weak, nonatomic) IBOutlet UITextField *inputoneTF;

@property (weak, nonatomic) IBOutlet UITextField *inputphonemailTF;
@property (weak, nonatomic) IBOutlet UITextField *inputpasswordTF;//验证码
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UIView *AccountbottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneemailTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verifySendTopContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verifyButtonTopContraint;

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, copy) NSString *loginStr;
@property (nonatomic,assign) int activeModel;
@property (nonatomic,assign) BOOL multipleVerify;
@end

@implementation TRUBingUserController
{
    BOOL isPhone;
    BOOL isEmail;
    BOOL isEmployee;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self hiddenWithfalsh:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定";
    isEmail = isPhone = isEmployee = NO;
    self.verifyBtn.backgroundColor = DefaultGreenColor;
    self.verifyBtn.layer.cornerRadius = 5;
    self.verifyBtn.layer.masksToBounds = YES;
    self.AccountbottomView.layer.cornerRadius = 5;
    self.AccountbottomView.layer.borderWidth = 1;
    self.AccountbottomView.layer.borderColor = RGBCOLOR(215, 215, 215).CGColor;
    self.numView.layer.cornerRadius = 5;
    self.numView.layer.borderWidth = 1;
    self.numView.layer.borderColor = RGBCOLOR(215, 215, 215).CGColor;
    self.iphoneEmialView.layer.cornerRadius = 5;
    self.iphoneEmialView.layer.borderWidth = 1;
    self.iphoneEmialView.layer.borderColor = RGBCOLOR(215, 215, 215).CGColor;
    self.inputphonemailTF.delegate = self;
    self.inputpasswordTF.delegate = self;
    self.inputphonemailTF.delegate = self;
    NSString *activeStr = [TRUCompanyAPI getCompany].activation_mode;
    if (activeStr.length>0) {
        NSArray *arr = [activeStr componentsSeparatedByString:@","];
        if (arr.count>0) {
            NSString *modeStr = arr[0];
            modeStr = @"4";
            self.loginStr = modeStr;
            if ([modeStr isEqualToString:@"1"]) {//激活方式 激活方式(1:邮箱,2:手机,3:工号,4:工号密码加手机，5工号密码加邮箱)
                isEmail = YES;
                _inputoneTF.placeholder = @"请输入您的邮箱";
                _numView.hidden = YES;
                _sendBtn.hidden = NO;
                _iphoneEmialView.hidden = NO;
                self.activeModel = 1;
            }else if ([modeStr isEqualToString:@"2"]){
                isPhone = YES;
                _inputoneTF.placeholder = @"请输入您的手机号";
                _numView.hidden = YES;
                _sendBtn.hidden = NO;
                _iphoneEmialView.hidden = NO;
                self.activeModel = 2;
            }else if ([modeStr isEqualToString:@"3"]){
                isEmployee = YES;
                _inputoneTF.placeholder = @"请输入您的账号";
                _numView.hidden = NO;
                _sendBtn.hidden = YES;
                _iphoneEmialView.hidden = YES;
                self.activeModel = 3;
            }else if ([modeStr isEqualToString:@"4"]){
                isEmployee = YES;
                _inputoneTF.placeholder = @"请输入您的账号";
                _numView.hidden = NO;
                _sendBtn.hidden = YES;
                _iphoneEmialView.hidden = YES;
                self.activeModel = 4;
                self.phoneemailTopConstraint.constant = 140;
                self.verifySendTopContraint.constant = 140;
                self.verifyButtonTopContraint.constant = - 55;
            }else if ([modeStr isEqualToString:@"5"]){
                isEmployee = YES;
                _inputoneTF.placeholder = @"请输入您的账号";
                _numView.hidden = NO;
                _sendBtn.hidden = YES;
                _iphoneEmialView.hidden = YES;
                self.phoneemailTopConstraint.constant = 140;
                self.verifySendTopContraint.constant = 140;
                self.verifyButtonTopContraint.constant = - 55;
                self.activeModel = 5;
            }
        }
        
    }else{
        [_inputoneTF addTarget:self action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    }
    _inputpasswordTF.secureTextEntry = YES;
    [_sendBtn setBackgroundColor:DefaultGreenColor];
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.layer.cornerRadius = 5.0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//如果为回车则下一个输入框或者登录
    switch (self.activeModel) {
        case 1:
        {
            
        }
            break;
        case 2:
        {

        }
            break;
        case 3:
        {

        }
            break;
        case 4:
        {
            if (textField == self.inputoneTF) {
                [self.inputpasswordTF becomeFirstResponder];
            }else if(textField == self.inputpasswordTF){
                [self firstVerify];
            }else if(textField == self.inputphonemailTF){
                
            }
        }
            break;
        case 5:
        {

        }
            break;
        default:
            break;
    }
    return YES;
}

-(void)valueChanged:(UITextField *)field{
    NSString *str = field.text;
    
    if ([str isPhone]) {
        isPhone = YES;
        isEmployee = NO;
        isEmail = NO;
        [self hiddenWithfalsh:1];
        
    }else if ([str isEmail]){
        isPhone = NO;
        isEmployee = NO;
        isEmail = YES;
        [self hiddenWithfalsh:1];
    }else{
        switch (self.activeModel) {
            case 3:
            {
                isPhone = NO;
                isEmployee = YES;
                isEmail = NO;
                [self hiddenWithfalsh:2];
            }
                break;
            case 4:
            {
                if (self.multipleVerify) {
                    isPhone = NO;
                    isEmployee = YES;
                    isEmail = NO;
                    [self hiddenWithfalsh:3];
                }else{
                    isPhone = NO;
                    isEmployee = YES;
                    isEmail = NO;
                    [self hiddenWithfalsh:2];
                }
            }
                break;
            case 5:
            {
                if (self.multipleVerify) {
                    isPhone = NO;
                    isEmployee = YES;
                    isEmail = NO;
                    [self hiddenWithfalsh:3];
                }else{
                    isPhone = NO;
                    isEmployee = YES;
                    isEmail = NO;
                    [self hiddenWithfalsh:2];
                }
            }
                break;
            default:
                break;
        }
        
    }
}

- (IBAction)eyeBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _inputpasswordTF.secureTextEntry = sender.selected;
}

#pragma mark -验证
- (IBAction)VerifyBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (_inputoneTF.text.trim.length == 0 && isEmployee) {
        [self showHudWithText:@"请输入正确的账号/验证码信息"];
        [self hideHudDelay:1.5f];
        return;
    }
    if (_inputpasswordTF.text.trim.length == 0 && isEmployee) {
        [self showHudWithText:@"请输入正确的账号/密码信息"];
        [self hideHudDelay:1.5f];
        return;
    }
    if (_inputphonemailTF.text.trim.length == 0 && isEmployee == NO) {
        [self showHudWithText:@"请输入正确的账号/验证码信息"];
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
        switch (self.activeModel) {
            case 3:
            {
                [self requestCodeForUserEmployeenum:_inputoneTF.text type:@"employeenum"];
            }
                break;
            case 4:
            {
                if (self.multipleVerify) {
                    [self verifyJpushId:@"phone"];
                }else{
                    [self firstVerify];
                }
            }
                break;
            case 5:
            {
                if (self.multipleVerify) {
                    [self verifyJpushId:@"email"];
                }else{
                    [self firstVerify];
                }
            }
                break;
            default:
                break;
        }
    }
}

- (void)firstVerify{
    
}

-(void)verifyJpushId:(NSString *)type{
    NSString *activeNumber = _inputphonemailTF.text.alltrim;
    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pushID = [stdDefaults objectForKey:@"TRUPUSHID"];
    [self showHudWithText:@"正在激活..."];
    
    if (!pushID || pushID.length == 0) {//说明pushid获取失败
        if ([type isEqualToString:@"employeenum"]) {
            [self active4User:self.inputpasswordTF.text.trim pushID:@"1234567890" type:type];
        }else{
            [self active4User:activeNumber pushID:@"1234567890" type:type];
        }
        NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
        [stdDefaults setObject:@"1234567890" forKey:@"TRUPUSHID"];
        [stdDefaults synchronize];
        //#endif
    }else{
        if ([type isEqualToString:@"employeenum"]) {
            [self active4User:self.inputpasswordTF.text.trim pushID:pushID type:type];
        }else{
            [self active4User:activeNumber pushID:pushID type:type];
        }
    }
}

- (IBAction)sendCodeBtnClcik:(UIButton *)sender {
    if (self.activeModel==4) {
        return;
    }
    if (self.activeModel==5) {
        return;
    }
    if (_inputoneTF.text.trim.length == 0 && isEmail){
        [self showHudWithText:@"请输入您的邮箱"];
        [self hideHudDelay:1.5f];
        return;
    }
    if (_inputoneTF.text.trim.length == 0 && isPhone){
        [self showHudWithText:@"请输入您的手机号"];
        [self hideHudDelay:1.5f];
        return;
    }
    if ([_inputoneTF.text.trim isPhone] && isEmail) {
        [self showHudWithText:@"请输入正确格式的邮箱账号"];
        [self hideHudDelay:1.5f];
        return;
    }
    if ([_inputoneTF.text.trim isEmail] && isPhone) {
        [self showHudWithText:@"请输入正确格式的手机号"];
        [self hideHudDelay:1.5f];
        return;
    }
    NSString *str = _inputoneTF.text.trim;
    if ([str isPhone]) {//是手机号
        [self requestCodeForUser:str type:@"phone"];
    }else if ([str isEmail]){//是邮箱
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
    }else if (teger == 3){//二次验证，全开
        _numView.hidden = NO;
        _sendBtn.hidden = NO;
        _iphoneEmialView.hidden = NO;
    }
}
- (NSString *)toReadableJSONStringWithDic:(NSDictionary *)dic {
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    if (data == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
}
- (void)active4User:(NSString *)activeNumber pushID:(NSString *)pushID type:(NSString *)type{
    __weak typeof(self) weakSelf = self;
    NSString *singStr = [NSString stringWithFormat:@",\"userno\":\"%s\",\"pushid\":\"%s\",\"type\":\"%s\",\"authcode\":\"%s\"", [self.inputoneTF.text.trim UTF8String],[pushID UTF8String], [type UTF8String],[activeNumber UTF8String]];
    NSString *para = [xindunsdk encryptBySkey:self.inputoneTF.text.trim ctx:singStr isType:YES];
    NSDictionary *paramsDic = @{@"params" : para};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/active"] withParts:paramsDic onResultWithMessage:^(int errorno, id responseBody, NSString *message) {
        [weakSelf hideHudDelay:0.0];
        NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
        if (errorno == 0) {
            NSString *userId = nil;
            int err = [xindunsdk privateVerifyCIMSInitForUserNo:self.inputoneTF.text.trim response:dic[@"resp"] userId:&userId];
            
            if (err == 0) {
                //同步用户信息
                NSString *paras = [xindunsdk encryptByUkey:userId ctx:nil signdata:nil isDeviceType:NO];
                NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
//                NSString *baseUrl1 = @"http://192.168.1.150:8004";
                [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getuserinfo"] withParts:dictt onResult:^(int errorno, id responseBody) {
                    [weakSelf hideHudDelay:0.0];
                    NSDictionary *dicc = nil;
                    if (errorno == 0 && responseBody) {
                        dicc = [xindunsdk decodeServerResponse:responseBody];
                        
                        if ([dicc[@"code"] intValue] == 0) {
                            dicc = dicc[@"resp"];
//                            NSString *oldStr = dicc[@"accounts"];
//                            NSString *replaceOld = @"\"";
//                            NSString *replaceNew = @"\"";
//                            NSString *strUrl = [oldStr stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
//                            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dicc];
//                            dicc[@"accounts"] = strUrl;
                            //用户信息同步成功
                            TRUUserModel *model = [TRUUserModel yy_modelWithDictionary:dicc];
                            NSString *json = [self toReadableJSONStringWithDic:dicc];
                            model.userId = userId;
                            [TRUUserAPI saveUser:model];
                            AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
                            appdelegate.isNeedPush = YES;
                            if (0) {//yes 表示需要完善信息
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
                                if ([delegate respondsToSelector:@selector(changeRootVC)]) {
                                    [delegate performSelector:@selector(changeRootVC)];
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
            if ([type isEqualToString:@"email"]) {
                [self showHudWithText:@"请输入正确的账号/验证码信息"];
                [self hideHudDelay:2.0];
            }else if([type isEqualToString:@"phone"]){
                [self showHudWithText:@"请输入正确的账号/验证码信息"];
                [self hideHudDelay:2.0];
            }else if([type isEqualToString:@"employeenum"]){
                [self showHudWithText:@"请输入正确的账号/密码"];
                [self hideHudDelay:2.0];
            }
            
        }else if(9002 == errorno){
            if ([type isEqualToString:@"email"]) {
                [self showHudWithText:@"请输入正确的账号信息"];
                [self hideHudDelay:2.0];
            }else if([type isEqualToString:@"phone"]){
                [self showHudWithText:@"请输入正确的账号信息"];
                [self hideHudDelay:2.0];
            }else if([type isEqualToString:@"employeenum"]){
                [self showHudWithText:@"请输入正确的账号信息"];
                [self hideHudDelay:2.0];
            }
        }else if (9019 == errorno){
            [self deal9019Error];
        }else if (9016 == errorno){
            [self showHudWithText:@"验证码失效"];
            [self hideHudDelay:2.0];
        }else{
            NSString *err = [NSString stringWithFormat:@"%@",message];
            [self showHudWithText:@"激活失败"];
            [self hideHudDelay:2.0];
        }
    }];
    
}

#pragma mark -获取验证码
-(void)requestCodeForUser:(NSString *)user type:(NSString *)type{
    [self showHudWithText:@"正在申请激活码..."];
    __weak typeof(self) weakSelf = self;
    NSString *signStr = [NSString stringWithFormat:@",\"userno\":\"%@\",\"type\":\"%s\"}", self.inputoneTF.text, [type UTF8String]];
    NSString *para = [xindunsdk encryptBySkey:self.inputoneTF.text ctx:signStr isType:NO];
    NSDictionary *paramsDic = @{@"params" : para};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    YCLog(@"baseUrl = %@",baseUrl);
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/apply4active"] withParts:paramsDic onResultWithMessage:^(int errorno, id responseBody, NSString *message) {
        [weakSelf hideHudDelay:0.0];
        if (0 == errorno) {
            YCLog(@"发送成功");
            //第一次申请 也就是第一次进入这个页面，开始倒计时
            [weakSelf showHudWithText:@"发送成功"];
            [weakSelf hideHudDelay:2.0];
            weakSelf.sendBtn.enabled = NO;
            [weakSelf startTimer];
            
        }else if (-5004 == errorno){
            if ([type isEqualToString:@"email"]) {
                [weakSelf showHudWithText:@"邮箱错误"];
                [weakSelf hideHudDelay:2.0];
            }else if([type isEqualToString:@"phone"]){
                [weakSelf showHudWithText:@"手机号错误"];
                [weakSelf hideHudDelay:2.0];
            }
        }else if (9001 == errorno){
            if ([type isEqualToString:@"email"]) {
                [weakSelf showHudWithText:@"请输入正确的账号信息"];
                [weakSelf hideHudDelay:2.0];
            }else if([type isEqualToString:@"phone"]){
                [weakSelf showHudWithText:@"请输入正确的账号信息"];
                [weakSelf hideHudDelay:2.0];
            }
        }else if (9002 == errorno){
            if ([type isEqualToString:@"email"]) {
                [weakSelf showHudWithText:@"请输入正确的账号信息"];
                [weakSelf hideHudDelay:2.0];
            }else if([type isEqualToString:@"phone"]){
                [weakSelf showHudWithText:@"请输入正确的账号信息"];
                [weakSelf hideHudDelay:2.0];
            }
        }else if (9019 == errorno){
            [weakSelf deal9019Error];
        }else if (9021 == errorno){
            weakSelf.sendBtn.enabled = NO;
            [weakSelf startTimer];
            [weakSelf deal9021ErrorWithBlock:nil];
        }else if (9022 == errorno){
            [weakSelf deal9022ErrorWithBlock:nil];
        }else if (9023 == errorno){
            [weakSelf stopTimer];
            [weakSelf deal9023ErrorWithBlock:nil];
        }else if (9026 == errorno){
            [weakSelf stopTimer];
            [weakSelf deal9026ErrorWithBlock:nil];
        }else if (9036 == errorno){
            [weakSelf showHudWithText:message];
            [weakSelf hideHudDelay:2.0];
        }else{
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
            [weakSelf showHudWithText:@"激活失败"];
            [weakSelf hideHudDelay:2.0];
        }
    }];
}

-(void)requestCodeForUserEmployeenum:(NSString *)user type:(NSString *)type{
    [self showHudWithText:@"正在申请激活..."];
    __weak typeof(self) weakSelf = self;
    NSString *signStr = [NSString stringWithFormat:@",\"userno\":\"%s\",\"type\":\"%s\"}", [self.inputoneTF.text.trim UTF8String], [type UTF8String]];
    NSString *para = [xindunsdk encryptBySkey:self.inputoneTF.text.trim ctx:signStr isType:NO];
    NSDictionary *paramsDic = @{@"params" : para};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/apply4active"] withParts:paramsDic onResultWithMessage:^(int errorno, id responseBody, NSString *message) {
        [self hideHudDelay:0.0];
        if (0 == errorno) {
            YCLog(@"发送成功");
            //第一次申请 也就是第一次进入这个页面，开始倒计时
            [weakSelf verifyJpushId:@"employeenum"];
            
        }else if (-5004 == errorno){
            [weakSelf showHudWithText:@"网络错误，请稍后重试"];
            [weakSelf hideHudDelay:2.0];
        }else if (9001 == errorno){
            [weakSelf showHudWithText:@"请输入正确的账号/密码"];
            [weakSelf hideHudDelay:2.0];
        }else if (9002 == errorno){
            [weakSelf showHudWithText:@"请输入正确的账号信息"];
            [weakSelf hideHudDelay:2.0];
        }else if (9019 == errorno){
            [weakSelf deal9019Error];
        }else if (9021 == errorno){
            weakSelf.sendBtn.enabled = NO;
            [weakSelf startTimer];
            [weakSelf deal9021ErrorWithBlock:nil];
        }else if (9022 == errorno){
            [weakSelf deal9022ErrorWithBlock:nil];
        }else if (9023 == errorno){
            [weakSelf stopTimer];
            [weakSelf deal9023ErrorWithBlock:nil];
        }else if (9026 == errorno){
            [weakSelf stopTimer];
            [weakSelf deal9026ErrorWithBlock:nil];
        }else{
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
            [weakSelf showHudWithText:@"激活失败"];
            [weakSelf hideHudDelay:2.0];
        }
    }];
    
}

- (BOOL)checkPersonInfoVC:(TRUUserModel *)model{
    NSString *activeStr = [TRUCompanyAPI getCompany].activation_mode;
    if (activeStr.length == 3) {
        if ([activeStr containsString:@","]) {
            NSArray *arr = [activeStr componentsSeparatedByString:@","];
            NSString *modestr = arr[1];
            if ([modestr isEqualToString:@"1"]) {
                if (model.email.length >0) {
                    return NO;
                }else{
                    return YES;
                }
            }else if ([modestr isEqualToString:@"2"]){
                if (model.phone.length >0) {
                    return NO;
                }else{
                    return YES;
                }
            }else if ([modestr isEqualToString:@"0"]){
                return NO;
            }else{
                return NO;
                //                if (model.employeenum.length >0) {
                //                    return NO;
                //                }else{
                //                    return YES;
                //                }
            }
        }else{
            return NO;
        }
        
    }else if (activeStr.length == 1){
        return NO;
    }else{
        return NO;
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
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 用户协议 UserAgreement
-(void)lookUserAgreement{
    TRULicenseAgreementViewController *lisenceVC = [[TRULicenseAgreementViewController alloc] init];
    [self.navigationController pushViewController:lisenceVC animated:YES];
}

@end
