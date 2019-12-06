//
//  TRUModifyInfoViewController.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2016/12/26.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import "TRUBaseViewController.h"

typedef NS_ENUM(NSInteger, TRUModifyType) {
    TRUModifyTypeName,
    TRUModifyTypeDepart,
    TRUModifyTypeEmpNum,
    TRUModifyTypePhone
};


@interface TRUModifyInfoViewController : TRUBaseViewController
/** 是否是修改电话 */
@property (nonatomic, assign) BOOL isModifyPhone;
/** 修改类型 */
@property (nonatomic, assign) TRUModifyType type;
@property (nonatomic, copy) NSString *contentText;
@end
