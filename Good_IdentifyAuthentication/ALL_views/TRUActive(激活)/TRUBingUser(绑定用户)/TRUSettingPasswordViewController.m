//
//  TRUSettingPasswordViewController.m
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/12/15.
//  Copyright © 2021 zyc. All rights reserved.
//

#import "TRUSettingPasswordViewController.h"
#import "TRUhttpManager.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import "TRUMTDTool.h"
#import "AppDelegate.h"
#import "NSString+Regular.h"
@interface TRUSettingPasswordViewController ()
@property (nonatomic,weak) UITextField *firstPasswordTF;
@property (nonatomic,weak) UITextField *secondPasswordTF;
@end

@implementation TRUSettingPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置密码";
    UILabel *showLB = [[UILabel alloc] init];
    showLB.text = @"为了保障您的账户安全请设置密码";
    showLB.font = [UIFont boldSystemFontOfSize:14.0];
    UITextField *firstPasswordTF = [[UITextField alloc] init];
    firstPasswordTF.secureTextEntry = YES;
    firstPasswordTF.placeholder = @"请输入密码";
    UIButton *firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [firstBtn addTarget:self action:@selector(firstBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *firstLine = [[UIView alloc] init];
    firstLine.backgroundColor = RGBCOLOR(224, 224, 224);
    UITextField *secondPasswordTF = [[UITextField alloc] init];
    secondPasswordTF.secureTextEntry = YES;
    secondPasswordTF.placeholder = @"请再次确认密码";
    UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [secondBtn addTarget:self action:@selector(secondBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *secondLine = [[UIView alloc] init];
    secondLine.backgroundColor = RGBCOLOR(224, 224, 224);
    
    [firstBtn setImage:[UIImage imageNamed:@"addappeyeclose"] forState:UIControlStateNormal];
    [firstBtn setImage:[UIImage imageNamed:@"addappeye"] forState:UIControlStateSelected];
    [secondBtn setImage:[UIImage imageNamed:@"addappeyeclose"] forState:UIControlStateNormal];
    [secondBtn setImage:[UIImage imageNamed:@"addappeye"] forState:UIControlStateSelected];
    UILabel *messageLB = [[UILabel alloc] init];
    messageLB.text = @"密码由8-16位数字、字母或符号组成，至少包含两种字符。";
    messageLB.numberOfLines = 0;
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"提交" forState:UIControlStateNormal];
    okBtn.backgroundColor = DefaultGreenColor;
    [okBtn.layer setMasksToBounds:YES];
    [okBtn.layer setCornerRadius:5.0];
    [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.firstPasswordTF = firstPasswordTF;
    self.secondPasswordTF = secondPasswordTF;
    [self.view addSubview:showLB];
    [self.view addSubview:firstPasswordTF];
    [self.view addSubview:firstBtn];
    [self.view addSubview:firstLine];
    [self.view addSubview:secondPasswordTF];
    [self.view addSubview:secondBtn];
    [self.view addSubview:secondLine];
    [self.view addSubview:messageLB];
    [self.view addSubview:okBtn];
    
    [showLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.top.equalTo(self.view.mas_topMargin).offset(20);
    }];
    [firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(21));
        make.height.equalTo(@(15));
        make.right.equalTo(self.view).offset(-44);
        make.centerY.equalTo(firstPasswordTF);
        make.left.equalTo(firstPasswordTF.mas_right).offset(10);
    }];
    [firstPasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.top.equalTo(showLB.mas_bottom).offset(20);
    }];
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(firstPasswordTF);
        make.right.equalTo(firstBtn);
        make.top.equalTo(firstPasswordTF.mas_bottom).offset(5);
        make.height.equalTo(@(1));
    }];
    [secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.right.left.equalTo(firstBtn);
        make.top.equalTo(firstBtn.mas_bottom).offset(40);
    }];
    [secondPasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(firstPasswordTF);
        make.centerY.equalTo(secondBtn);
    }];
    [secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(firstLine);
        make.top.equalTo(secondPasswordTF.mas_bottom).offset(5);
    }];
    [messageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(firstLine);
        make.top.equalTo(secondLine.mas_bottom).offset(10);
    }];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(firstLine);
        make.top.equalTo(messageLB.mas_bottom).offset(50);
        make.height.equalTo(@(50));
    }];
}

- (void)firstBtnClick:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    self.firstPasswordTF.secureTextEntry = !btn.isSelected;
}

- (void)secondBtnClick:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    self.secondPasswordTF.secureTextEntry = !btn.isSelected;
}

- (void)okBtnClick:(UIButton *)btn{
    if (self.firstPasswordTF.text.length && self.secondPasswordTF.text.length) {
        if ([self.firstPasswordTF.text isEqual:self.secondPasswordTF.text]) {
            //提交
            if ([self.firstPasswordTF.text isPassword]) {
                [self verifyPassword];
            }else{
                [self showHudWithText:@"密码不符合要求"];
                [self hideHudDelay:2.0];
            }
            
        }else{
            [self showHudWithText:@"密码不一致"];
            [self hideHudDelay:2.0];
        }
    }else{
        [self showHudWithText:@"请输入密码"];
        [self hideHudDelay:2.0];
    }
}

- (void)verifyPassword{
    __weak typeof(self) weakSelf = self;
    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pushID = [stdDefaults objectForKey:@"TRUPUSHID"];
    if(pushID.length==0){
        pushID = @"1234567890";
    }
    NSString *signStr = [NSString stringWithFormat:@",\"userNo\":\"%@\",\"pushid\":\"%@\",\"authType\":\"%@\",\"password\":\"%@\",\"idCard\":\"%@\"", self.verifyDic[@"userno"],pushID, self.verifyDic[@"type"],self.firstPasswordTF.text,self.verifyDic[@"idcard"]];
//    NSString *signStr = [NSString stringWithFormat:@",\"userno\":\"%@\",\"authType\":\"%@\",\"password\":\"%@\",\"pushid\":\"%@\",\"idCard\":\"%@\"}", self.verifyDic[@"userno"], self.verifyDic[@"type"],self.firstPasswordTF.text,pushID,self.verifyDic[@"idcard"]];
    NSString *para = [xindunsdk encryptBySkey:self.verifyDic[@"userno"] ctx:signStr isType:YES];
//    NSString *signStr = [NSString stringWithFormat:@",\"userno\":\"%@\",\"pushid\":\"%s\",\"type\":\"%s\",\"authcode\":\"%s\"", self.verifyDic[@"userno"],[pushID UTF8String], [@"phone" UTF8String],[self.verifyDic[@"verifycode"] UTF8String]];
//    NSString *para = [xindunsdk encryptBySkey:self.verifyDic[@"userno"] ctx:signStr isType:YES];
    NSDictionary *paramsDic = @{@"params" : para};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [self showHudWithText:nil];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/user/register"] withParts:paramsDic onResultWithMessage:^(int errorno, id responseBody, NSString *message) {
        if (errorno == 0) {
            NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
            NSString *userId = nil;
            NSString *userno = weakSelf.verifyDic[@"userno"];
            int err = [xindunsdk privateVerifyCIMSInitForUserNo:userno response:dic[@"resp"] userId:&userId];
            [weakSelf hideHudDelay:0.0];
            if (err == 0) {
                [weakSelf syncUserInfoWithUserid:userId];
            }else{
                
            }
        }else{
            [weakSelf showHudWithText:message];
            [weakSelf hideHudDelay:2.0];
        }
    }];
}

- (void)syncUserInfoWithUserid:(NSString *)userid{
    __weak typeof(self) weakSelf = self;
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
//                NSString *baseUrl1 = @"http://192.168.1.150:8004";
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [self showHudWithText:nil];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getuserinfo"] withParts:dictt onResult:^(int errorno, id responseBody) {
        [weakSelf hideHudDelay:0.0];
        NSDictionary *dicc = nil;
        if (errorno == 0 && responseBody) {
            dicc = [xindunsdk decodeServerResponse:responseBody];
            if ([dicc[@"code"] intValue] == 0) {
//                            [TRUMTDTool uploadDevInfo];
                dicc = dicc[@"resp"];
//                            NSString *oldStr = dicc[@"accounts"];
//                            NSString *replaceOld = @"\"";
//                            NSString *replaceNew = @"\"";
//                            NSString *strUrl = [oldStr stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
//                            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dicc];
//                            dicc[@"accounts"] = strUrl;
                //用户信息同步成功
                TRUUserModel *model = [TRUUserModel yy_modelWithDictionary:dicc];
                NSString *json = [weakSelf toReadableJSONStringWithDic:dicc];
                model.userId = userid;
                [TRUUserAPI saveUser:model];
                [TRUMTDTool uploadDevInfo];
                AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
                appdelegate.isNeedPush = YES;
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"applogintime"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (0) {//yes 表示需要完善信息
                    
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
