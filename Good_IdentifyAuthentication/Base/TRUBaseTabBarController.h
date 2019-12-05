//
//  TRUBaseTabBarController.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/26.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRUBaseTabBarController : UITabBarController

@property (nonatomic, assign) BOOL isAddUserInfo;

- (void)showAuthVCWithToken:(NSString *)stoken;

@end
