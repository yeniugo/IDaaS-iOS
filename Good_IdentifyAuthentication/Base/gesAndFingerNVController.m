//
//  gesAndFingerNVController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2018/6/11.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "gesAndFingerNVController.h"
#import "UINavigationBar+BackgroundColor.h"

#import "TRUFingerGesUtil.h"
#import "TRUEnterAPPAuthView.h"

@interface gesAndFingerNVController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>
@property (nonatomic,strong) UIColor *backgroundColor;
@end

@implementation gesAndFingerNVController


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
//        [TRUEnterAPPAuthView showAuthView];
//        [HAMLogOutputWindow printLog:@"test15"];
        [TRULockSWindow showAuthView];
    }else{
        if ([TRUFingerGesUtil getLoginAuthGesType] != TRULoginAuthGesTypeNone || [TRUFingerGesUtil getLoginAuthFingerType] != TRULoginAuthFingerTypeNone) {
//            [TRUEnterAPPAuthView showAuthView];
//            [HAMLogOutputWindow printLog:@"test16"];
            [TRULockSWindow showAuthView];
        }
    }
}

+ (void)initialize{
    UINavigationBar *bar = nil;
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
#else
    bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
#endif
    
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : RGBCOLOR(94, 95, 96), NSFontAttributeName : [UIFont systemFontOfSize:NavTitleFont]}];
//    [bar tru_setBackgroudColor:ViewDefaultBgColor];
    [bar setBackgroundColor:ViewDefaultBgColor];
    [bar setShadowImage:[UIImage new]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showFinger];
    __weak typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
    
}

- (void)setNavBarColor:(UIColor *)color{
    [self.navigationBar setBackgroundColor:color];
    [self.navigationBar setShadowImage:[UIImage new]];
    self.backgroundColor = color;
}

- (void)setTitle:(NSString *)title{
    [super setTitle:title];
//    if(@available(iOS 12.0,*)){
//        if (self.backgroundColor==nil) {
//            [self setNavBarColor:DefaultGreenColor];
//        }else{
//            [self setNavBarColor:self.backgroundColor];
//        }
//    }
    //    YCLog(@"tabbar.subviews = %@",self.navigationBar.subviews);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIBarButtonItem *)setLeftBarbuttonItem{
    UIImage *img = [[UIImage imageNamed:@"LeftBack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:img forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(navPop) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    return left;
    
}
- (void)navPop{
    if (self.backBlock) {
        self.backBlock();
    }else{
        [self popViewControllerAnimated:YES];
    }
    
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [self setLeftBarbuttonItem];
    }
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    //    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    //    {
    //        self.interactivePopGestureRecognizer.enabled = NO;
    //    }
    return [super popViewControllerAnimated:animated];
}
- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToViewController:viewController animated:animated];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ( gestureRecognizer == self.interactivePopGestureRecognizer ) {
        if (self.viewControllers.count <= 1 || self.visibleViewController == [self.viewControllers objectAtIndex:0] ) {
            //            XDLog(@"gestureRecognizerShouldBegin:No");
            return NO;
        }
    }
    //    XDLog(@"gestureRecognizerShouldBegin:YES");
    
    return YES;
}
// 允许同时响应多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:
(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
//禁止响应手势的是否ViewController中scrollView跟着滚动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldBeRequiredToFailByGestureRecognizer:
(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL flag = [gestureRecognizer isKindOfClass:
                 UIScreenEdgePanGestureRecognizer.class];
    return flag;
}

@end
