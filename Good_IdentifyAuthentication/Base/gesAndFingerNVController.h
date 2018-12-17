//
//  gesAndFingerNVController.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2018/6/11.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gesAndFingerNVController : UINavigationController

@property (nonatomic, copy) void (^backBlock)();
- (void)setNavBarColor:(UIColor *)color;
@end
