//
//  TRUVersionUtil.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/2/9.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRUVersionUtil : NSObject

+ (BOOL)isNewVersion;
+(BOOL )isFirstLauch;
+ (void)saveCurrentVersion;
@end
