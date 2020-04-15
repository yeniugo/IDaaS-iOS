//
//  TRUBaseTabBarController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/26.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUBaseTabBarController.h"

#import "TRUMineViewController.h"
#import "TRUDynamicPasswordViewController.h"
#import "TRUBaseNavigationController.h"

#import "TRUEnterAPPAuthView.h"
#import "TRUUserAPI.h"
#import "MyTabBar.h"
#import <AVFoundation/AVFoundation.h>
#import "TRUFingerGesUtil.h"

#import "TRUGestureVerifyViewController.h"
#import "TRUVerifyFingerprintViewController.h"


@interface TRUBaseTabBarController ()<MyTabBarDetagate>
@property(nonatomic,weak)MyTabBar *customTabBar;
@property (nonatomic, strong) TRUBaseNavigationController *gesFingerNavVC;

@end

@implementation TRUBaseTabBarController
- (TRUBaseNavigationController *)gesFingerNavVC{
    UIViewController *rootVC;
    if ([TRUFingerGesUtil getLoginAuthType] == TRULoginAuthTypeGesture) {
        TRUGestureVerifyViewController *vc = [[TRUGestureVerifyViewController alloc] init];
        vc.isDoingAuth = YES;
        rootVC = vc;
    }else if ([TRUFingerGesUtil getLoginAuthType] == TRULoginAuthTypeFinger){
        TRUVerifyFingerprintViewController *vc = [[TRUVerifyFingerprintViewController alloc] init];
        vc.isDoingAuth = YES;
        rootVC = vc;
    }
    _gesFingerNavVC = [[TRUBaseNavigationController alloc] initWithRootViewController:rootVC];
    return _gesFingerNavVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTabbar];
    [self setUPChildrenVC];
    
}

- (void)showFinger{
    
    if ([TRUFingerGesUtil getLoginAuthType] != TRULoginAuthTypeNone) {
        if ([TRUFingerGesUtil getLoginAuthType] == TRULoginAuthTypeFinger) {
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeFinger];
        }else if ([TRUFingerGesUtil getLoginAuthType] == TRULoginAuthTypeFace){
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeFace];
        }else if ([TRUFingerGesUtil getLoginAuthType] == TRULoginAuthTypeGesture){
            [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeture];
        }
        [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
        [TRUEnterAPPAuthView showAuthView];
    }else{
        if ([TRUFingerGesUtil getLoginAuthGesType] != TRULoginAuthGesTypeNone || [TRUFingerGesUtil getLoginAuthFingerType] != TRULoginAuthFingerTypeNone) {
            [TRUEnterAPPAuthView showAuthView];
        }
    }
}
///移除自带的tabBar
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.isAddUserInfo) {
        [self showFinger];
    }
    for(UIView *child in self.tabBar.subviews){
        if([child isKindOfClass:[UIControl class]]){
            [child removeFromSuperview];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setUpTabbar{
    
    MyTabBar *customTabBar=[[MyTabBar alloc]init];
    customTabBar.frame=self.tabBar.bounds;
    self.customTabBar=customTabBar;
    customTabBar.delegate=self;
    [self.tabBar addSubview:customTabBar];
    
}

//防止tabBar出现重影
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    for(UIView *child in self.tabBar.subviews){
        if([child isKindOfClass:[UIControl class]]){
            [child removeFromSuperview];
        }
    }
}
//监听按的改变
-(void)tabBar:(MyTabBar *)tabBar didselectedButtonFrom:(int)from to:(int)to{
    self.selectedIndex=to;
    
}
- (void)setUPChildrenVC{
    
    [self set1ChildVCWithVC:[TRUDynamicPasswordViewController class] title:@"动态口令" image:@"dymaicicon"];
    [self set1ChildVCWithVC:[TRUMineViewController class] title:@"我的" image:@"mineicon"];
    
}
- (void)set1ChildVCWithVC:(Class)vcClass title:(NSString *)title image:(NSString *)image{
    
    UIViewController *VC = [[vcClass alloc] init];
    TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:VC];
    VC.title = title;
    
    VC.tabBarItem.selectedImage = [self orignImage:[NSString stringWithFormat:@"%@_selected",image]];
    VC.tabBarItem.image = [self orignImage:[NSString stringWithFormat:@"%@_normal",image]];
    
    [self addChildViewController:nav];
    [self.customTabBar addTabBarButtonWithItem:VC.tabBarItem];
}
- (UIImage *)orignImage:(NSString *)imageName{
    UIImage *img = [UIImage imageNamed:imageName];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
}

#pragma mark TRUTabBarScanButtonDelegate
//扫一扫
-(void)scanQRButtonClick{

    
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
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)showAuthVCWithToken:(NSString *)stoken{
    
}


@end
