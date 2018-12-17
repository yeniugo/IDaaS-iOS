//
//  TRUSessionManagerModel.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/9/11.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRUSessionManagerModel : NSObject
/** 时间 */
@property (nonatomic, copy) NSString *time;
/** 会话ID */
@property (nonatomic, copy) NSString *sessionid;
/** IP地址 */
@property (nonatomic, copy) NSString *ipAddr;
/** 浏览器 */
@property (nonatomic, copy) NSString *browserExplorer;
/** 所属区域 */
@property (nonatomic, copy) NSString *region;
+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
