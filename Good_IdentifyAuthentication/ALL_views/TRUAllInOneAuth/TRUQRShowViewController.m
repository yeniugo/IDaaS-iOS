//
//  TRUQRShowViewController.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/8/20.
//  Copyright © 2019 zyc. All rights reserved.
//

#import "TRUQRShowViewController.h"
#import "xindunsdk.h"
#import "TRUhttpManager.h"
#import "TRUUserAPI.h"
@interface TRUQRShowViewController ()
@property (nonatomic,strong) UIImageView *qrImageView;
@property (nonatomic,strong) UILabel *countDownLB;
@property (nonatomic,strong) NSTimer *timer1;
@property (nonatomic,assign) int count;
@property (nonatomic,assign) CGFloat brightness;
@end

@implementation TRUQRShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = DefaultGreenColor;
    [self.navigationBar setBackgroundImage:[self ls_imageWithColor:DefaultGreenColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:NavTitleFont]}];
    TRUBaseNavigationController *vc = self.navigationController;
    self.leftItemBtn = [vc changeToWhiteBtn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftItemBtn];
    
    self.count = 50;
    [self setCustomUI];
    [self startTimer];
//    [self getCode];
    self.brightness = [UIScreen mainScreen].brightness;
    [[UIScreen mainScreen] setBrightness:1];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)startTimer{
    if (self.timer1 == nil) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(getCode) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        [timer fire];
        self.timer1 = timer;
    }
}


- (void)getCode{
    if (self.count == 100) {
        self.countDownLB.text = @"正在刷新";
        return;
    }
    if (self.count == 50) {
        //进行刷新
        self.countDownLB.text = @"正在刷新";
        self.count = 100;
    }
    if (self.count<30) {
        self.count = self.count - 1;
        self.countDownLB.text = [NSString stringWithFormat:@"%d秒后自动刷新",self.count];
        if (self.count == 0) {
            self.count = 100;
        }else{
            return;
        }
    }
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *paramsDic = @{@"params" : paras};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/secapi/userinfo"] withParts:paramsDic onResult:^(int errorno, id responseBody){
        if (errorno == 0) {
            if (responseBody) {
                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                int code = [dic[@"code"] intValue];
                if (code == 0) {
                    NSString *qrcode = dic[@"resp"][@"qrcode"];
                    [self getQRCodeWithCode:qrcode];
                    self.count = 29;
                    self.countDownLB.text = [NSString stringWithFormat:@"%d秒后自动刷新",self.count];
                }
            }
        }
    }];
}

- (void)refreshQRCodeWithCode:(NSString *)qrcode{
//    YCLog(@"刷新中");
    self.count = self.count - 1;
    self.countDownLB.text = [NSString stringWithFormat:@"%d秒后自动刷新",self.count];
    if (self.count == 29) {
        [self getQRCodeWithCode:qrcode];
    }else{
        if (self.count == 0) {
            self.count = 30;
        }
    }
    
}

- (void)getQRCodeWithCode:(NSString *)qrcode{
    self.qrImageView.image = [self createNonInterpolatedUIImageFormCIImage:[self creatQRcodeWithUrlstring:qrcode] withSize:self.qrImageView.size.width];
}

- (void)setCustomUI{
    self.title = @"二维码";
    UIView *backView = [[UIView alloc] init];
    [self.view addSubview:backView];
    backView.layer.cornerRadius = 10;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = [UIColor whiteColor];
    backView.frame = CGRectMake(28, kNavBarAndStatusBarHeight + 40, SCREENW - 56, 430*PointHeightRatioX3);
    
    UILabel *showLB = [[UILabel alloc] init];
    showLB.font = [UIFont systemFontOfSize:18.0];
    [backView addSubview:showLB];
    showLB.frame = CGRectMake(0, 40, SCREENW - 56, 18);
    showLB.text = @"请出示此二维码";
    showLB.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *qrImageView = [[UIImageView alloc] init];
    [backView addSubview:qrImageView];
    CGFloat qrW;
    if (430*PointHeightRatioX3*0.6>(SCREENW - 56-60)) {
        qrW = SCREENW - 56-60;
    }else{
        qrW = 430*PointHeightRatioX3*0.6;
    }
    qrImageView.frame = CGRectMake((SCREENW - 56.0 - qrW)/2.0, 430*PointHeightRatioX3*0.2, qrW, qrW);
    self.qrImageView = qrImageView;
    
    UILabel *countDownLB = [[UILabel alloc] init];
    countDownLB.textColor = RGBCOLOR(153, 153, 153);
    countDownLB.textAlignment = NSTextAlignmentCenter;
    countDownLB.font = [UIFont systemFontOfSize:14.0];
    countDownLB.frame = CGRectMake(0, 0.9*430*PointHeightRatioX3, SCREENW - 56, 14);
    [backView addSubview:countDownLB];
    self.countDownLB = countDownLB;
}
#pragma mark - 二维码生成
- (CIImage *)creatQRcodeWithUrlstring:(NSString *)urlString{
    
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
//    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    // 3.将字符串转换成NSdata
    NSData *data  = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    // 5.生成二维码
    CIImage *outputImage = [filter outputImage];
    return outputImage;
}
//生成二维码
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer1 invalidate];
    self.timer1 = nil;
    [[UIScreen mainScreen] setBrightness:self.brightness];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)setSystemBarStyle{
    if (@available(iOS 13.0, *)) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //        return UIStatusBarStyleDarkContent;
        } else {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //        return UIStatusBarStyleDefault;
        }
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
