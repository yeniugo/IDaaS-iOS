//
//  SDKEventHandler.h
//  SDKtest
//
//  Created by yzy on 15-3-10.
//  Copyright (c) 2015年 mail_user. All rights reserved.
//

void sdkEventNotifyTunnelStatus(int status);
#import <UIKit/UIKit.h>
#define SDKEVENT_TUNNEL_ONLINE @"SDKEVENT_TUNNEL_ONLINE"
@interface SDKEventHandler : NSObject
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;

+ (void)eventTunnelStatusChanged:(int)status;
@end
