//
//  SDKMdmCheckResultInfo.h
//  anyofficesdk
//
//  Created by kf1 on 15/11/12.
//  Copyright (c) 2015年 pangqi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CONTROL_POLICY_WARN 1
#define CONTROL_POLICY_FORBID_LOGIN 2
#define CONTROL_POLICY_FORBID_WIFI 3
#define CONTROL_POLICY_LOCK_SCREEN 7
#define CONTROL_POLICY_CLAENALLDATA 8

@interface SDKMdmCheckResultInfo : NSObject

- (void)sdkMdmCheckResultInfo:(int)rID :(int)rPolicy;

// for UI
- (int)getId;
- (int)getPolicy;
- (BOOL)getViolationPolicy:(int)flag;
- (NSString *)getDescription;
- (void)refreshDescriptionWithType:(int)detailId;

@end
