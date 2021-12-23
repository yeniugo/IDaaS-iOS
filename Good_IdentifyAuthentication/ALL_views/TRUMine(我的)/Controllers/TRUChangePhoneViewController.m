//
//  TRUChangePhoneViewController.m
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/12/16.
//  Copyright © 2021 zyc. All rights reserved.
//

#import "TRUChangePhoneViewController.h"
#import "ZKVerifyAlertView.h"
#import "TRUUserAPI.h"
#import "TRUhttpManager.h"
#import "xindunsdk.h"
@interface TRUChangePhoneViewController ()
@property (nonatomic,weak) UITextField *oldTF;
@property (nonatomic,weak) UITextField *firstTF;
@property (nonatomic,weak) UITextField *verifyTF;
@property (nonatomic,weak) NSTimer *timer;
@property (nonatomic,weak) UIButton *verifyBtn;
@end

@implementation TRUChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改手机号";
    UITextField *oldTF = [[UITextField alloc] init];
    oldTF.placeholder = @"请输入旧手机号";
    UIView *oldLine = [[UIView alloc] init];
    oldLine.backgroundColor = RGBCOLOR(224, 224, 224);
    UITextField *firstTF = [[UITextField alloc] init];
    firstTF.placeholder = @"请输入新手机号";
    UIView *firstLine = [[UIView alloc] init];
    firstLine.backgroundColor = RGBCOLOR(224, 224, 224);
    UITextField *verifyTF = [[UITextField alloc] init];
    verifyTF.placeholder = @"请输入验证码";
    UIButton *verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [verifyBtn addTarget:self action:@selector(verifyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    verifyBtn.backgroundColor = DefaultGreenColor;
    verifyBtn.layer.cornerRadius = 5;
    verifyBtn.layer.masksToBounds = YES;
    [verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.verifyBtn = verifyBtn;
    UIView *verifyLine = [[UIView alloc] init];
    verifyLine.backgroundColor = RGBCOLOR(224, 224, 224);
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitle:@"提交" forState:UIControlStateNormal];
    [okBtn setTitle:@"提交" forState:UIControlStateHighlighted];
    okBtn.backgroundColor = DefaultGreenColor;
    okBtn.layer.cornerRadius = 5;
    okBtn.layer.masksToBounds = YES;
    self.oldTF = oldTF;
    self.firstTF = firstTF;
    self.verifyTF = verifyTF;
    
    [self.view addSubview:oldTF];
    [self.view addSubview:oldLine];
    [self.view addSubview:firstTF];
    [self.view addSubview:firstLine];
    [self.view addSubview:verifyTF];
    [self.view addSubview:verifyBtn];
    [self.view addSubview:verifyLine];
    [self.view addSubview:okBtn];
    
    [oldTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(self.view.mas_topMargin).offset(50);
        
    }];
    [oldLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(oldTF);
        make.top.equalTo(oldTF.mas_bottom).offset(10);
        make.height.equalTo(@(1));
    }];
    [firstTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(oldTF);
        make.top.equalTo(oldLine.mas_bottom).offset(20);
    }];
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(oldLine);
        make.top.equalTo(firstTF.mas_bottom).offset(10);
        
    }];
    [verifyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oldTF);
        make.top.equalTo(firstLine.mas_bottom).offset(20);
        make.right.equalTo(verifyBtn.mas_left).offset(-10);
        make.centerY.equalTo(verifyBtn);
    }];
    [verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(150));
        make.height.equalTo(@(40));
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(firstLine.mas_bottom).offset(20);
    }];
    [verifyLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(oldLine);
        make.top.equalTo(verifyBtn.mas_bottom).offset(10);
    }];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(oldTF);
        make.height.equalTo(@(50));
        make.top.equalTo(verifyLine.mas_bottom).offset(50);
    }];
}

- (void)verifyBtnClick:(UIButton *)btn{
    __weak typeof(self) weakSelf = self;
    if (self.firstTF.text.length) {
        
    }else{
        [self showHudWithText:@"请输入新手机号"];
        [self hideHudDelay:2.0];
        return;
    }
    ZKVerifyAlertView *verifyView = [[ZKVerifyAlertView alloc] initWithMaximumVerifyNumber:100 results:^(ZKVerifyState state) {
//        [weakSelf sendMessage];
        if(state == ZKVerifyStateSuccess){
            [weakSelf sendMessage];
        }
    }];
    [verifyView show];
}

- (void)sendMessage{
    if (self.oldTF.text.length || self.firstTF.text.length || self.verifyTF.text.length) {
        
    }else{
        [self showHudWithText:@"请输入全部信息"];
        [self hideHudDelay:2.0];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *sign = [NSString stringWithFormat:@"%@",self.firstTF.text];
    NSArray *ctxx = @[@"phone",self.oldTF.text];
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/user/getAuthcodeToNewPhone"] withParts:dictt onResultWithMessage:^(int errorno, id responseBody, NSString *message) {
        if (errorno == 0) {
            [weakSelf showHudWithText:@"发送短信成功"];
            [weakSelf hideHudDelay:2.0];
            [weakSelf startBtncountdown];
        }else{
            [weakSelf showHudWithText:message];
            [weakSelf hideHudDelay:2.0];
        }
    }];
}

- (void)okBtnClick:(UIButton *)btn{
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *sign = [NSString stringWithFormat:@"%@%@%@",self.oldTF.text,self.firstTF.text,self.verifyTF.text];
    NSArray *ctxx = @[@"oldPhoneNumber",self.oldTF.text,@"newPhoneNumber",self.firstTF.text,@"authcode",self.verifyTF.text];
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/user/editPhoneNumber"] withParts:dictt onResultWithMessage:^(int errorno, id responseBody, NSString *message) {
        if (errorno == 0) {
            [weakSelf showHudWithText:@"修改密码成功"];
            [weakSelf hideHudDelay:2.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            [weakSelf showHudWithText:message];
            [weakSelf hideHudDelay:2.0];
        }
    }];
}

- (void)startBtncountdown{
    [self startTimer];
    self.verifyBtn.enabled = NO;
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
        [self.verifyBtn setTitle:leftTitle forState:UIControlStateDisabled];
    }else{
        totalTime = 60;
        [self.verifyBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        self.verifyBtn.enabled = YES;
        [self stopTimer];
    }
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
