//
//  MyTabBar.h
//  lottie_jsonTest
//
//  Created by zyc on 2017/10/16.
//  Copyright © 2017年 zyc. All rights reserved.
 
#import <UIKit/UIKit.h>
@class MyTabBar;
@protocol MyTabBarDetagate <NSObject>
@optional
-(void)tabBar:(MyTabBar *)tabBar didselectedButtonFrom:(int )from to: (int )to;
-(void)scanQRButtonClick;
@end

@interface MyTabBar : UIView
@property(nonatomic,weak)id<MyTabBarDetagate>delegate;
-(void)addTabBarButtonWithItem:(UITabBarItem *)item;
@end
