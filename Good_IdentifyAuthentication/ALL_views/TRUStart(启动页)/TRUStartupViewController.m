//
//  TRUStartupViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/10/10.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUStartupViewController.h"
#import "TRUUserAPI.h"
#import "xindunsdk.h"
#import "TRUFingerGesUtil.h"
#import <Bugly/Bugly.h>
#import "NSString+Trim.h"
#import "TRUVersionUtil.h"
#import "TRUCompanyAPI.h"
#import <YYWebImage.h>
#import "TRUhttpManager.h"
#import "TRUEnterAPPAuthView.h"
@interface TRUStartupViewController ()

@end

@implementation TRUStartupViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 13.0, *)) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    //        return UIStatusBarStyleDarkContent;
        } else {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //        return UIStatusBarStyleDefault;
        }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultGreenColor;
    UIImageView *backimage = [[UIImageView alloc] init];
    [self.view addSubview:backimage];
    backimage.image = [UIImage imageNamed:@"applauchaaa.png"];
    backimage.frame = self.view.bounds;
    
    UIView *centerView = [[UIView alloc] init];
    [self.view addSubview:centerView];
    
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.backgroundColor = [UIColor clearColor];
    imageview.image = [UIImage imageNamed:@"welcomeicon11.png"];
    NSString *str = [TRUCompanyAPI getCompany].start_up_img_url;
    
    UILabel *showLable = [[UILabel alloc] init];
    showLable.font = [UIFont systemFontOfSize:40];
    showLable.text = @"中煤IDA";
//    showLable.textColor = [UIColor whiteColor];
    [centerView addSubview:showLable];
    [centerView addSubview:imageview];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).multipliedBy(1.6);
        make.centerX.equalTo(self.view);
    }];
    [showLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageview.mas_right).offset(10);
        make.right.equalTo(centerView);
        make.top.equalTo(centerView.mas_top).offset(10);
        make.bottom.equalTo(centerView.mas_bottom).offset(-10);
    }];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView);
        make.height.equalTo(@(50));
        make.width.equalTo(@(50));
        make.centerY.equalTo(showLable);
    }];
    [self fetchData];
}
-(void)viewDidLayoutSubviews{
//    self.linelabel.hidden = YES;
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

#pragma mark 同步信息
- (void)fetchData {
    NSString *currentUserId = [TRUUserAPI getUser].userId;
//    NSString *isss = [xindunsdk getDeviceId];
//    NSString *uuid = [xindunsdk getCIMSUUID:currentUserId];
//    YCLog(@"%s, currentUserId : %@", __func__, currentUserId);
    __weak typeof(self) weakSelf = self;
    //|| [xindunsdk isUserInitialized:currentUserId] == false
    //920358aa8ea7442c9929d325acc14ade
    
    if (!currentUserId || currentUserId.length == 0 || [xindunsdk isUserInitialized:currentUserId] == false) {//判断有没有用户
        if (currentUserId && currentUserId.length > 0) {
            NSDictionary *dic = [xindunsdk userInitializedInfo:currentUserId];
            NSInteger errcode = [dic[@"status"] integerValue];
            NSError *err = [NSError errorWithDomain:@"com.trusfort.usererror" code:errcode userInfo:dic];
            [Bugly reportError:err];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            [TRUEnterAPPAuthView dismissAuthViewAndCleanStatus];
            [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
            DDLogWarn(@"userid = %@,mfa SDK初始化 %@",currentUserId,[xindunsdk isUserInitialized:currentUserId]?@"成功":@"失败");
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            !weakSelf.completionBlock ? : weakSelf.completionBlock(nil);
        });
    }else{
        //同步一次用户信息
//        __weak typeof(self) weakSelf = self;
        TRUUserModel *model = [TRUUserAPI getUser];
        !self.completionBlock ? : self.completionBlock(model);
//        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
//        NSString *paras = [xindunsdk encryptByUkey:currentUserId ctx:nil signdata:nil isDeviceType:NO];
//        NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
//        [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getuserinfo"] withParts:dictt onResult:^(int errorno, id responseBody) {
//            [weakSelf hideHudDelay:0.0];
//            NSDictionary *dicc = nil;
//            if (errorno == 0 && responseBody) {
//                dicc = [xindunsdk decodeServerResponse:responseBody];
//                if ([dicc[@"code"] intValue] == 0) {
//                    dicc = dicc[@"resp"];
//                    //用户信息同步成功
//                    TRUUserModel *model = [TRUUserModel modelWithDic:dicc];
//                    model.userId = currentUserId;
//                    [TRUUserAPI saveUser:model];
//                    //同步信息成功，信息完整，跳转页面
//                    !weakSelf.completionBlock ? : weakSelf.completionBlock(model);
//                }
//            }else if(9008 == errorno){
//                //秘钥失效
//                [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
//                [TRUUserAPI deleteUser];
//                [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
//                [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
//                !weakSelf.completionBlock ? : weakSelf.completionBlock(nil);
//            }else if (9019 == errorno){
//                //用户被禁用 取本地
//                TRUUserModel *model = [TRUUserAPI getUser];
//                !weakSelf.completionBlock ? : weakSelf.completionBlock(model);
//            }else{
//                TRUUserModel *model = [TRUUserAPI getUser];
//                !weakSelf.completionBlock ? : weakSelf.completionBlock(model);
//            }
//        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
