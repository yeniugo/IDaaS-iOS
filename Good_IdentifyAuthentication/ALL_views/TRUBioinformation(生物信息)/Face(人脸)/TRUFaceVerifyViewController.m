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
#import "TRUMTDTool.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "RadomMutableNumber.h"
@interface TRUFaceVerifyViewController ()

@end

@implementation TRUFaceVerifyViewController

- (instancetype)init{
    self.maxDetectionTimes = 1;
    self = [super init];
    if(self){
        
    }
    return self;
}


- (NSMutableArray *)getActionSequence{
    // 1 2 4 8 16 32
    NSArray *actionArray = @[@(FaceLivenessActionTypeLiveEye),@(FaceLivenessActionTypeLiveMouth),@(FaceLivenessActionTypeLiveYawRight),@(FaceLivenessActionTypeLiveYawLeft),@(FaceLivenessActionTypeLivePitchUp)];
    NSArray *radomArray = [RadomMutableNumber randperm:5 getLength:5];
    NSMutableArray *mactionArray = [[NSMutableArray alloc] init];
//    [mactionArray addObject:@"0"];
    for (int i=0; i<1; i++) {
        [mactionArray addObject:radomArray[i]];
    }
    //YCLog(@"mactionArray = %@",mactionArray);
    //mactionArray = [[NSMutableArray alloc] initWithArray:@[@"0",@"1",@"1",@"1"]];
    return mactionArray;
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

- (void)onDetectSuccessWithImages:(UIImage *)images {
//    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    //    NSMutableArray *imageList = [[NSMutableArray alloc] init];
//    for (int i = 0; i < images.count; i++) {
//        NSString *fileName;
//        if (i == 0) {
//            fileName = [basePath stringByAppendingString:@"/image_best.jpg"];
//        } else {
//            fileName = [basePath stringByAppendingString:[NSString stringWithFormat:@"/image_action%d.jpg", i]];
//        }
//        YCLog(@"filename:%@",fileName);
//    }
    UIImage *bestimg = images;
    NSData *imgData = UIImageJPEGRepresentation(bestimg, 0.8);
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *ftoken = self.facetoken ? self.facetoken : @"dummy_token";
    __weak typeof(self) weakSelf = self;
    NSString *sign = [NSString stringWithFormat:@"%@%@",ftoken,@"1"];
    NSArray *ctxx = @[@"token",ftoken,@"confirm",@"1"];
    NSString *para = [xindunsdk requestOrverifyCIMSFaceForUser:userid faceData:imgData ctx:ctxx signdata:sign isType:NO];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:para, @"params", nil];
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
//    [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"识别的人脸和录入的人脸信息不匹配，身份验证失败！是否重试？" confrimTitle:@"重试" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
//        [weakSelf restartGroupDetection];
//    } cancelBlock:^{
//        [weakSelf dismissVC];
//    }];
    NSString *basePath1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName1 = [basePath1 stringByAppendingString:@"/verify.jpg"];
    [[NSFileManager defaultManager] createFileAtPath:fileName1 contents:imgData attributes:nil];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/face"] withParts:dic onResultWithMessage:^(int errorno, id responseBody, NSString *message){
        [weakSelf hideHudDelay:0.0];
        if (errorno == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"needRefreshPush" object:nil];
            [weakSelf showHudWithText:@"认证成功"];
            [weakSelf hideHudDelay:2.0];
            [weakSelf performSelector:@selector(dismissVC) withObject:nil afterDelay:2.0];
            [TRUMTDTool uploadDevInfo];
        }else if (-5004 == errorno){//网络错误
            [weakSelf showHudWithText:@"网络错误，请稍后重试"];
            [weakSelf hideHudDelay:2.0];
            [weakSelf performSelector:@selector(dismissVC) withObject:nil afterDelay:2.0];
        }else if (9008 == errorno){//秘钥失效
            [weakSelf deal9008Error];
        }else if (9019 == errorno){
            [weakSelf deal9019Error];
        }else if (9033 == errorno){
            [weakSelf showHudWithText:message];
            [weakSelf hideHudDelay:2.0];
        }else if (9025 == errorno){
            [weakSelf showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"您的设备已被锁定，请联系管理员！" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
                [weakSelf dismissVC];
            } cancelBlock:^{

            }];
        }else{//其他
            YCLog(@"---->%d",errorno);
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//            });
            [weakSelf showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"识别的人脸和录入的人脸信息不匹配，身份验证失败！是否重试？" confrimTitle:@"重试" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
                [weakSelf restartGroupDetection];
                YCLog(@"ok");
            } cancelBlock:^{
                [weakSelf dismissVC];
            }];
        }
    }];

}
- (void)dismissVC{
    if (!self.isTest) {
        [self post3DataNoti];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)post3DataNoti{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefresh3DataNotification object:nil];
}
@end
