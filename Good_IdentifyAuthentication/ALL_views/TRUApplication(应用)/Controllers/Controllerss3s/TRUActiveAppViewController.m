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
    [xindunsdk checkCIMSAppUser:[TRUUserAPI shareInstanceUserID] appID:self.authModel.appid userName:userName pwd:pwd onResult:^(int error, id response) {
        if (error == 0) {
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
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else if(-5004 == error){
            [self showHudWithText:@"网络错误 请稍后重试"];
            [self hideHudDelay:2.0];
        }else if (9008 == error){
            [self deal9008Error];
        }else if (9019 == error){
            [self deal9019Error];
        }else if (9004 == error){
            [self showHudWithText:@"用户已经存在"];
            [self hideHudDelay:2.0];
        }else if (9011 == error){
            [self showHudWithText:@"用户名或密码错误"];
            [self hideHudDelay:2.0];
        }else{
            NSString *err = [NSString stringWithFormat:@"添加应用失败（%d）",error];
            [self showHudWithText:err];
            [self hideHudDelay:2.0];
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
    NSString *user = [TRUUserAPI shareInstanceUserID];
    [xindunsdk getCIMSAppInfoListForUser:user onResult:^(int error, id response) {
        [self hideHudDelay:0.0];
        if (0 == error) {
            
            if ([response isKindOfClass:[NSArray class]]) {
                NSArray *arr = (NSArray *)response;
                for (NSDictionary *dic in arr) {
                    TRUAuthModel *model = [TRUAuthModel modelWithDic:dic];
                    if ([model.appid isEqualToString:self.authModel.appid]) {
                        self.authModel = model;
                        break;
                    }
                }
                [self confitTitleContentView];
                
            }
        }else if (-5004 == error){
            [self showHudWithText:@"网络问题，请稍后重试"];
            [self hideHudDelay:2.0];
            
        }else if (9008 == error){
            [self deal9008Error];
        }else if (9019 == error){
            [self deal9019Error];
        }else{
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",error];
            [self showHudWithText:err];
            [self hideHudDelay:2.0];
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
