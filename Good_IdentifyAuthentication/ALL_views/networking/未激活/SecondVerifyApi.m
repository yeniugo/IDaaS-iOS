//
//  SecondVerifyApi.m
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/12/2.
//  Copyright © 2021 zyc. All rights reserved.
//

#import "SecondVerifyApi.h"

@implementation SecondVerifyApi
- (NSString *)requestUrl {
    return @"mapi/01/init/checkUserInfo";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)dicModelClassStr{
    return @"";
}


@end
