//
//  TRUBaseNavigationController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/25.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUBaseNavigationController.h"
#import "UINavigationBar+BackgroundColor.h"

@interface TRUBaseNavigationController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation TRUBaseNavigationController

+ (void)initialize{
    UINavigationBar *bar = nil;
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
#else
    bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
#endif
    
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : RGBCOLOR(94, 95, 96), NSFontAttributeName : [UIFont systemFontOfSize:NavTitleFont]}];
    [bar tru_setBackgroudColor:ViewDefaultBgColor];
    [bar setShadowImage:[UIImage new]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIBarButtonItem *)setLeftBarbuttonItem{
    UIImage *img = [[UIImage imageNamed:@"backbtn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
//        UINavigationBar *bar = nil;
//#ifdef NSFoundationVersionNumber_iOS_9_x_Max
//        bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
//#else
//        bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
//#endif
//        [self.navigationBar tru_setBackgroudColor:[UIColor whiteColor]];
//        [self.navigationBar setShadowImage:[UIImage new]];
        //        viewController.navigationItem.backBarButtonItem = [self setLeftBarbuttonItem];
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
