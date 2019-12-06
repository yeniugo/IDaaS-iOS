//
//  TRUTokenUtil.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/16.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRUTokenUtil : NSObject
+(void)saveLocalToken:(NSString *)tokenStr;
+(NSString *)getLocalToken;
+(void)cleanLocalToken;
//+(BOOL)isNeedPush;
//+(void)setNeedPush:(BOOL)need;
@end
