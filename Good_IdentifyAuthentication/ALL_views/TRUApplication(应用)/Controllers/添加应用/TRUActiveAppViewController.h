//
//  TRUActiveAppViewController.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/10/26.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUBaseViewController.h"
@class TRUAuthModel;
@interface TRUActiveAppViewController : TRUBaseViewController
/** 模型数据 */
@property (nonatomic, strong) TRUAuthModel *authModel;

@property (nonatomic, assign) BOOL isFromAuthView;

@end
