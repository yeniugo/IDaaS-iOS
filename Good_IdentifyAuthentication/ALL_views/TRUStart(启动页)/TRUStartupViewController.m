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
#import <SvnSdk/AnyOfficeSDK.h>
@interface TRUStartupViewController ()

@end

@implementation TRUStartupViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageview = [[UIImageView alloc] init];
    NSString *str = [TRUCompanyAPI getCompany].start_up_img_url;
    
    if (str.length>0) {
        [imageview yy_setImageWithURL:[NSURL URLWithString:str] placeholder:nil];
    }else{
        imageview.image = [UIImage imageNamed:@"applaunch"];
        
    }
    if (kDevice_Is_iPhoneX) {
        CGRect rect = [UIScreen mainScreen].bounds;
        CGFloat wid = rect.size.width;
        CGFloat hei = rect.size.height - 34;
        imageview.frame = CGRectMake(0, 0, wid, hei) ;
    }else{
        imageview.frame = [UIScreen mainScreen].bounds;
    }
    [self.view addSubview:imageview];
    [self fetchData];
}
-(void)viewDidLayoutSubviews{
    self.linelabel.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark 同步信息
- (void)fetchData {
    NSString *currentUserId = [TRUUserAPI getUser].userId;
    NSString *isss = [xindunsdk getDeviceId];
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
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            !weakSelf.completionBlock ? : weakSelf.completionBlock(nil);
        });
    }else{
        //同步一次用户信息
        __weak typeof(self) weakSelf = self;
        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        NSString *paras = [xindunsdk encryptByUkey:currentUserId ctx:nil signdata:nil isDeviceType:NO];
        NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
        [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getuserinfo"] withParts:dictt onResult:^(int errorno, id responseBody) {
            [weakSelf hideHudDelay:0.0];
            NSDictionary *dicc = nil;
            if (errorno == 0 && responseBody) {
                dicc = [xindunsdk decodeServerResponse:responseBody];
                if ([dicc[@"code"] intValue] == 0) {
                    dicc = dicc[@"resp"];
                    //用户信息同步成功
                    TRUUserModel *model = [TRUUserModel modelWithDic:dicc];
                    model.userId = currentUserId;
                    [TRUUserAPI saveUser:model];
                    //同步信息成功，信息完整，跳转页面
                    !weakSelf.completionBlock ? : weakSelf.completionBlock(model);
                }
            }else if(9008 == errorno){
                //秘钥失效
                [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
                [TRUUserAPI deleteUser];
                [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
                [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
                !weakSelf.completionBlock ? : weakSelf.completionBlock(nil);
            }else if (9019 == errorno){
                //用户被禁用 取本地
                TRUUserModel *model = [TRUUserAPI getUser];
                !weakSelf.completionBlock ? : weakSelf.completionBlock(model);
            }else{
                TRUUserModel *model = [TRUUserAPI getUser];
                !weakSelf.completionBlock ? : weakSelf.completionBlock(model);
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
