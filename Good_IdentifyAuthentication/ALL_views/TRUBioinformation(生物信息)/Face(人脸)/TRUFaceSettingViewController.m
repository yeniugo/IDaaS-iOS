//
//  TRUFaceSettingViewController.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/11.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUFaceSettingViewController.h"
#import "TRUFaceVoiceSettingButton.h"
#import "TRUFaceInitViewController.h"
#import "TRUFaceVerifyViewController.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import "TRUhttpManager.h"
@interface TRUFaceSettingViewController ()

@end

@implementation TRUFaceSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"人脸信息";
    [self setUpSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpSubviews{
    
    //img
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"faceinfobg"]];
    [self.view addSubview:imgView];
    
    CGFloat fonsize = 16.f * PointHeightRatio6;
    
    UIImage *img = [UIImage imageNamed:@"identify_jiantou"];
    TRUFaceVoiceSettingButton *resetBtn = [TRUFaceVoiceSettingButton buttonWithType:UIButtonTypeCustom];
//    [resetBtn setImage:img forState:UIControlStateNormal];
    resetBtn.isDeleteBtn = YES;
    [resetBtn setTitle:@"删除人脸信息" forState:UIControlStateNormal];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:fonsize];
    [resetBtn addTarget:self action:@selector(resetFace) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetBtn];
    
    TRUFaceVoiceSettingButton *authBtn = [TRUFaceVoiceSettingButton buttonWithType:UIButtonTypeCustom];
    [authBtn setImage:img forState:UIControlStateNormal];
    [authBtn setTitle:@"尝试验证" forState:UIControlStateNormal];
    authBtn.titleLabel.font = [UIFont systemFontOfSize:fonsize];
    [authBtn addTarget:self action:@selector(isTimeOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:authBtn];
    
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@100);
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
    }];
    [authBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(imgView.mas_bottom).offset(20.0);
        make.height.equalTo(@(50.0 * PointHeightRatio6));
    }];
    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(authBtn);
        make.top.equalTo(authBtn.mas_bottom).offset(1.0);
    }];
}
- (void)resetFace{
    [self showConfrimCancelDialogViewWithTitle:@"" msg:@"您确认删除人脸信息吗？" confrimTitle:@"确认" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
        [self showHudWithText:@"正在删除人脸信息..."];
        NSString *userid = [TRUUserAPI getUser].userId;
        __weak typeof(self) weakSelf = self;
        
        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        //同步用户信息
        NSString *sign = @"1";
        NSArray *ctxx = @[@"optype",@"1"];
        NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
        NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
        [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/deluserinfo"] withParts:dictt onResult:^(int errorno, id responseBody) {
            [weakSelf hideHudDelay:0.0];
            NSString *tip = nil;
            if (errorno == 0) {
                tip = @"删除人脸信息成功";
                TRUUserModel *model = [TRUUserAPI getUser];
                model.faceinfo = @"";
                [TRUUserAPI saveUser:model];
            }else if (9019 == errorno){
                [weakSelf deal9019Error];
            }else{
                tip = [NSString stringWithFormat:@"删除人脸信息失败（%d）,请稍后重试",errorno];//@"删除人脸信息失败，请稍后重试";
            }
            [weakSelf showHudWithText:tip];
            [weakSelf hideHudDelay:2.0];
            [weakSelf.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:2.0];
        }];

    } cancelBlock:^{
        
    }];
    
}
- (void)verifyFace{
    TRUFaceVerifyViewController *verifyfaceVC = [[TRUFaceVerifyViewController alloc] init];
    verifyfaceVC.isTest = YES;
    [self presentViewController:verifyfaceVC animated:YES completion:nil];
}

-(void)isTimeOut{
    
    NSString *currentTimeStr = [self getCurrentTimes];
    //    NSLog(@"----->%@",currentTimeStr);
    int dd = [self compareDate:currentTimeStr withDate:@"2019-03-30"];
    //    NSLog(@"----->%d",dd);
    if (dd >= 0) {
        [self verifyFace];
    }else{
        [self alertWithStr:@"您所使用的人脸认证服务已到期，即将更新，请耐心等待。"];
    }
}


-(NSString*)getCurrentTimes{
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:currentDate];
    return currentDateStr;
}

//比较两个日期大小
-(int)compareDate:(NSString*)startDate withDate:(NSString*)endDate{
    
    int comparisonResult;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] init];
    date1 = [formatter dateFromString:startDate];
    date2 = [formatter dateFromString:endDate];
    NSComparisonResult result = [date1 compare:date2];
    //    NSLog(@"result==%ld",(long)result);
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            comparisonResult = 1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            comparisonResult = -1;
            break;
            //date02=date01
        case NSOrderedSame:
            comparisonResult = 0;
            break;
        default:
            //NSLog(@"erorr dates %@, %@", date1, date2);
            break;
    }
    return comparisonResult;
}
-(void)alertWithStr:(NSString *)alertstr{
    UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"" message:alertstr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confrimAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:confrimAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
@end
