//
//  TRUMultipleAccountsViewController.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/12/18.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRUBaseViewController.h"
#import "TRUPushAuthModel.h"
@interface TRUMultipleAccountsViewController : TRUBaseViewController
@property (nonatomic,strong) NSMutableArray *multipleAccountsArray;
@property (nonatomic,assign,getter=isSelected) BOOL selected;
@property (copy, nonatomic) void(^backBlock)(NSString *userId);
@property (nonatomic,strong) TRUPushAuthModel* pushModel;
@end
