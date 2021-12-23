//
//  TRUStartupViewController.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/10/10.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUBaseViewController.h"

@class TRUUserModel;

@interface TRUStartupViewController : UIViewController

@property (nonatomic, copy) void (^completionBlock)(TRUUserModel *userModel);

@end
