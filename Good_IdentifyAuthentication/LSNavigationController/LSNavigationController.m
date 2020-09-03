
//
//  LSNavigationController.m
//  LSNavigationController
//
//  Created by liusong on 2018/3/22.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import "LSNavigationController.h"
#import <objc/runtime.h>
#import "TRUPushingViewController.h"

@interface LSNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIPanGestureRecognizer *panRecognizer;

@end


@implementation LSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.hidden=YES;
    LSTopNavigationBar *navbar=[[LSTopNavigationBar alloc]init] ;
    navbar.hidden=NO;
    [self setValue:navbar forKeyPath:@"_navigationBar"];
    self.interactivePopGestureRecognizer.delegate=self;
    
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController  setValue:self forKeyPath:@"ls_navigationController"];
    if (self.viewControllers.count>=1) {
        viewController.hidesBottomBarWhenPushed=YES;
    }
//    if ([self.viewControllers containsObject:viewController]){
//        if ([viewController isKindOfClass:[TRUPushingViewController class]]){
//            TRUPushingViewController *vc = viewController;
//            [vc refreshUI];
//        }
//        return;
//    }
//    [HAMLogOutputWindow printLog:@"push11111"];
    if ([viewController isKindOfClass:[TRUPushingViewController class]]) {
        TRUPushingViewController *vc1 = viewController;
        for (UIViewController* vc in self.viewControllers) {
            if ([vc isKindOfClass:[TRUPushingViewController class]]){
                TRUPushingViewController *vc2 = vc;
                vc2.pushModel = vc1.pushModel;
                [vc2 refreshUI];
                return;
            }
            
        }
    }
    
    [super pushViewController:viewController animated:animated];
}
-(void)setCancelGesture:(BOOL)cancelGesture
{
    _cancelGesture=cancelGesture;
    self.interactivePopGestureRecognizer.enabled=!cancelGesture;
}

@end


@implementation LSTopNavigationBar
@end

@implementation LSNavigationBar

-(void)layoutSubviews{
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        NSString *className=NSStringFromClass([view class]);
        if ([className isEqualToString:@"_UIBarBackground"]||[className isEqualToString:@"_UINavigationBarBackground"]) {
            
            CGFloat height=[UIApplication sharedApplication].statusBarFrame.size.height;
            CGRect frame=self.bounds;
            frame.size.height =self.frame.size.height+height;
            frame.origin.y=-height;
            view.frame=frame;
        }
    }
}

@end



@implementation LSNavigationItem

-(void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    //解决ios11以下系统 设置leftBarButtonItem不显示问题 通过延迟也可以解决 但是此方法不用延时也可以解决
    dispatch_async(dispatch_get_main_queue(), ^{
        [super setLeftBarButtonItem:leftBarButtonItem];
    });
//    [super setLeftBarButtonItem:leftBarButtonItem];
}


@end





