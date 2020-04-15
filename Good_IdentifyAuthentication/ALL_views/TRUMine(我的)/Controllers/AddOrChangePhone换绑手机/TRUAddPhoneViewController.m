//
//  TRUAddPhoneViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/11/28.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUAddPhoneViewController.h"
#import "TRUTimerButton.h"
#import "TRUUserAPI.h"
#import "xindunsdk.h"
#import "NSString+Trim.h"
#import "NSString+Regular.h"
#import "TRUhttpManager.h"
@interface TRUAddPhoneViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (nonatomic, weak) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;


@end

@implementation TRUAddPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机";
    [self.phoneTF becomeFirstResponder];
    _codeBtn.layer.masksToBounds = YES;
    _codeBtn.layer.cornerRadius = 5.0;
    
}
//获取验证码
- (IBAction)codeBtnClick:(UIButton *)sender {
    __weak typeof(self) weakself = self;
    [self.view endEditing:YES];
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *phone = self.phoneTF.text.trim;
    
    if (phone.length == 0) {
        [self showHudWithText:@"请输入手机号"];
        [self hideHudDelay:2.0];
        [self.phoneTF becomeFirstResponder];
        return;
    }
    if (![phone isPhone]) {
        [self showHudWithText:@"请检查手机号格式"];
        [self hideHudDelay:2.0];
        return;
    }
    self.phoneTF.enabled = NO;
    [self startTimer];
    sender.enabled = NO;
    NSString *sign = [NSString stringWithFormat:@"%@%@",phone,@"1"];
    NSArray *ctxx = @[@"phone",phone,@"authtype",@"1"];
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *para = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *paraDic = @{@"params":para};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/getauthcode"] withParts:paraDic onResult:^(int errorno, id responseBody) {
        if (errorno == 0) {
            [weakself showHudWithText:@"验证码已发送"];
            [weakself hideHudDelay:2.0];
            self.codeBtn.enabled = NO;
            [weakself.codeTF becomeFirstResponder];
        }else if (-5004 == errorno){
            [weakself showHudWithText:@"网络错误，请稍后重试"];
            [weakself hideHudDelay:2.0];
        }else if (9019 == errorno){
            [weakself deal9019Error];
        }else{
            NSString *err = [NSString stringWithFormat:@"获取验证码失败（%d）",errorno];
            [weakself showHudWithText:err];
            [weakself hideHudDelay:2.0];
        }
    }];
    
}

- (IBAction)addBtn:(UIButton *)sender {
    NSString *phone = self.phoneTF.text.trim;
    [self.view endEditing:YES];
    __weak typeof(self) weakself = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *authcode = self.codeTF.text.trim;
    if (phone.length == 0) {
        [self showHudWithText:@"请输入手机号"];
        [self hideHudDelay:2.0];
        return;
    }
    if (![phone isPhone]) {
        [self showHudWithText:@"请检查手机号格式"];
        [self hideHudDelay:2.0];
        return;
    }
    if (authcode.length == 0) {
        [self showHudWithText:@"请输入验证码"];
        [self hideHudDelay:2.0];
        return;
    }
    [self showActivityWithText:@"正在绑定.."];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@",phone,@"phone",authcode];
    NSArray *ctxx = @[@"userno",phone,@"type",@"phone",@"authcode",authcode];
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *para = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *paraDic = @{@"params":para};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/userinfosync2"] withParts:paraDic onResult:^(int errorno, id responseBody) {
        [weakself hideHudDelay:0];
        if (errorno == 0 && responseBody) {
            NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
            int code = [dic[@"code"] intValue];
            if (code == 0) {
                TRUUserModel *user = [TRUUserAPI getUser];
                user.phone = phone;
                [TRUUserAPI saveUser:user];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changephonesuccess" object:nil];
                [weakself showHudWithText:@"添加手机号成功"];
                [weakself stopTimer];
                weakself.codeBtn.enabled = YES;
                [weakself hideHudDelay:2.0];
                [weakself.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:2.1];
            }
        }else if(errorno == -5004){
            [weakself showHudWithText:@"网络错误，请稍后重试"];
            [weakself hideHudDelay:2.0];
        }else if (9004 == errorno){
            [weakself showHudWithText:@"手机号重复"];
            [weakself hideHudDelay:2.0];
            weakself.phoneTF.enabled = YES;
        }else if (9019 == errorno){
            [weakself deal9019Error];
        }else{
            NSString *err = [NSString stringWithFormat:@"同步手机号失败（%d）",errorno];
            [weakself showHudWithText:err];
            [weakself hideHudDelay:2.0];
        }
    }];
    
}

static int totalTime = 60;
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
- (void)startButtonCount{
    if (totalTime >= 1) {
        totalTime -- ;
        NSString *leftTitle  = [NSString stringWithFormat:@"已发送(%ds)",totalTime];
        [self.codeBtn setTitle:leftTitle forState:UIControlStateDisabled];
    }else{
        totalTime = 60;
        [self stopTimer];
        [self.codeBtn setTitle:@"重新发送" forState:UIControlStateDisabled];
        self.codeBtn.enabled = YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
