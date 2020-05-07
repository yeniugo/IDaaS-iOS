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
//@property (nonatomic,copy) NSString *schema;
@property (nonatomic,copy) NSString *h5Url;
@property (nonatomic,copy) NSString *androidSchema;
@property (nonatomic,copy) NSString *iosSchema;
@property (nonatomic,copy) NSString *androidDownloadUrl;
@property (nonatomic,copy) NSString *iosDownloadUrl;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,assign) int cellType;
+ (instancetype)modelWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
