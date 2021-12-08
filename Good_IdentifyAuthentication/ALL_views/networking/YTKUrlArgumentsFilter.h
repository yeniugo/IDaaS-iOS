//
//  YTKUrlArgumentsFilter.h
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/12/1.
//  Copyright © 2021 zyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKNetworkConfig.h"
#import "YTKBaseRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface YTKUrlArgumentsFilter : NSObject <YTKUrlFilterProtocol>
+ (YTKUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments;

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request;
@end

NS_ASSUME_NONNULL_END
