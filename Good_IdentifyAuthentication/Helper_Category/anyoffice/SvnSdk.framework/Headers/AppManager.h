//
//  AppManager.h
//  anyofficesdk
//
//  Created by ljj on 14-9-12.
//  Copyright (c) 2014年 pangqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppInfo.h"

@interface AppManager : NSObject

+(AppManager*)getInstance;

-(AppInfo *)checkUpdateWithAppid:(NSString *)appid andCurrentVersion:(NSString *)version;

-(void)updateAppWithPackageUrl:(NSString *)packageUrl andAppid:(NSString *)appid;

/*
 更新应用，type = 0:进入anyoffice应用商店升级, type = 1:自升级
 */
-(BOOL)updateAppWithPackageUrl:(NSString *)packageUrl andAppid:(NSString *)appid andPlistURL:(NSString *)plistUrl andType:(NSString *)type;

@end
