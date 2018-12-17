//
//  TRUTimeSyncUtil.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2016/12/28.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRUTimeSyncUtil : NSObject
+ (void)syncTimeWithResult:(void(^)(int error)) syncFinshBlock;

+ (CGFloat)getTimePercent;
+ (void)saveTimePercent:(CGFloat)timePercent;


+ (void)saveCurrentTime;
+ (CGFloat)getTimeSpan;
@end
