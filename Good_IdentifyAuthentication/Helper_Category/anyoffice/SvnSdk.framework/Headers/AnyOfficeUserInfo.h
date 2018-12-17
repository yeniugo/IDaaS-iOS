//
//  UserInfo.h
//  anyofficesdk
//
//  Created by z00103873 on 14-7-4.
//  Copyright (c) 2014年 pangqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnyOfficeDetailUserInfo.h"

@interface AnyOfficeUserInfo : NSObject

@property(strong, nonatomic)NSString* domain;
@property(strong, nonatomic)NSString* userName;
@property(strong, nonatomic)NSString* password;

@property(strong, nonatomic)AnyOfficeDetailUserInfo* detailUserInfo; //用户详细信息


-(id)initWithDomain:(NSString *)domain username:(NSString *)user password:(NSString*) pass;

@end
