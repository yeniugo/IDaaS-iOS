
//
//  TRUBaseNavigationController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/25.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUBaseNavigationController.h"
#import "UINavigationBar+BackgroundColor.h"
#import "UIImage+Color.h"
@interface TRUBaseNavigationController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>
@property (nonatomic,strong) UIColor *backgroundColor;
@end

@implementation TRUBaseNavigationController

//+ (void)initialize{
//    UINavigationBar *bar = nil;
//#ifdef NSFoundationVersionNumber_iOS_9_x_Max
//    bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
//#else
//    bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
//#endif
//
//    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:NavTitleFont]}];
//    [bar tru_setBackgroudColor:DefaultGreenColor];
////    [bar setShadowImage:[UIImage new]];
//
//}

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

- (void)setNavBarColor:(UIColor *)color{
    //    [self.navigationBar tru_setBackgroudColor:color];
    ////    [self.navigationBar setShadowImage:[UIImage new]];
    //    self.backgroundColor = color;
    [self.navigationBar setBackgroundImage:[self ls_imageWithColor:color] forBarMetrics:UIBarMetricsDefault];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    if (self.childViewControllers.count>1) {
    //        for (int i = 0 ; i < self.childViewControllers.count ;i++) {
    //            [self.childViewControllers[i] reloadNavigationBar];
    //            [self setNavBarColor:DefaultGreenColor];
    //            if ( i > 0 ) {
    //                self.childViewControllers[i].navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self setLeftBarbutton]];
    //            }
    //        }
    //
    //    }
    YCLog(@"TRUBaseNavigationController viewDidLoad");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    YCLog(@"TRUBaseNavigationController viewWillAppear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)setLeftBarbutton{
//    UIImage *img = [[UIImage imageNamed:@"backbtn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img = [UIImage imageNamed:@"backbtn"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitleColor:ViewDefaultBgColor forState:UIControlStateNormal];
    [backBtn setTitle:@"" forState:UIControlStateNormal];
    //    [backBtn setBackgroundImage:img forState:UIControlStateNormal];
    [backBtn setBackgroundImage:img forState:UIControlStateNormal];
    [backBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(navPop) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 40, 50);
    //    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    //    if(@available(iOS 12.0,*)){
    //        if (self.backgroundColor==nil) {
    //            [self setNavBarColor:DefaultGreenColor];
    //        }else{
    //            [self setNavBarColor:self.backgroundColor];
    //        }
    //    }
    return backBtn;
    
}


- (void)navPop{
    //    YCLog(@"navPop");
    if (self.backBlock) {
        self.backBlock();
    }else{
        [self popViewControllerAnimated:YES];
    }
}
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if (self.childViewControllers.count > 0) {
//        viewController.hidesBottomBarWhenPushed = YES;
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self setLeftBarbutton]];
//    }
////    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)])
////    {
////        self.interactivePopGestureRecognizer.enabled = NO;
////    }
//    [super pushViewController:viewController animated:animated];
//}
//- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
//    //    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)])
//    //    {
//    //        self.interactivePopGestureRecognizer.enabled = NO;
//    //    }
//    return [super popViewControllerAnimated:animated];
//}
//- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)])
//    {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
//    return [super popToViewController:viewController animated:animated];
//}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark UINavigationControllerDelegate
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate {
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.enabled = YES;
//    }
//}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if ( gestureRecognizer == self.interactivePopGestureRecognizer ) {
//        if (self.viewControllers.count <= 1 || self.visibleViewController == [self.viewControllers objectAtIndex:0] ) {
//            //            XDLog(@"gestureRecognizerShouldBegin:No");
//            return NO;
//        }
//    }
//    //    XDLog(@"gestureRecognizerShouldBegin:YES");
//
//    return YES;
//}
// 允许同时响应多个手势
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
//shouldRecognizeSimultaneouslyWithGestureRecognizer:
//(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}
//禁止响应手势的是否ViewController中scrollView跟着滚动
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
//shouldBeRequiredToFailByGestureRecognizer:
//(UIGestureRecognizer *)otherGestureRecognizer {
//    BOOL flag = [gestureRecognizer isKindOfClass:
//                 UIScreenEdgePanGestureRecognizer.class];
//    return flag;
//}
@end
