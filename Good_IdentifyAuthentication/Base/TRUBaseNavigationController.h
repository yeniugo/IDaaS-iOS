//
//  TRUBaseNavigationController.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/25.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRUBaseNavigationController : UINavigationController

@property (nonatomic, copy) void (^backBlock)();

@end
