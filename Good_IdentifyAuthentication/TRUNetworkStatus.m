//
//  TRUNetworkStatus.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/24.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUNetworkStatus.h"

@implementation TRUNetworkStatus
+ (NetworkStatus)currentNetworkStatus{
    Reachability *rea = [Reachability reachabilityForInternetConnection];
    return rea.currentReachabilityStatus;
}
@end
