//
//  TRUFaceGuideViewController.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/5.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUFaceGuideViewController.h"
#import "TRUFaceInitViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TRUFaceGuideViewController ()
@property (nonatomic, weak) UIImageView *guideImgview1;
@property (nonatomic, weak) UIImageView *guideImgview2;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIButton *startVerifyBtn;

@end

@implementation TRUFaceGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(commonInit) userInfo:nil repeats:NO];
    [self commonInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)commonInit{
    
    self.title = @"操作指南";
//    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    [self.view addSubview:self.scrollView = scrollView];
    

    
    UIImageView *guide1 = [self create1ImageViewWithImage:@"Image.bundle/discern1.png"];
    UIImageView *guide2 = [self create1ImageViewWithImage:@"Image.bundle/discern2.png"];
    [scrollView addSubview:self.guideImgview1 = guide1];
    [scrollView addSubview:self.guideImgview2 = guide2];
    
  
    UIButton *startVerifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //bottom_btn_bg
    [startVerifyBtn setBackgroundImage:[UIImage imageNamed:@"Image.bundle/bottom_btn_bg.png"] forState:UIControlStateNormal];
    [startVerifyBtn setTitle:@"开始认证" forState:UIControlStateNormal];
    [startVerifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startVerifyBtn addTarget:self action:@selector(startInitFace) forControlEvents:UIControlEventTouchUpInside];
    [guide2 addSubview:self.startVerifyBtn = startVerifyBtn];
//
    scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 2, 0);


}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGRect viewRect = self.view.bounds;
    if (kDevice_Is_iPhoneX) {
        self.scrollView.frame = CGRectMake(0, 85, viewRect.size.width, SCREENH - 85);
        self.guideImgview1.frame = CGRectMake(0, 0, viewRect.size.width, viewRect.size.height - 64);
        self.guideImgview2.frame = CGRectMake(viewRect.size.width, 0, viewRect.size.width, viewRect.size.height - 64);
        CGFloat btnH = 44.0;
        CGFloat btnX = 20.0;
        CGFloat btnY = viewRect.size.height - btnH - 20.0 - 84.0;
        CGFloat btnW = viewRect.size.width - 2 * btnX;
        self.startVerifyBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }else{
        self.scrollView.frame = CGRectMake(0, 64, viewRect.size.width, SCREENH - 64);
        self.guideImgview1.frame = CGRectMake(0, 0, viewRect.size.width, viewRect.size.height - 64);
        self.guideImgview2.frame = CGRectMake(viewRect.size.width, 0, viewRect.size.width, viewRect.size.height - 64);
        CGFloat btnH = 44.0;
        CGFloat btnX = 20.0;
        CGFloat btnY = viewRect.size.height - btnH - 20.0 - 64.0;
        CGFloat btnW = viewRect.size.width - 2 * btnX;
        self.startVerifyBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    
}


#pragma mark 创建ImageView
- (UIImageView *)create1ImageViewWithImage:(NSString *)image{
    UIImageView *imgv = [[UIImageView alloc] init];
    imgv.userInteractionEnabled = YES;
    imgv.contentMode = UIViewContentModeScaleToFill;
    imgv.image = [UIImage imageNamed:image];
    return imgv;
}
#pragma mark 按钮事件
- (void)startInitFace{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized) {
        TRUFaceInitViewController *faceInitVC = [[TRUFaceInitViewController alloc] init];
        [self.navigationController presentViewController:faceInitVC animated:YES completion:^{
            [self.navigationController popViewControllerAnimated:NO];
        }];
    }else if (authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                TRUFaceInitViewController *faceInitVC = [[TRUFaceInitViewController alloc] init];
                //            [self.navigationController pushViewController:faceInitVC animated:YES];
                [self.navigationController presentViewController:faceInitVC animated:YES completion:^{
                    [self.navigationController popViewControllerAnimated:NO];
                }];
            }else{
                [self showConfrimCancelDialogViewWithTitle:@"" msg:kCameraFailedTip confrimTitle:@"好" cancelTitle:nil confirmRight:YES confrimBolck:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                } cancelBlock:nil];
            }
        }];
    }else if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
        [self showConfrimCancelDialogViewWithTitle:@"" msg:kCameraFailedTip confrimTitle:@"好" cancelTitle:nil confirmRight:YES confrimBolck:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        } cancelBlock:nil];
    }
}
@end
