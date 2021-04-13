//
//  TRUBaseViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/25.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUBaseViewController.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>
#import "xindunsdk.h"
#import "TRUFingerGesUtil.h"
#import <AVFoundation/AVFoundation.h>
#import "TRUAuthSacnViewController.h"
#import "TRUEnterAPPAuthView.h"
#import "FireflyAlertView.h"
#import "TRUUserAPI.h"
#import "ZipArchive.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "TRUhttpManager.h"
//#import "UIViewController+LSNavigationController.h"
@interface TRUBaseViewController ()<UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic, assign) __block BOOL showed9019Error;
/** hud */
@property (nonatomic, weak) MBProgressHUD *hud;

@property (copy, nonatomic) NSString *cancelTitleStr;

@property (copy, nonatomic) NSString *comfirmTitleStr;

@property (strong, nonatomic) void(^alertComfirm)(void);

@property (strong, nonatomic) void(^alertCancel)(void);

@property (assign, nonatomic) BOOL isRight;//alert方向,YES时，右边是确定，左边是取消，NO时，左边确定，右边取消
//@property (nonatomic, strong) 

@property (nonatomic, assign) BOOL isCurrentPage;

@property (assign,nonatomic) NSTimeInterval lastTouchTime;
@property (assign,nonatomic) int clickAllTime;

@end

@implementation TRUBaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.isCurrentPage = YES;
    DDLogWarn(@"%@ viewWillAppear",[self class]);
    [self setSystemBarStyle];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadNavigationBar];
    [self.navigationBar setBackgroundImage:[self ls_imageWithColor:DefaultNavColor] forBarMetrics:UIBarMetricsDefault];
//    UIImage *shadowImage = [[UIImage alloc] init];
    
    [self.navigationBar setShadowImage:[self ls_imageWithColor:[UIColor clearColor]]];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:NavTitleFont]}];
    if (self.navigationController.childViewControllers.count>1) {
        TRUBaseNavigationController *vc = self.navigationController;
        self.leftItemBtn = [vc setLeftBarbutton];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftItemBtn];
    }
    TRUBaseNavigationController *vc = self.navigationController;
    vc.cancelGesture = YES;
    self.view.clipsToBounds = YES;
    self.showed9019Error = NO;
//    self.isCurrentPage = YES;
    self.view.backgroundColor = RGBCOLOR(247, 249, 250);
    //黑线 (maybe change image)
    if (kDevice_Is_iPhoneX) {
        _linelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + 25, SCREENW, 1.f)];
    }else{
        _linelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, SCREENW, 1.f)];
    }
    _linelabel.backgroundColor = RGBCOLOR(180, 180, 180);
    [self.view addSubview:_linelabel];
    _linelabel.backgroundColor = [UIColor clearColor];
//    self.scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    if (kDevice_Is_iPhoneX) {
//        self.scanBtn.size = CGSizeMake(SCREENW/5.f - 10, 30);
//        self.scanBtn.centerX = self.view.centerX;
//        self.scanBtn.y = SCREENH - 50 - 30 - 35;
//    }else{
//        self.scanBtn.size = CGSizeMake(SCREENW/5.f - 10, 30);
//        self.scanBtn.centerX = self.view.centerX;
//        self.scanBtn.y = SCREENH - 50 - 30;
//    }
//    self.scanBtn.backgroundColor = [UIColor clearColor];
//    [self.scanBtn addTarget:self action:@selector(scanQRButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
//    NSInteger *ii = [UIApplication sharedApplication].applicationIconBadgeNumber;
//    
//    YCLog(@"00------->%d",ii);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mybarStyle) name:@"TRUEnterAPPAuthViewSuccess" object:nil];
}

- (void)mybarStyle{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isViewLoaded && self.view.window)
        {
            // viewController is visible
//            [self viewWillAppear:YES];
            [self setSystemBarStyle];
        }
    });
    
}

- (void)setSystemBarStyle{
    if (@available(iOS 13.0, *)) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    //        return UIStatusBarStyleDarkContent;
        } else {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //        return UIStatusBarStyleDefault;
        }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    DDLogWarn(@"%@ viewWillDisappear",[self class]);
    self.isCurrentPage = NO;
}

-(void)scanQRButtonClick{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized) {
        TRUAuthSacnViewController *vc = [[TRUAuthSacnViewController alloc] init];
        
        [self presentViewController:vc animated:YES completion:nil];
        
    }else if (authStatus == AVAuthorizationStatusNotDetermined){
        __weak typeof(self) weakSelf = self;
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (granted) {
                TRUAuthSacnViewController *vc = [[TRUAuthSacnViewController alloc] init];
                
                [strongSelf presentViewController:vc animated:YES completion:nil];
            }else{
                __weak typeof(self) weakSelf1 = strongSelf;
                [strongSelf showConfrimCancelDialogViewWithTitle:@"" msg:kCameraFailedTip confrimTitle:@"好" cancelTitle:nil confirmRight:YES confrimBolck:^{
                    __strong typeof(weakSelf) strongSelf1 = weakSelf1;
                    [strongSelf1 dismissViewControllerAnimated:YES completion:nil];
                } cancelBlock:nil];
            }
        }];
    }else if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
        __weak typeof(self) weakSelf = self;
        [self showConfrimCancelDialogViewWithTitle:@"" msg:kCameraFailedTip confrimTitle:@"好" cancelTitle:nil confirmRight:YES confrimBolck:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
        } cancelBlock:nil];
    }
    
    
}


- (void)showConfrimCancelDialogViewWithTitle:(NSString *)title msg:(NSString *)msg confrimTitle:(NSString *)confrimTitle cancelTitle:(NSString *)cancelTitle confirmRight:(BOOL)confirmRight confrimBolck:(void (^)())confrimBlock cancelBlock:(void (^)())cancelBlock{
    
//    if (cancelTitle && cancelTitle.length > 0) {
//        [FireflyAlertView showWithTitle:title message:msg cancelTitle:cancelTitle cancelBlock:^{
//            if (cancelBlock) {
//                cancelBlock();
//            }
//        } otherTitle:confrimTitle otherBlock:^{
//            if (confrimBlock) {
//                confrimBlock();
//            }
//        }];
//    }else{
//        [FireflyAlertView showWithTitle:title message:msg buttonTitle:confrimTitle];
//    }
    
    UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];


    UIAlertAction *confrimAction = [UIAlertAction actionWithTitle:confrimTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        if (confrimBlock) {
            confrimBlock();
        }
    }];
    if (cancelTitle && cancelTitle.length > 0) {
        UIAlertAction *cancelAction =  [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }

        }];
        if (confirmRight) {
            [alertVC addAction:cancelAction];
            [alertVC addAction:confrimAction];
        }else{
            [alertVC addAction:confrimAction];
            [alertVC addAction:cancelAction];
        }
    }else{
        [alertVC addAction:confrimAction];
    }

    UIViewController *controler = !self.navigationController ? self : self.navigationController;

    if (controler.presentedViewController && [controler.presentedViewController isKindOfClass:[UIAlertController class]]) {
        [controler.presentedViewController dismissViewControllerAnimated:NO completion:^{
            [controler presentViewController:alertVC animated:YES completion:nil];
        }];
    }else{
        [controler presentViewController:alertVC animated:YES completion:nil];
    }
}



- (void)showConfrimCancelDialogAlertViewWithTitle:(NSString *)title msg:(NSString *)msg confrimTitle:(NSString *)confrimTitle cancelTitle:(NSString *)cancelTitle confirmRight:(BOOL)confirmRight confrimBolck:(void (^)())confrimBlock cancelBlock:(void (^)())cancelBlock{
//    self.alertCancel = nil;
//    self.alertComfirm = nil;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.alertComfirm = confrimBlock;
        strongSelf.alertCancel = cancelBlock;
        strongSelf.isRight = confirmRight;
        strongSelf.cancelTitleStr = cancelTitle;
        strongSelf.comfirmTitleStr = confrimTitle;
        UIAlertView *alert;
        if (confirmRight) {
            alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:strongSelf cancelButtonTitle:cancelTitle otherButtonTitles:confrimTitle, nil];
        }else{
            //        alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:confrimTitle otherButtonTitles:cancelTitle, nil];
            if (cancelTitle && cancelTitle.length>0) {
                alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:strongSelf cancelButtonTitle:confrimTitle otherButtonTitles:cancelTitle, nil];
            }else{
                alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:strongSelf cancelButtonTitle:confrimTitle otherButtonTitles:nil];
            }
        }
        if (strongSelf.isCurrentPage) {
            //        UIWindow *window = self.view.window;
            //        if ([[[UIApplication sharedApplication] windows] lastObject]==window) {
            //
            //        }
            [alert show];
        }
    });
    
}

-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.isRight) {
        if (self.cancelTitleStr.length==0) {
            if (self.alertComfirm) {
                self.alertComfirm();
            }
        }else{
            switch (buttonIndex) {
                case 0:
                {
                    if (self.alertCancel) {
                        self.alertCancel();
                    }
                }
                    break;
                case 1:
                {
                    if (self.alertComfirm) {
                        self.alertComfirm();
                    }
                }
                    break;
                default:
                    break;
            }
        }
    }else{
        switch (buttonIndex) {
            case 0:
            {
                if (self.alertComfirm) {
                    self.alertComfirm();
                }
            }
                break;
            case 1:
            {
                if (self.alertCancel) {
                    self.alertCancel();
                }
            }
                break;
            default:
                break;
        }
    }
}

- (void)back2UnActiveRootVC{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    id delegate = [UIApplication sharedApplication].delegate;
    
    if ([delegate respondsToSelector:@selector(changeAvtiveRootVC)]) {
        [delegate performSelector:@selector(changeAvtiveRootVC) withObject:nil];
    }
#pragma clang diagnostic pop
}
- (void)deal9008Error{
    DDLogWarn(@"接口9008解绑");
//    [TRUhttpManager cancelALLHttp];
    
    [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"密钥失效，请重新发起初始化" confrimTitle:@"确定" cancelTitle:nil confirmRight:NO confrimBolck:^{
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        [TRUEnterAPPAuthView dismissAuthViewAndCleanStatus];
        [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
        [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
        [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
        [TRUUserAPI deleteUser];
//        [xindunsdk deactivateAllUsers];
        [self back2UnActiveRootVC];
    } cancelBlock:nil];
}
- (void)deal9019Error{
    
    [self dele9019ErrorWithBlock:nil];
}
- (void)dele9019ErrorWithBlock:(void (^)())block{
    if (!self.showed9019Error) {
        __weak typeof(self) weakSelf = self;
        [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"当前账号已锁定，请与管理员联系" confrimTitle:@"确定" cancelTitle:nil confirmRight:NO confrimBolck:^{
            weakSelf.showed9019Error = NO;
            if (block) {
                block();
            }
        } cancelBlock:nil];
        self.showed9019Error = YES;
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle{
//    if (@available(iOS 13.0, *)) {
//        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
//            return UIStatusBarStyleDarkContent;
//        }else{
//            return UIStatusBarStyleDefault;
//        }
//    } else {
//        return UIStatusBarStyleDefault;
//    }
//    return UIStatusBarStyleDefault;
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    NSTimeInterval time = [self getNowTimeTimestamp];
    if (time - self.lastTouchTime <=0.5) {
        ++self.clickAllTime;
//        NSLog(@"clicktime = %d",self.clickAllTime);
        if (self.clickAllTime==7) {
            [self sendMail];
            self.clickAllTime = -100;
        }
    }else{
        self.clickAllTime = 1;
    }
    self.lastTouchTime = time;
}
//待审批
- (void)deal9021ErrorWithBlock:(void(^)())block{
    
    [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"您的账号申请已提交，请联系管理员审批。" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
        if (block) block();
    } cancelBlock:nil];

}
//已提交
- (void)deal9022ErrorWithBlock:(void(^)())block{
    
    [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"您的账号申请已提交，管理员尚未审批通过，请勿重复提交。" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
        
        if (block) block();
        
    } cancelBlock:nil];
}
//拒绝
- (void)deal9023ErrorWithBlock:(void(^)())block{
    [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"您的账号申请被拒绝，请联系管理员。" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
        if (block) block();
    } cancelBlock:nil];
}
//设备已禁用
- (void)deal9025ErrorWithBlock:(void(^)())block{
    [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"您的账号已被禁用，请联系管理员。" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
        if (block) block();
    } cancelBlock:nil];
}

//拒绝
- (void)deal9026ErrorWithBlock:(void(^)())block{
    [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"您绑定的设备数量已达上限，想要绑定该设备，请先删除一个已激活设备。" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
        if (block) block();
    } cancelBlock:nil];
}

static const char TRUHUDKey = '\0';
- (MBProgressHUD *)hud{
    MBProgressHUD *hud = objc_getAssociatedObject(self, &TRUHUDKey);
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        objc_setAssociatedObject(self, &TRUHUDKey,
                                 hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        hud.margin = 10.0;
        hud.label.font = [UIFont boldSystemFontOfSize:14.0 * PointHeightRatio6];
        [self.view addSubview:hud];
    }
    return (MBProgressHUD*)hud;
}

- (void)showHudWithText:(NSString *)text{
//    __weak typeof(self) weakSelf = self;
//       dispatch_async(dispatch_get_main_queue(), ^{
//           weakSelf.hud.mode = MBProgressHUDModeText;
//           weakSelf.hud.label.text = text;
//           [weakSelf.hud showAnimated:YES];
//       });
    self.hud.mode = MBProgressHUDModeText;
    self.hud.label.text = text;
    [self.hud showAnimated:YES];
    //    [self.hud hideAnimated:YES afterDelay:2.0];
}
- (void)showHudWithTitle:(NSString *)titel text:(NSString *)text{
    self.hud.mode = MBProgressHUDModeText;
    self.hud.label.text = titel;
    self.hud.detailsLabel.text = text;
    [self.hud showAnimated:YES];
    //    [self.hud hideAnimated:YES afterDelay:2.0];
    
}

- (void)showActivityWithText:(NSString *)text{
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.label.text = text;
    [self.hud showAnimated:YES];
}
- (void)hideHudDelay:(NSTimeInterval)delay{
//    __weak typeof(self) weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [weakSelf.hud hideAnimated:YES afterDelay:delay];
//    });
    [self.hud hideAnimated:YES afterDelay:delay];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.view.y = 0;
    self.view.height = SCREENH;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    YCLog(@"%@ 界面消失",[self class]);
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSTimeInterval time = [self getNowTimeTimestamp];
////    NSLog(@"clicktime0 = %f",time);
//    if (time - self.lastTouchTime <=0.5) {
//        ++self.clickAllTime;
////        NSLog(@"clicktime = %d",self.clickAllTime);
//    }else{
//        self.clickAllTime = 1;
//    }
//    self.lastTouchTime = time;
//}

-(NSTimeInterval)getNowTimeTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];

    NSTimeInterval a=[dat timeIntervalSince1970];

    return a;
}

- (void)sendMail{
    if (![MFMailComposeViewController canSendMail]) {
//        [self showHudWithText:@"请设置好系统邮件账户"];
//        [self hideHudDelay:2.0];
        return;
    }
    NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    DDLogFileManagerDefault *logFileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:documentsDirectory];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager];
    //获取log文件夹路径
//    NSString *logDirectory = [fileLogger.logFileManager logsDirectory];
    //获取排序后的log名称
    NSArray <NSString *>*logsNameArray = [fileLogger.logFileManager sortedLogFileNames];
    NSString *zipPath = [self createZipArchiveWithFiles:logsNameArray];
    
    [self shareByEmailWithPath:zipPath];
}

- (void)shareByEmailWithPath:(NSString *)path{
    MFMailComposeViewController *mailSender = [[MFMailComposeViewController alloc]init];
    mailSender.mailComposeDelegate = self;
    [mailSender setToRecipients:@[@"hukai@trusfort.com"]];
    [mailSender setSubject:@"test title"];
    //以下为具体业务代码
    NSData *data = [NSData dataWithContentsOfFile:path];//文件数据
    NSString *extension;//文件类型识别字符串，如文件扩展名
    extension = [[path pathExtension] uppercaseString];
    NSString *mimeType = nil;//这个不能错，错了的话会闪退
    if ([extension isEqualToString:@"MOV"] || [extension isEqualToString:@"MP4"]) {
        mimeType = @"video/quicktime";
    }else if ([extension isEqualToString:@"MP3"] || [extension isEqualToString:@"M4A"]) {
        mimeType = @"audio/mpeg3";
    }else if ([extension isEqualToString:@"JPG"] || [extension isEqualToString:@"JPEG"]) {
        mimeType = @"image/jpeg";
    }else if ([extension isEqualToString:@"PNG"]) {
        mimeType = @"image/png";
    }else if ([extension isEqualToString:@"TXT"]) {
        mimeType = @"text/plain";
    }else if ([extension isEqualToString:@"PDF"]) {
        mimeType = @"application/pdf";
    }else if ([extension isEqualToString:@"DOC"] || [extension isEqualToString:@"DOCX"]) {
        mimeType = @"application/msword";
    }else if ([extension isEqualToString:@"XLS"] || [extension isEqualToString:@"XLSX"]) {
        mimeType = @"application/vnd.ms-exceld";
    }else if ([extension isEqualToString:@"PPT"] || [extension isEqualToString:@"PPTX"]) {
        mimeType = @"application/vnd.ms-powerpoint";
    }else if ([extension isEqualToString:@"ZIP"]) {
        mimeType = @"application/zip";
    }else{
        return ;
    }
    NSString *name = [path lastPathComponent];
    [mailSender addAttachmentData:data mimeType:mimeType fileName:name];
    [self presentViewController:mailSender animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MFMailComposeResultCancelled:
        {
        }
            break;
        case MFMailComposeResultSaved:
        {
        }
            break;
        case MFMailComposeResultSent:
        {
            YCLog(@"发送邮件成功");
        }
            break;
        case MFMailComposeResultFailed:
        {
        }
            break;
    }
}


- (NSString*) createZipArchiveWithFiles:(NSArray*)files
{
    return [self createZipArchiveWithFiles:files andPassword:nil];
}



- (NSString*) createZipArchiveWithFiles:(NSArray*)files andPassword:(NSString*)password
{
    ZipArchive* zip = [[ZipArchive alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     NSString *dateTime = [formatter stringFromDate:[NSDate date]];
//    NSLog(@"formatted time is: %@",dateTime);
    NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    DDLogFileManagerDefault *logFileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:documentsDirectory];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager];
    NSString *logDirectory = [fileLogger.logFileManager logsDirectory];
    NSString* zipPath = [NSString stringWithFormat:@"%@/%@.zip",logDirectory, dateTime];
    BOOL ok;
    if (password && password.length > 0) {
      ok = [zip CreateZipFile2:zipPath Password:password];
    } else {
      ok = [zip CreateZipFile2:zipPath];
    }
//    XCTAssertTrue(ok, @"created zip file");
    for (NSString* file in files) {
        NSString *filePatch = [documentsDirectory stringByAppendingFormat:@"/%@",file];
        ok = [zip addFileToZip:filePatch newname:[filePatch lastPathComponent]];
//        XCTAssertTrue(ok, @"added file to zip archive");
    }
    ok = [zip CloseZipFile2];
//    XCTAssertTrue(ok, @"closed zip file");
    return zipPath;
}

- (void)dealloc{
    YCLog(@"%@ dealloc 内存释放",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

