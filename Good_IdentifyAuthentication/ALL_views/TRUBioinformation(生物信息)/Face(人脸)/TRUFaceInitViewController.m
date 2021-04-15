//
//  TRUFaceInitViewController.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/5.
//  Copyright © 2017年 Trusfort. All rights reserved.
//
//人脸检测录入
#import "TRUFaceInitViewController.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import "RadomMutableNumber.h"
#import "TRUhttpManager.h"
#import "TRUMTDTool.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
@interface TRUFaceInitViewController ()

@end

@implementation TRUFaceInitViewController

- (instancetype)init{
    self.maxDetectionTimes = 3;
    self = [super init];
    if(self){
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置人脸信息";
//    self.maxDetectionTimes = 3;
}

- (NSMutableArray *)getActionSequence {
    NSArray *actionArray = @[@(FaceLivenessActionTypeLiveEye),@(FaceLivenessActionTypeLiveMouth),@(FaceLivenessActionTypeLiveYawRight),@(FaceLivenessActionTypeLiveYawLeft),@(FaceLivenessActionTypeLivePitchUp)];
    NSArray *radomArray = [RadomMutableNumber randperm:5 getLength:5];
    NSMutableArray *mactionArray = [[NSMutableArray alloc] init];
//    [mactionArray addObject:@"0"];
    for (int i=0; i<3; i++) {
        [mactionArray addObject:radomArray[i]];
    }
    //YCLog(@"mactionArray = %@",mactionArray);
    //mactionArray = [[NSMutableArray alloc] initWithArray:@[@"0",@"1",@"1",@"1"]];
    return mactionArray;
}

- (void)onDetectSuccessWithImages:(UIImage *)images {
//    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
////    NSMutableArray *imageList = [[NSMutableArray alloc] init];
//    for (int i = 0; i < images.count; i++) {
//        NSString *fileName;
//        if (i == 0) {
//            fileName = [basePath stringByAppendingString:@"/image_best.jpg"];
//        } else {
//            fileName = [basePath stringByAppendingString:[NSString stringWithFormat:@"/image_action%d.jpg", i]];
//        }
//        YCLog(@"filename:%@",fileName);
//    }
//    NSString *basePath1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *fileName1 = [basePath1 stringByAppendingString:@"/image_best.jpg"];
    
    UIImage *bestimg = images;
    NSData *imgData = UIImageJPEGRepresentation(bestimg, 0.8);
//    [[NSFileManager defaultManager] createFileAtPath:fileName1 contents:imgData attributes:nil];
//    NSURL *fileURL = [NSURL fileURLWithPath:fileName1];
//    [UIImageJPEGRepresentation(bestimg, 0.8) writeToURL:fileURL atomically:YES];
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *para = [xindunsdk requestOrverifyCIMSFaceForUser:userid faceData:imgData ctx:nil signdata:nil isType:YES];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:para, @"params", nil];
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/faceinfosync"] withParts:dic onResult:^(int errorno, id responseBody) {
        [weakSelf hideHudDelay:0.0];
        if (errorno == 0) {
            //            [self dismissViewControllerAnimated:YES completion:nil];
            TRUUserModel *model = [TRUUserAPI getUser];
            model.faceinfo = @"1";
            [TRUUserAPI saveUser:model];
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
        }else if (9025 == errorno){
            [weakSelf showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"您的设备已被锁定，请联系管理员！" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
                [weakSelf dismissVC];
            } cancelBlock:^{
                
            }];
        }else{//其他
            [weakSelf showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"初始化人脸失败，是否重试？" confrimTitle:@"重试" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
                [weakSelf restartGroupDetection];
            } cancelBlock:^{
                [weakSelf dismissVC];
            }];
        }
        
    }];
//    [xindunsdk requestCIMSFaceInfoSyncForUser:userid faceData:imgData onResult:^(int error) {
//        if (error == 0) {
////            [self dismissViewControllerAnimated:YES completion:nil];
//            TRUUserModel *model = [TRUUserAPI getUser];
//            model.faceinfo = @"1";
//            [TRUUserAPI saveUser:model];
//            [self performSelector:@selector(dismissVC) withObject:nil afterDelay:2.0];
//        }else if (-5004 == error){//网络错误
//            [self showHudWithText:@"网络错误，请稍后重试"];
//            [self hideHudDelay:2.0];
//            [self performSelector:@selector(dismissVC) withObject:nil afterDelay:2.0];
//        }else if (9008 == error){//秘钥失效
//            [self deal9008Error];
//        }else if (9019 == error){
//            [self deal9019Error];
//        }else if (9025 == error){
//            [self showConfrimCancelDialogViewWithTitle:@"" msg:@"您的设备已被锁定，请联系管理员！" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
//                [self dismissVC];
//            } cancelBlock:^{
//                
//            }];
//        }else{//其他
//            [self showConfrimCancelDialogViewWithTitle:@"" msg:@"初始化人脸失败，是否重试？" confrimTitle:@"重试" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
//                [self restartDetection];
//            } cancelBlock:^{
//                [self dismissVC];
//            }];
//        }
//        
//    }];
    
    
    /*
     NSString *hmac = [xindunsdk getRequestParamsSignature:[NSString stringWithFormat:@"%@%@", delta, imagenum] forUser:[TFUserProfile getCurrentUserId]];
     NSDictionary *params = @{@"uuid" : uuid,
     @"delta" : delta,
     @"hmac" : hmac,
     @"imagenum" : imagenum};
     NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
     NSMutableArray *imageList = [[NSMutableArray alloc] init];
     for (int i = 0; i < images.count; i++) {
     NSString *fileName;
     if (i == 0) {
     fileName = [basePath stringByAppendingString:@"/image_best.jpg"];
     } else {
     fileName = [basePath stringByAppendingString:[NSString stringWithFormat:@"/image_action%d.jpg", i]];
     }
     [TFDeviceUtils saveFile:fileName withData:UIImageJPEGRepresentation(images[i], 0.8)];
     [imageList addObject:fileName];
     }
     
     [SVProgressHUD show];
     
     [xindunsdk sendRequestWithUrl:URL_FACE_SET_INFO WithParameters:params WithFileName:@"faceimages" WithFilePathList:imageList OnResult:^(int errorno, id responseBody) {
     if (errorno == 0){
     [TFUserProfile updateWithCompletion:^(BOOL success){
     if (success) {
     [SVProgressHUD showInfoWithStatus:@"设置人脸成功"];
     [self.navigationController popViewControllerAnimated:YES];
     } else {
     [SVProgressHUD dismiss];
     [self onDetectFailWithMessage:@"设置人脸失败，请重试！"];
     }
     }];
     } else {
     [SVProgressHUD dismiss];
     [self onDetectFailWithMessage:@"设置人脸失败，请重试！"];
     }
     }];
     */
}
- (void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
