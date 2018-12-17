//
//  TRUNetworkStatus.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/24.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "Reachability.h"

@interface TRUNetworkStatus : Reachability
+ (NetworkStatus)currentNetworkStatus;
@end
