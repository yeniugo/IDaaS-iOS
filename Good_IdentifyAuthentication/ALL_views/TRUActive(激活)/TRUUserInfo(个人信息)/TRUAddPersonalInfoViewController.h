//
//  TRUAddPersonalInfoViewController.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/11/22.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUBaseViewController.h"

@interface TRUAddPersonalInfoViewController : TRUBaseViewController
/** 用户NO */
@property (nonatomic, copy) NSString *userNo;
/** 电话号码 */
@property (nonatomic, copy) NSString *phone;
/** 用户email */
@property (nonatomic, copy) NSString *email;
/** 用户员工号*/
@property (nonatomic, copy) NSString *employeenum;

@property (nonatomic, strong) NSDictionary *modelDic;

@property (nonatomic, assign) BOOL isStart;

@property (nonatomic, assign) BOOL isScan;

@property (copy, nonatomic) void(^backBlocked)();

@end
