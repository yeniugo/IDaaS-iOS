//
//  TRUMFARequest.h
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/12/2.
//  Copyright © 2021 zyc. All rights reserved.
//

#import "YTKRequest.h"
//#import <Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface TRUMFARequest : YTKRequest
@property (nonatomic,copy) NSString *message;
@property (nonatomic,assign) int status;
@property (nonatomic, strong) id rep;
@property (nonatomic, strong) NSArray *noEncryptionArray;
@property (nonatomic,assign) BOOL isEncryption;
@property (nonatomic,copy) NSString *encryptionStr;
@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *dicModelClassStr;
@property (nonatomic,copy) NSString *arrModelClassStr;
- (id)initPostArray:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
