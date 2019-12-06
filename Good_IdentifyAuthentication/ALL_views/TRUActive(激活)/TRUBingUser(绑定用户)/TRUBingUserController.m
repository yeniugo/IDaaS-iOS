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

@interface TRUBingUserController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *numView;

@property (weak, nonatomic) IBOutlet UITextField *inputoneTF;

@property (weak, nonatomic) IBOutlet UITextField *inputphonemailTF;
@property (weak, nonatomic) IBOutlet UITextField *inputpasswordTF;//验证码
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (nonatomic, weak) NSTimer *timer;

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
    _sendBtn.hidden = NO;
    _iphoneEmialView.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定";
    isEmail = isPhone = isEmployee = NO;
    _inputpasswordTF.secureTextEntry = YES;
    [_inputoneTF addTarget:self action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [_sendBtn setBackgroundColor:DefaultColor];
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.layer.cornerRadius = 5.0;
}

-(void)valueChanged:(UITextField *)field{
    NSString *str = field.text;
    
    if ([str isPhone]) {
        isPhone = YES;
        isEmployee = NO;
        isEmail = NO;

    }else if ([str isEmail]){
        isPhone = NO;
        isEmployee = NO;
        isEmail = YES;
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
}

-(void)verifyJpushId:(NSString *)type{
    NSString *activeNumber = _inputphonemailTF.text.alltrim;
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
        [self showHudWithText:@"请输入您的手机号/邮箱/工号"];
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
    [xindunsdk verifyCIMSActiveForUser:self.inputoneTF.text.trim type:type authCode:activeNumber pushID:pushID onResult:^(int error, id res) {
        
        [self hideHudDelay:0.0];
        if (0 == error) {
            [xindunsdk getCIMSUserInfoForUser:res onResult:^(int error, id response) {
                [weakSelf hideHudDelay:0];
                if (0 == error) {
                    //用户信息同步成功
                    TRUUserModel *model = [TRUUserModel modelWithDic:response];
                    model.userId = res;
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
                        if ([delegate respondsToSelector:@selector(changeRootVC)]) {
                            [delegate performSelector:@selector(changeRootVC)];
                        }
                    }
                }else if (-5004 == error){
                    [weakSelf showHudWithText:@"网络错误，请稍后重试"];
                    [weakSelf hideHudDelay:2.0];
                }else if (9019 == error){
                    [self deal9019Error];
                }else{
                    NSString *err = [NSString stringWithFormat:@"信息同步失败（%d）",error];
                    [self showHudWithText:err];
                    [self hideHudDelay:2.0];
                }
            }];
        }else if(-5004 == error){
            [self showHudWithText:@"网络错误，请稍后重试"];
            [self hideHudDelay:2.0];
        }else if(9001 == error){
            [self showHudWithText:@"激活码不正确，请确认后重新输入"];
            [self hideHudDelay:2.0];
        }else if (9019 == error){
            [self deal9019Error];
        }else{
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",error];
            [self showHudWithText:err];
            [self hideHudDelay:2.0];
        }
    }];
}



#pragma mark -获取验证码

-(void)requestCodeForUser:(NSString *)user type:(NSString *)type{
    [self showHudWithText:@"正在申请激活码..."];
    [xindunsdk requestCIMSActiveForUser:self.inputoneTF.text.trim type:type onResult:^(int error, id response) {
        [self hideHudDelay:0.0];
        if (0 == error) {
            YCLog(@"发送成功");
            //第一次申请 也就是第一次进入这个页面，开始倒计时
            [self showHudWithText:@"发送成功"];
            [self hideHudDelay:2.0];
            self.sendBtn.enabled = NO;
            [self startTimer];
            
        }else if (-5004 == error){
            [self showHudWithText:@"网络错误，请稍后重试"];
            [self hideHudDelay:2.0];
        }else if (9019 == error){
            [self deal9019Error];
        }else if (9021 == error){
            self.sendBtn.enabled = NO;
            [self startTimer];
            [self deal9021ErrorWithBlock:nil];
        }else if (9022 == error){
            [self deal9022ErrorWithBlock:nil];
        }else if (9023 == error){
            [self stopTimer];
            [self deal9023ErrorWithBlock:nil];
        }else{
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",error];
            [self showHudWithText:err];
            [self hideHudDelay:2.0];
        }
    }];
}

-(void)requestCodeForUserEmployeenum:(NSString *)user type:(NSString *)type{
    [self showHudWithText:@"正在申请激活..."];
    [xindunsdk requestCIMSActiveForUser:self.inputoneTF.text.trim type:type onResult:^(int error, id response) {
        [self hideHudDelay:0.0];
        if (0 == error) {
            YCLog(@"发送成功");
            //第一次申请 也就是第一次进入这个页面，开始倒计时
            [self verifyJpushId:@"employeenum"];
            
        }else if (-5004 == error){
            [self showHudWithText:@"网络错误，请稍后重试"];
            [self hideHudDelay:2.0];
        }else if (9019 == error){
            [self deal9019Error];
        }else if (9021 == error){
            [self deal9021ErrorWithBlock:nil];
        }else if (9022 == error){
            [self deal9022ErrorWithBlock:nil];
        }else if (9023 == error){
            [self stopTimer];
            [self deal9023ErrorWithBlock:nil];
        }else{
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",error];
            [self showHudWithText:err];
            [self hideHudDelay:2.0];
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
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
