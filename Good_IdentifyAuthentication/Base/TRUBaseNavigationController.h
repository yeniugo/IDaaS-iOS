//
//  TRUBaseNavigationController.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/25.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSNavigationController.h"
@interface TRUBaseNavigationController : LSNavigationController
//@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic, copy) void (^backBlock)();
- (void)setNavBarColor:(UIColor *)color;
- (UIButton *)setLeftBarbutton;
- (UIButton *)changeToWhiteBtn;
@end
