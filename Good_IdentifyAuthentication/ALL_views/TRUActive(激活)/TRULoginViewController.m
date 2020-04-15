//
//  TRULoginViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/10/11.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRULoginViewController.h"
#import <Lottie/Lottie.h>
#import <AVFoundation/AVFoundation.h>
#import "TRULicenseAgreementViewController.h"
#import "TRUBingUserController.h"
//#import "TRULoginScanViewController.h"
#import "TRUBaseNavigationController.h"
//#import "TRUBaseNavigationController.h"
#import "TRURegisterController.h"

@interface TRULoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *bingEmailBtn;

@property (weak, nonatomic) IBOutlet UIButton *AgreementBtn;

@property (weak, nonatomic) IBOutlet UIView *ScanView;

@property (strong, nonnull) LOTAnimationView *scanJsonView;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *welcomTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBackHeightConstraint;

@end

@implementation TRULoginViewController
{
    UILabel *label;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    label.hidden = YES;
//    [_scanJsonView stop];
//    [_scanJsonView playWithCompletion:^(BOOL animationFinished) {
//        if (animationFinished) {
//            label.hidden = NO;
//        }
//    }];
    //YCLog("kServerUrl = %@",kServerUrl);
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
-(void)customUI{
    
    [_AgreementBtn setTitle:@"《试用协议》" forState:UIControlStateNormal];
    [_AgreementBtn setTitleColor:DefaultColor forState:UIControlStateNormal];
    _AgreementBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bingEmailBtn setBackgroundColor:DefaultColor];
    [_registerBtn setBackgroundColor:DefaultColor];
    
//
    if (IS_IPHONE_4_OR_LESS) {
        self.imageWidthConstraint.constant = 200;
        self.imageHeightConstraint.constant = 240;
        self.welcomTopConstraint.constant = 150;
    }else if(IS_IPHONE_5){
        self.imageWidthConstraint.constant = 250;
        self.imageHeightConstraint.constant = 300;
        self.welcomTopConstraint.constant = 150;
    }else {
        self.imageWidthConstraint.constant = 350*PointHeightRatio6;
        self.imageHeightConstraint.constant = 420*PointHeightRatio6;
        self.welcomTopConstraint.constant = 250 *PointHeightRatio6;
        self.imageTopConstraint.constant = -90*PointHeightRatio6;
//        self.imageTopConstraint.constant = 100 * PointHeightRatio6;
        if (kDevice_Is_iPhoneX) {
            self.imageWidthConstraint.constant = 300*PointHeightRatio6;
            self.imageHeightConstraint.constant = 360*PointHeightRatio6;
            self.imageTopConstraint.constant = -40*PointHeightRatio6 - 60;
            self.welcomTopConstraint.constant = 160 *PointHeightRatio6 + 70;
        }
    }
    self.loginBackHeightConstraint.constant = SCREENW*1262.0/1125.0;
}
//绑定用户
- (IBAction)bingEmailBtnClick:(UIButton *)sender {
//    TRUBingUserController *bingUserVC = [[TRUBingUserController alloc] init];
//    [self.navigationController pushViewController:bingUserVC animated:YES];
    TRURegisterController *registerVC = [[TRURegisterController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)registerBtnClick:(id)sender {
//    TRURegisterController *registerVC = [[TRURegisterController alloc] init];
//    [self.navigationController pushViewController:registerVC animated:YES];
    TRUBingUserController *bingUserVC = [[TRUBingUserController alloc] init];
    [self.navigationController pushViewController:bingUserVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
