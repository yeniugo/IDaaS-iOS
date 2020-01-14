//
//  TRUCheckBingController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2018/4/18.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUCheckBingController.h"
#import "NSString+Regular.h"
#import "NSString+Trim.h"
#import "xindunsdk.h"
#import "TRUTimerButton.h"
#import "TRUUserAPI.h"
#import "JPUSHService.h"
#import "TRUAddPersonalInfoViewController.h"
#import "TRUCompanyAPI.h"
#import "TRULicenseAgreementViewController.h"
#import "TRUGestureModify2ViewController.h"
#import "TRUhttpManager.h"
#import "gesAndFingerNVController.h"
#import "TRUEnterAPPAuthView.h"
@interface TRUCheckBingController ()

@property (weak, nonatomic) IBOutlet UIView *iphoneEmialView;
@property (weak, nonatomic) IBOutlet UIView *numView;
@property (weak, nonatomic) IBOutlet UITextField *inputoneTF;
@property (weak, nonatomic) IBOutlet UITextField *inputphonemailTF;
@property (weak, nonatomic) IBOutlet UITextField *inputpasswordTF;//验证码
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (nonatomic, weak) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *AccountbottomView;

@property (nonatomic,assign) int activeModel;
@property (nonatomic,assign) BOOL multipleVerify;

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *token;
@property (weak, nonatomic) IBOutlet UILabel *showPhoneOrEmailLB;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verifyTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailphoneTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendBtnTopConstraint;

@end

@implementation TRUCheckBingController
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
    self.title = @"登录验证";
    self.AccountbottomView.layer.cornerRadius = 5;
    self.AccountbottomView.layer.borderWidth = 1;
    self.AccountbottomView.layer.borderColor = RGBCOLOR(215, 215, 215).CGColor;
    self.numView.layer.cornerRadius = 5;
    self.numView.layer.borderWidth = 1;
    self.numView.layer.borderColor = RGBCOLOR(215, 215, 215).CGColor;
    self.iphoneEmialView.layer.cornerRadius = 5;
    self.iphoneEmialView.layer.borderWidth = 1;
    self.iphoneEmialView.layer.borderColor = RGBCOLOR(215, 215, 215).CGColor;
    TRUBaseNavigationController *nav = self.navigationController;
//    [nav setNavBarColor:DefaultGreenColor];
    isEmail = isPhone = isEmployee = NO;
    self.verifyBtn.backgroundColor = DefaultGreenColor;
    self.verifyBtn.layer.cornerRadius = 5;
    self.verifyBtn.layer.masksToBounds = YES;
    NSString *activeStr = [TRUCompanyAPI getCompany].activation_mode;
    if (activeStr.length>0) {
        NSArray *arr = [activeStr componentsSeparatedByString:@","];
        if (arr.count>0) {
            NSString *modeStr = arr[0];
            modeStr = @"5";
            if ([modeStr isEqualToString:@"1"]) {//激活方式 激活方式(1:邮箱,2:手机,3:工号)
                isEmail = YES;
                _inputoneTF.placeholder = @"请输入您的邮箱";
                _inputoneTF.text = [TRUUserAPI getUser].email;
                _numView.hidden = YES;
                _sendBtn.hidden = NO;
                _iphoneEmialView.hidden = NO;
            }else if ([modeStr isEqualToString:@"2"]){
                isPhone = YES;
                _inputoneTF.placeholder = @"请输入您的手机号";
                _inputoneTF.text = [TRUUserAPI getUser].phone;
                _numView.hidden = YES;
                _sendBtn.hidden = NO;
                _iphoneEmialView.hidden = NO;
            }else if ([modeStr isEqualToString:@"3"]){
                isEmployee = YES;
                _inputoneTF.placeholder = @"请输入您的账号";
                NSString *str = [TRUUserAPI getUser].employeenum;
                if (str.length == 0) {
                    _inputoneTF.text = [TRUUserAPI getUser].employeenum;
                }else{
                    _inputoneTF.text = str;
                }
               
                _numView.hidden = NO;
                _sendBtn.hidden = YES;
                _iphoneEmialView.hidden = YES;
            }else if ([modeStr isEqualToString:@"4"]){
                isEmployee = YES;
                _inputoneTF.placeholder = @"请输入您的账号";
                _numView.hidden = NO;
                _sendBtn.hidden = YES;
                _iphoneEmialView.hidden = YES;
                NSString *str = [TRUUserAPI getUser].employeenum;
                if (str.length == 0) {
                    _inputoneTF.text = [TRUUserAPI getUser].employeenum;
                }else{
                    _inputoneTF.text = str;
                }
                self.activeModel = 4;
                self.emailphoneTopConstraint.constant = 140;
                self.sendBtnTopConstraint.constant = 140;
                self.verifyTopConstraint.constant = - 55;
            }else if ([modeStr isEqualToString:@"5"]){
                NSString *str = [TRUUserAPI getUser].employeenum;
                if (str.length == 0) {
                    _inputoneTF.text = [TRUUserAPI getUser].employeenum;
                }else{
                    _inputoneTF.text = str;
                }
                _inputoneTF.text = @"1234";
                _inputpasswordTF.text = @"qwer1234";
                isEmployee = YES;
                _inputoneTF.placeholder = @"请输入您的账号";
                _numView.hidden = NO;
                _sendBtn.hidden = YES;
                _iphoneEmialView.hidden = YES;
                self.emailphoneTopConstraint.constant = 140;
                self.sendBtnTopConstraint.constant = 140;
                self.verifyTopConstraint.constant = - 55;
                self.activeModel = 5;
            }
            _inputoneTF.enabled = NO;
        }
        
    }else{
        [_inputoneTF addTarget:self action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    }
    _inputpasswordTF.secureTextEntry = YES;
    [_sendBtn setBackgroundColor:DefaultGreenColor];
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.layer.cornerRadius = 5.0;
    
    
    //用户协议
//    UILabel * txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENW/2.f - 115, SCREENH - 40, 160, 20)];
//    [self.view addSubview:txtLabel];
//    txtLabel.text = @"使用此App,即表示同意该";
//    txtLabel.font = [UIFont systemFontOfSize:14];
//    UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:agreementBtn];
//    agreementBtn.frame = CGRectMake(SCREENW/2.f +35, SCREENH - 40, 90, 20);
//    [agreementBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
//    [agreementBtn setTitleColor:DefaultGreenColor forState:UIControlStateNormal];
//    agreementBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [agreementBtn addTarget:self action:@selector(lookUserAgreement) forControlEvents:UIControlEventTouchUpInside];
//    
//    if (kDevice_Is_iPhoneX) {
//        txtLabel.frame =CGRectMake(SCREENW/2.f - 122, SCREENH - 80, 165, 20);
//        agreementBtn.frame = CGRectMake(SCREENW/2.f +35, SCREENH - 80, 90, 20);
//    }
    TRUEnterAPPAuthView.lockid=2;
}

- (void)resetUI{
    
}

-(void)valueChanged:(UITextField *)field{
    NSString *str = field.text;
    
    if ([str isPhone]) {
        isPhone = YES;
        isEmployee = NO;
        isEmail = NO;
        [self hiddenWithfalsh:1];
        //        [self stopTimer];
        //        [self.sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        //        self.sendBtn.enabled = YES;
    }else if ([str isEmail]){
        isPhone = NO;
        isEmployee = NO;
        isEmail = YES;
        [self hiddenWithfalsh:1];
        //        [self stopTimer];
        //        [self.sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        //        self.sendBtn.enabled = YES;
    }else{
        isPhone = NO;
        isEmployee = YES;
        isEmail = NO;
        [self hiddenWithfalsh:2];
    }
}

- (IBAction)eyeBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _inputpasswordTF.secureTextEntry = sender.selected;
}

#pragma mark -验证
- (IBAction)VerifyBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (_inputpasswordTF.text.length == 0 && isEmployee) {
        [self showHudWithText:@"请输入密码"];
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
    __weak typeof(self) weakSelf = self;
    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pushID = [stdDefaults objectForKey:@"TRUPUSHID"];
    if(pushID.length==0){
        pushID = @"1234567890";
    }
    NSString *singStr = [NSString stringWithFormat:@",\"userno\":\"%s\",\"pushid\":\"%@\",\"type\":\"%@\",\"authcode\":\"%@\"", [self.inputoneTF.text.trim UTF8String],pushID, @"employeenum",self.inputpasswordTF.text];
    NSString *para = [xindunsdk encryptBySkey:self.inputoneTF.text.trim ctx:singStr isType:YES];
    NSDictionary *paramsDic = @{@"params" : para};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/checkUserInfo"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        if (errorno==0) {
            if (responseBody!=nil) {
                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                YCLog(@"dic = %@",dic);
                weakSelf.verifyTopConstraint.constant = 20;
                weakSelf.iphoneEmialView.hidden = NO;
                weakSelf.sendBtn.hidden = NO;
                weakSelf.showPhoneOrEmailLB.hidden = NO;
                weakSelf.multipleVerify = YES;
                [weakSelf.inputpasswordTF endEditing:YES];
                [weakSelf.inputoneTF endEditing:YES];
                weakSelf.inputpasswordTF.userInteractionEnabled = NO;
                weakSelf.inputoneTF.userInteractionEnabled = NO;
                weakSelf.inputphonemailTF.hidden = NO;
//                weakSelf.phoneCodelineView.hidden = NO;
                [weakSelf.inputphonemailTF becomeFirstResponder];
                weakSelf.inputoneTF.textColor = RGBCOLOR(153, 153, 153);
                weakSelf.inputpasswordTF.textColor = RGBCOLOR(153, 153, 153);
                dic = dic[@"resp"];
                weakSelf.phone = dic[@"phone"];
                weakSelf.token = dic[@"token"];
                weakSelf.email = dic[@"email"];
                if (weakSelf.activeModel==5) {
                    if (weakSelf.email.length==0) {
                        weakSelf.showPhoneOrEmailLB.text = [NSString stringWithFormat:@"邮箱： "];
                    }else if (weakSelf.phone.length==11){
                        weakSelf.showPhoneOrEmailLB.text = [NSString stringWithFormat:@"邮箱：%@",[weakSelf getEmailFromStr:weakSelf.email]];
                    }
                    
                }else if (weakSelf.activeModel==4){
                    if (weakSelf.phone.length==0) {
                        weakSelf.showPhoneOrEmailLB.text = [NSString stringWithFormat:@"手机号： "];
                    }else if (weakSelf.phone.length==11){
                        weakSelf.showPhoneOrEmailLB.text = [NSString stringWithFormat:@"手机号： *** **** *%@",[weakSelf.phone substringFromIndex:8]];
                    }
                }
                [self sendCodeBtnClcik:nil];
//                [weakSelf.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
            }
        }else if(errorno==-5004){
            [self showHudWithText:@"网络错误"];
            [self hideHudDelay:2.0];
        }else if (9019 == errorno){
            [weakSelf deal9019Error];
        }else if (9021 == errorno){
//            weakSelf.sendBtn.enabled = YES;
            //            [weakSelf startTimer];
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
            [self showHudWithText:@"用户名密码错误"];
            [self hideHudDelay:2.0];
        }
    }];
}

- (NSString *)getEmailFromStr:(NSString *)str{
//    str = @"afasfdaf@fafa@abc.com";
    NSMutableArray *array = [self getRangeStr:str findText:@"@"];
    NSString *firstStr;
    NSString *lastStr;
    NSString *resultStr;
    if (array.count>0) {
        if ([array lastObject]>3) {
            firstStr = [str substringToIndex:3];
            lastStr = [str substringFromIndex:[[array lastObject] intValue]];
            resultStr = [NSString stringWithFormat:@"%@****%@",firstStr,lastStr];
        }else{
            resultStr = str;
        }
    }
    return resultStr;
}

- (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText
{
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:20];
    if (findText == nil && [findText isEqualToString:@""]) {
        return nil;
    }
    NSRange rang = [text rangeOfString:findText]; //获取第一次出现的range
    if (rang.location != NSNotFound && rang.length != 0) {
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        NSRange rang1 = {0,0};
        NSInteger location = 0;
        NSInteger length = 0;
        for (int i = 0;; i++)
        {
            if (0 == i) {//去掉这个xxx
                location = rang.location + rang.length;
                length = text.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            }else
            {
                location = rang1.location + rang1.length;
                length = text.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            //在一个range范围内查找另一个字符串的range
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            if (rang1.location == NSNotFound && rang1.length == 0) {
                break;
            }else//添加符合条件的location进数组
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
        }
        return arrayRanges;
    }
    return nil;
}

-(void)verifyJpushId:(NSString *)type{
    NSString *activeNumber = _inputphonemailTF.text.alltrim;
    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pushID = [stdDefaults objectForKey:@"TRUPUSHID"];
    [self showHudWithText:@"正在激活..."];
    
    if (!pushID || pushID.length == 0) {//说明pushid获取失败
#if TARGET_IPHONE_SIMULATOR
        pushID = @"";
        if ([type isEqualToString:@"employeenum"]) {
            [self active4User:self.inputpasswordTF.text.trim pushID:@"1234567890" type:type];
        }else{
            [self active4User:activeNumber pushID:@"1234567890" type:type];
        }
        NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
        [stdDefaults setObject:@"1234567890" forKey:@"TRUPUSHID"];
        [stdDefaults synchronize];
#else
        //没有获取到也可以激活成功
        if ([type isEqualToString:@"employeenum"]) {
            [self active4User:self.inputpasswordTF.text.trim pushID:@"1234567890" type:type];
        }else{
            [self active4User:activeNumber pushID:@"1234567890" type:type];
        }
        NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
        [stdDefaults setObject:@"1234567890" forKey:@"TRUPUSHID"];
        [stdDefaults synchronize];
//        [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
//            if(resCode == 0){
//                YCLog(@"registrationID获取成功：%@",registrationID);
//                NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
//                [stdDefaults setObject:registrationID forKey:@"TRUPUSHID"];
//                [stdDefaults synchronize];
//                if ([type isEqualToString:@"employeenum"]) {
//                    [self active4User:self.inputpasswordTF.text.trim pushID:pushID type:type];
//                }else{
//                    [self active4User:activeNumber pushID:pushID type:type];
//                }
//            }
//            else{
//                YCLog(@"registrationID获取失败，code：%d",resCode);
//                [self showHudWithText:@"激活失败，请重试"];
//                [self hideHudDelay:2.0];
//
//
//            }
//        }];
#endif
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
        [self requestCodeForUser:self.phone type:@"phone"];
        return;
    }
    if (self.activeModel==5) {
        [self requestCodeForUser:self.email type:@"email"];
        return;
    }
    if (_inputoneTF.text.length == 0 && isEmail) {
        [self showHudWithText:@"请输入您的邮箱"];
        [self hideHudDelay:1.5f];
        return;
    }
    if (_inputoneTF.text.length == 0 && isPhone) {
        [self showHudWithText:@"请输入您的手机号"];
        [self hideHudDelay:1.5f];
        return;
    }
    if ([_inputoneTF.text isPhone] && isEmail) {
        [self showHudWithText:@"请输入正确格式的邮箱账号"];
        [self hideHudDelay:1.5f];
        return;
    }
    if ([_inputoneTF.text isEmail] && isPhone) {
        [self showHudWithText:@"请输入正确格式的手机号"];
        [self hideHudDelay:1.5f];
        return;
    }
    NSString *str = _inputoneTF.text;
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
    }
}
- (void)active4User:(NSString *)activeNumber pushID:(NSString *)pushID type:(NSString *)type{
    __weak typeof(self) weakSelf = self;
    
    NSString *singStr = [NSString stringWithFormat:@",\"userno\":\"%s\",\"pushid\":\"%s\",\"type\":\"%s\",\"authcode\":\"%s\"", [self.inputoneTF.text.trim UTF8String],[pushID UTF8String], [type UTF8String],[activeNumber UTF8String]];
    NSString *para = [xindunsdk encryptBySkey:self.inputoneTF.text.trim ctx:singStr isType:YES];
    if (self.activeModel == 4) {
        singStr = [NSString stringWithFormat:@",\"userno\":\"%s\",\"pushid\":\"%s\",\"type\":\"%s\",\"authcode\":\"%s\",\"token\":\"%s\"", [self.phone UTF8String],[pushID UTF8String], [type UTF8String],[activeNumber UTF8String],[self.token UTF8String]];
        para = [xindunsdk encryptBySkey:self.phone ctx:singStr isType:YES];
    }else if (self.activeModel ==5){
        singStr = [NSString stringWithFormat:@",\"userno\":\"%s\",\"pushid\":\"%s\",\"type\":\"%s\",\"authcode\":\"%s\",\"token\":\"%s\"", [self.email UTF8String],[pushID UTF8String], [type UTF8String],[activeNumber UTF8String],[self.token UTF8String]];
        para = [xindunsdk encryptBySkey:self.email ctx:singStr isType:YES];
    }
    NSDictionary *paramsDic = @{@"params" : para};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/active"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        [weakSelf hideHudDelay:0.0];
        NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
        if (errorno == 0) {
            NSString *userId = nil;
            int err = [xindunsdk privateVerifyCIMSInitForUserNo:self.inputoneTF.text.trim response:dic[@"resp"] userId:&userId];
            //            NSLog(@"---11111111111--->%d---->%@",err,userId);
            if (err == 0) {
                //同步用户信息
                TRUGestureModify2ViewController *modifyViewController = [[TRUGestureModify2ViewController alloc] init];
                modifyViewController.ISrebinding = YES;
                [weakSelf.navigationController pushViewController:modifyViewController animated:NO];
            }
        }else if(-5004 == errorno){
            [weakSelf showHudWithText:@"网络错误，请稍后重试"];
            [weakSelf hideHudDelay:2.0];
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
            [weakSelf deal9019Error];
        }else{
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
            [weakSelf showHudWithText:err];
            [weakSelf hideHudDelay:2.0];
        }
    }];

}



#pragma mark -获取验证码

-(void)requestCodeForUser:(NSString *)user type:(NSString *)type{
    [self showHudWithText:@"正在申请激活码..."];
    __weak typeof(self) weakSelf = self;
    NSString *signStr = [NSString stringWithFormat:@",\"userno\":\"%s\",\"type\":\"%s\"}", [self.inputoneTF.text.trim UTF8String], [type UTF8String]];
    NSString *para = [xindunsdk encryptBySkey:self.inputoneTF.text.trim ctx:signStr isType:NO];
    if (self.activeModel == 4) {
        signStr = [NSString stringWithFormat:@",\"userno\":\"%@\",\"type\":\"%s\",\"token\":\"%s\"}", self.phone, [type UTF8String],[self.token UTF8String]];
        para = [xindunsdk encryptBySkey:self.inputoneTF.text.trim ctx:signStr isType:NO];
    }else if (self.activeModel ==5){
        signStr = [NSString stringWithFormat:@",\"userno\":\"%@\",\"type\":\"%s\",\"token\":\"%s\"}", self.email, [type UTF8String],[self.token UTF8String]];
        para = [xindunsdk encryptBySkey:self.email ctx:signStr isType:NO];
    }
    NSDictionary *paramsDic = @{@"params" : para};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/apply4active"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        [weakSelf hideHudDelay:0.0];
        if (0 == errorno) {
            YCLog(@"发送成功");
            //第一次申请 也就是第一次进入这个页面，开始倒计时
            [weakSelf showHudWithText:@"发送成功"];
            [weakSelf hideHudDelay:2.0];
            weakSelf.sendBtn.enabled = NO;
            [weakSelf startTimer];
            
        }else if (-5004 == errorno){
            [weakSelf showHudWithText:@"网络错误，请稍后重试"];
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
        }else if (9001 == errorno){
            if ([type isEqualToString:@"email"]) {
                [weakSelf showHudWithText:@"请输入正确的账号/验证码信息"];
                [weakSelf hideHudDelay:2.0];
            }else if([type isEqualToString:@"phone"]){
                [weakSelf showHudWithText:@"请输入正确的账号/验证码信息"];
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
        }else{
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
            [weakSelf showHudWithText:err];
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
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/apply4active"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        [weakSelf hideHudDelay:0.0];
        if (0 == errorno) {
            YCLog(@"发送成功");
            //第一次申请 也就是第一次进入这个页面，开始倒计时
            [weakSelf verifyJpushId:@"employeenum"];
            
        }else if (-5004 == errorno){
            [weakSelf showHudWithText:@"网络错误，请稍后重试"];
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
        }else if (9001 == errorno){
            [weakSelf showHudWithText:@"请输入正确的账号/密码"];
            [weakSelf hideHudDelay:2.0];
        }else if (9002 == errorno){
            [weakSelf showHudWithText:@"请输入正确的账号信息"];
            [weakSelf hideHudDelay:2.0];
        }else{
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
            [weakSelf showHudWithText:err];
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
