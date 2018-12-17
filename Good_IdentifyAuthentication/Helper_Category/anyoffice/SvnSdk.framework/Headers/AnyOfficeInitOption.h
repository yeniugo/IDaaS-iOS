//
//  AnyOfficeInitOption.h
//  SvnSdk
//
//  Created by l00174413 on 8/1/16.
//  Copyright © 2016 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnyOfficeInitOption : NSObject


@property NSString* logPath;
@property int logLevel;
@property BOOL useL4VPN;
@property BOOL allowLogStatistic;

@property NSString* username;

@end
