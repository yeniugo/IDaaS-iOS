//
//  TRUFaceVerifyViewController.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/5.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUFaceVerifyViewController.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import "TRUhttpManager.h"
#import "GTMBase64.h"
//#import "TCSafe.h"
@interface TRUFaceVerifyViewController ()

@end

@implementation TRUFaceVerifyViewController
- (NSMutableArray *)getActionSequence{
    // 1 2 4 8 16 32
    NSArray *actions = @[@"1", @"4", @"8", @"16"];
    int index = arc4random() % 4;
    NSString *action = actions[index];
    return [NSMutableArray arrayWithObjects:@"0", action, nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.maxDetectionTimes = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onDetectSuccessWithImages:(NSArray *)images {
    __weak typeof(self) weakSelf = self;
    STSilentLivenessImage *stImage = images[0];
    UIImage *bestimg = stImage.image;
    NSData *imgData = UIImageJPEGRepresentation(bestimg, 0.8);
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *ftoken = self.facetoken ? self.facetoken : @"dummy_token";
    NSString *sign = [NSString stringWithFormat:@"%@%@",ftoken,@"1"];
    NSArray *ctxx = @[@"token",ftoken,@"confirm",@"1"];
    YCLog(@"pushtoken = %@",self.facetoken);
    NSString *para = [xindunsdk requestOrverifyCIMSFaceForUser:userid faceData:imgData ctx:ctxx signdata:sign isType:NO];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:para, @"params", nil];
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/face"] withParts:dic onResultWithMessage:^(int errorno1, id responseBody1, NSString *message) {
//                                [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"verifyface = %d",errorno1]];
        [weakSelf hideHudDelay:0.0];
        if (errorno1 == 0) {
            [weakSelf showHudWithText:@"认证成功"];
            [weakSelf hideHudDelay:2.0];
            [weakSelf performSelector:@selector(dismissVC) withObject:nil afterDelay:2.0];
        }else if (-5004 == errorno1){//网络错误
            [weakSelf showHudWithText:@"网络错误，请稍后重试"];
            [weakSelf hideHudDelay:2.0];
            [weakSelf performSelector:@selector(dismissVC) withObject:nil afterDelay:2.0];
        }else if (9008 == errorno1){//秘钥失效
            [weakSelf deal9008Error];
        }else if (9019 == errorno1){
            [weakSelf deal9019Error];
        }else if (9033 == errorno1){
            [weakSelf showHudWithText:message];
            [weakSelf hideHudDelay:2.0];
        }else if (9011 == errorno1){
            [weakSelf showHudWithText:@"人脸不匹配"];
            [weakSelf hideHudDelay:2.0];
        }else if (9025 == errorno1){
            [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"您的设备已被锁定，请联系管理员！" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
                [weakSelf dismissVC];
            } cancelBlock:^{
                
            }];
        }else{
            [weakSelf showHudWithText:message];
            [weakSelf hideHudDelay:2.0];
            [weakSelf performSelector:@selector(dismissVC) withObject:nil afterDelay:2.0];
        }
    }];
    
    
//    UIImage *bestimg = [images firstObject];
//    NSData *imgData = UIImageJPEGRepresentation(bestimg, 0.8);
//    NSString *userid = [TRUUserAPI getUser].userId;
//    NSString *ftoken = self.facetoken ? self.facetoken : @"dummy_token";
//    __weak typeof(self) weakSelf = self;
//    NSString *sign = [NSString stringWithFormat:@"%@%@%@",ftoken,@"1",@"2"];
//    NSArray *ctxx = @[@"token",ftoken,@"confirm",@"1",@"wsType",@"2"];
//    NSString *para = [xindunsdk requestOrverifyCIMSFaceForUser:userid faceData:imgData ctx:ctxx signdata:sign isType:NO];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:para, @"params", nil];
//    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
//
//    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/face"] withParts:dic onResultWithMessage:^(int errorno, id responseBody, NSString *message){
//        [weakSelf hideHudDelay:0.0];
//        if (errorno == 0) {
//            [weakSelf showHudWithText:@"认证成功"];
//            [weakSelf hideHudDelay:2.0];
//            [weakSelf performSelector:@selector(dismissVC) withObject:nil afterDelay:2.0];
//        }else if (-5004 == errorno){//网络错误
//            [weakSelf showHudWithText:@"网络错误，请稍后重试"];
//            [weakSelf hideHudDelay:2.0];
//            [weakSelf performSelector:@selector(dismissVC) withObject:nil afterDelay:2.0];
//        }else if (9008 == errorno){//秘钥失效
//            [weakSelf deal9008Error];
//        }else if (9019 == errorno){
//            [weakSelf deal9019Error];
//        }else if (9033 == errorno){
//            [weakSelf showHudWithText:message];
//            [weakSelf hideHudDelay:2.0];
//        }else if (9025 == errorno){
//            [weakSelf showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"您的设备已被锁定，请联系管理员！" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
//                [weakSelf dismissVC];
//            } cancelBlock:^{
//
//            }];
//        }else{//其他
//            YCLog(@"---->%d",errorno);
////            dispatch_async(dispatch_get_main_queue(), ^{
////
////            });
//            [weakSelf showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"识别的人脸和录入的人脸信息不匹配，身份验证失败！是否重试？" confrimTitle:@"重试" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
//                [weakSelf restartDetection];
//                YCLog(@"ok");
//            } cancelBlock:^{
//                [weakSelf dismissVC];
//            }];
//        }
//    }];

}
- (void)dismissVC{
    if (!self.isTest) {
        [self post3DataNoti];
    }
    [self onBackButton];
}
- (void)post3DataNoti{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefresh3DataNotification object:nil];
}
@end
