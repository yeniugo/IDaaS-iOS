//
//  TRUMultipleAccountsSchemeViewController.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/3/26.
//  Copyright © 2019 zyc. All rights reserved.
//

#import "TRUBaseViewController.h"
//#import "TRUPushAuthModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TRUMultipleAccountsSchemeViewController : TRUBaseViewController
@property (nonatomic,strong) NSMutableArray *multipleAccountsArray;
//@property (nonatomic,assign,getter=isSelected) BOOL selected;
@property (copy, nonatomic) void(^backBlock)(NSString *userId);
//@property (nonatomic,strong) TRUPushAuthModel* pushModel;
@end

NS_ASSUME_NONNULL_END
