//
//  AnyOfficeDetailUserInfo.h
//  anyofficesdk
//
//  Created by SDK_Fanjiepeng on 16/2/2.
//  Copyright © 2016年 fanjiepeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnyOfficeDetailUserInfo : NSObject
@property(strong, nonatomic)NSString* account;                  //账号
@property(strong, nonatomic)NSString* fullName;                 //姓名
@property(strong, nonatomic)NSString* IDNumber;                 //身份证号
@property(strong, nonatomic)NSString* position;                 //职务
@property(strong, nonatomic)NSString* mobilePhoneNumber;        //移动电话
@property(strong, nonatomic)NSString* memberOf;                 //安全组（用户类型）
@property(strong, nonatomic)NSString* userDescription;          //描述
@property(strong, nonatomic)NSString* departmentName;           //部门名称
@property(strong, nonatomic)NSString* departmentNumber;         //部门编码

//工行POC项目
@property(strong, nonatomic)NSString* ssiAuth;
@property(strong, nonatomic)NSString* ssiSign;

-(id)initWithAccount:(NSString *)userAccount
            fullName:(NSString *)userFullName
            IDNumber:(NSString *)userIDNumber
            position:(NSString *)userPosition
   mobilePhoneNumber:(NSString *)userMobilePhoneNumber
            memberOf:(NSString *)userMemberOf
     userDescription:(NSString *)userDescriptionOf
      departmentName:(NSString *)userDepartmentName
    departmentNumber:(NSString *)userdDepartmentNumber;
@end
