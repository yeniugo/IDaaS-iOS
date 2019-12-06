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
#import "TRULoginScanViewController.h"
#import "TRUBaseNavigationController.h"
#import "TRUBaseNavigationController.h"

@interface TRULoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *bingEmailBtn;

@property (weak, nonatomic) IBOutlet UIButton *AgreementBtn;

@property (weak, nonatomic) IBOutlet UIView *ScanView;

@property (strong, nonnull) LOTAnimationView *scanJsonView;


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
    [_scanJsonView stop];
    [_scanJsonView playWithCompletion:^(BOOL animationFinished) {
        if (animationFinished) {
            label.hidden = NO;
        }
    }];
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
    
    _scanJsonView = [LOTAnimationView animationNamed:@"Scandata.json"];
    _scanJsonView.frame = CGRectMake(0, 0, 230, 230);
    [_ScanView addSubview:_scanJsonView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanViewTap)];
    [_scanJsonView addGestureRecognizer:tap];
    _scanJsonView.userInteractionEnabled = YES;
    
//    label = [[UILabel alloc] init];
//    label.text = @"用户绑定";
//    label.font = [UIFont systemFontOfSize:14];
//    label.textColor = [UIColor darkGrayColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.frame = CGRectMake(70, 170, 80, 20);
//    [_ScanView addSubview:label];
//    [_ScanView bringSubviewToFront:label];
//    label.hidden = YES;
//    [_scanJsonView playWithCompletion:^(BOOL animationFinished) {
//        if (animationFinished) {
//            label.hidden = NO;
//        }
//    }];
}
//绑定用户
-(void)scanViewTap{
    TRUBingUserController *bingUserVC = [[TRUBingUserController alloc] init];
    [self.navigationController pushViewController:bingUserVC animated:YES];
}
#pragma mark - 扫码
- (IBAction)bingEmailBtnClick:(UIButton *)sender {
    TRUBingUserController *bingUserVC = [[TRUBingUserController alloc] init];
    [self.navigationController pushViewController:bingUserVC animated:YES];
}


- (IBAction)AgreementBtnClick:(id)sender {
    TRULicenseAgreementViewController *lisenceVC = [[TRULicenseAgreementViewController alloc] init];
    [self.navigationController pushViewController:lisenceVC animated:YES];
}





- (void)showConfrimCancelDialogViewWithTitle:(NSString *)title msg:(NSString *)msg confrimTitle:(NSString *)confrimTitle cancelTitle:(NSString *)cancelTitle confirmRight:(BOOL)confirmRight confrimBolck:(void (^)())confrimBlock cancelBlock:(void (^)())cancelBlock{
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
