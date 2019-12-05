//
//  TRUPortalModel.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/3/19.
//  Copyright © 2019 zyc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRUPortalModel : NSObject
@property (nonatomic,copy) NSString *appId;
@property (nonatomic,copy) NSString *appName;
@property (nonatomic,copy) NSString *shortName;
@property (nonatomic,copy) NSString *iconUrl;
@property (nonatomic,assign) int isSys;
@property (nonatomic,copy) NSString *androidScheme;
@property (nonatomic,copy) NSString *iosScheme;
@property (nonatomic,copy) NSString *androidDownloadUrl;
@property (nonatomic,copy) NSString *iosDownloadUrl;
+ (instancetype)modelWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
