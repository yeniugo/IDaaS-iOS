//
//  TRUActiveAppViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/10/26.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUActiveAppViewController.h"
#import "TRUAuthModel.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import <YYWebImage.h>
#import "TRUPushViewController.h"
#import "TRUBaseNavigationController.h"
#import "TRUhttpManager.h"

@interface TRUActiveAppViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *appicon;
@property (weak, nonatomic) IBOutlet UILabel *appTitle;

@property (weak, nonatomic) IBOutlet UITextField *userTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation TRUActiveAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
    if (self.isFromAuthView) {
        //网络请求
        [self loadAPPInfo];
    }
}
//提交
- (IBAction)commitBtnClick:(id)sender {
    
    [self.view endEditing:YES];
    NSString *userName = _userTF.text;
    NSString *pwd = _passwordTF.text;
    if (userName.length == 0) {
        [self showHudWithText:@"用户名不能为空"];
        [self hideHudDelay:2.0];
        return;
    }
    if (pwd.length == 0) {
        [self showHudWithText:@"密码不能为空"];
        [self hideHudDelay:2.0];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *sign = [NSString stringWithFormat:@"%@%@%@",self.authModel.appid,userName,pwd];
    NSArray *ctxx = @[@"appid",self.authModel.appid,@"username",userName,@"passwd",pwd];
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/checkappuser"] withParts:dictt onResult:^(int errorno, id responseBody) {
        [weakSelf hideHudDelay:0.0];
        if (errorno == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefresh3DataNotification object:nil];
            UIViewController *rootVC = (UIViewController *)self.navigationController.childViewControllers.firstObject;
            if ([rootVC isKindOfClass:[TRUPushViewController class]] && self.isFromAuthView) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                if ([rootVC respondsToSelector:@selector(configUserName:)]) {
                    [rootVC performSelector:@selector(configUserName:) withObject:userName];
                }
#pragma clang diagnostic pop
            }
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else if(-5004 == errorno){
            [weakSelf showHudWithText:@"网络错误 请稍后重试"];
            [weakSelf hideHudDelay:2.0];
        }else if (9008 == errorno){
            [weakSelf deal9008Error];
        }else if (9019 == errorno){
            [weakSelf deal9019Error];
        }else if (9004 == errorno){
            [weakSelf showHudWithText:@"用户已经存在"];
            [weakSelf hideHudDelay:2.0];
        }else if (9011 == errorno){
            [weakSelf showHudWithText:@"用户名或密码错误"];
            [weakSelf hideHudDelay:2.0];
        }else{
            NSString *err = [NSString stringWithFormat:@"添加应用失败（%d）",errorno];
            [weakSelf showHudWithText:err];
            [weakSelf hideHudDelay:2.0];
        }
    }];

    
}
- (IBAction)eyeBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _passwordTF.secureTextEntry = NO;
    }else{
        _passwordTF.secureTextEntry = YES;
    }
    _passwordTF.font=nil;
    _passwordTF.font= [UIFont systemFontOfSize:16];
}

-(void)customUI{
    self.title = @"添加应用";
    
    if (self.isFromAuthView) {
        TRUBaseNavigationController *nav = (TRUBaseNavigationController *)self.navigationController;
        [nav setBackBlock:^{
            UIViewController *childVC = self.navigationController.childViewControllers.firstObject;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            if ([childVC respondsToSelector:@selector(dismissVC:)]) {
                [childVC performSelector:@selector(dismissVC:) withObject:@"0"];
            }
#pragma clang diagnostic pop
        }];
    }
    
    _commitBtn.backgroundColor = DefaultColor;
    
    NSString *iconurl = self.authModel.iconurl;
    [_appicon yy_setImageWithURL:[NSURL URLWithString:iconurl] placeholder:[UIImage imageNamed:@"authplaceholder"]];
    
    _appTitle.text = self.authModel.appname;
    _passwordTF.secureTextEntry = YES;
}

#pragma mark 从认证页面跳转过来需要从网络获取当前appid的整个model信息

- (void)loadAPPInfo{
    [self showHudWithText:@"正在获取应用信息..."];
    __weak typeof(self) weakSelf = self;
    NSString *user = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *para = [xindunsdk encryptByUkey:user ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *paramsDic = @{@"params" : para};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getappinfo"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        [weakSelf hideHudDelay:0.0];
        NSLog(@"-->%d-->%@",errorno,responseBody);
        id result = nil;
        if (errorno == 0) {
            NSDictionary *resultDic = [xindunsdk decodeServerResponse:responseBody];
            if ([resultDic[@"code"] intValue] == 0) {
                result = resultDic[@"resp"];
                if ([result isKindOfClass:[NSArray class]]) {
                    NSArray *arr = (NSArray *)result;
                    for (NSDictionary *dic in arr) {
                        TRUAuthModel *model = [TRUAuthModel modelWithDic:dic];
                        if ([model.appid isEqualToString:self.authModel.appid]) {
                            self.authModel = model;
                            break;
                        }
                    }
                    [weakSelf confitTitleContentView];
                }
            }
        }else if (-5004 == errorno){
            [weakSelf showHudWithText:@"网络问题，请稍后重试"];
            [weakSelf hideHudDelay:2.0];
        }else if (9008 == errorno){
            [weakSelf deal9008Error];
        }else if (9019 == errorno){
            [weakSelf deal9019Error];
        }else{
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
            [weakSelf showHudWithText:err];
            [weakSelf hideHudDelay:2.0];
        }
    }];
    
}
- (void)confitTitleContentView{
    
    NSString *iconurl = self.authModel.iconurl;
    [_appicon yy_setImageWithURL:[NSURL URLWithString:iconurl] placeholder:[UIImage imageNamed:@"authplaceholder"]];
    _appTitle.text = self.authModel.appname;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
