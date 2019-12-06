//
//  TRUSSHViewModel.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/6/14.
//  Copyright © 2019 zyc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRUSSHViewModel : NSObject
@property (nonatomic,copy) NSString *keyid;
@property (nonatomic,copy) NSString *appId;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,assign) int appType;
@end

NS_ASSUME_NONNULL_END
