//
//  TRUUserLoginInfoModel.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/12/5.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRUUserLoginInfoModel : NSObject
@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *spid;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *department;
@property (nonatomic,copy) NSString *departmentDn;
@property (nonatomic,copy) NSString *employeenum;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,assign) NSInteger createtime;
@property (nonatomic,assign) NSInteger updatetime;
@property (nonatomic,assign) NSInteger lastModifypwdDate;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,assign) int employeeStatus;
@property (nonatomic,assign) int devCount;
@property (nonatomic,assign) int appCount;
@property (nonatomic,assign) int authAppCount;
@property (nonatomic,assign) int authState;
@property (nonatomic,assign) BOOL forbidden;
@property (nonatomic,assign) NSString *extInfo;
@property (nonatomic,assign) NSString *dn;
@property (nonatomic,assign) NSString *voiceid;
@property (nonatomic,assign) NSString *faceinfo;

+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
