//
//  YTKUrlArgumentsFilter.m
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/12/1.
//  Copyright © 2021 zyc. All rights reserved.
//

#import "YTKUrlArgumentsFilter.h"
#import "AFURLRequestSerialization.h"
#import "xindunsdk.h"
#import "TRUMFARequest.h"
#import "TRUUserApi.h"
@implementation YTKUrlArgumentsFilter{
    NSDictionary *_arguments;
}

+ (YTKUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments {
    return [[self alloc] initWithArguments:arguments];
}

- (id)initWithArguments:(NSDictionary *)arguments {
    self = [super init];
    if (self) {
        _arguments = arguments;
    }
    return self;
}

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request {
    return [self resetParameteWithFilterUrl:(NSString *)originUrl withRequest:request];
}

- (NSString *)resetParameteWithFilterUrl:(NSString *)originUrlString withRequest:(YTKBaseRequest *)request {
    if (request.requestMethod == YTKRequestMethodPOST) {
        if ([originUrlString containsString:@"mapi/01/init/checkUserInfo"] || [originUrlString containsString:@"mapi/01/init/active"] || [originUrlString containsString:@"mapi/01/init/apply4active"]) {
            if ([request isKindOfClass:[TRUMFARequest class]]) {
                TRUMFARequest *MFArequest = request;
                NSString *userno;
                NSString *signStr = @"";
                BOOL isType = NO;
                for (int i = 0; i < MFArequest.noEncryptionArray.count; i++) {
                    NSDictionary *dic = MFArequest.noEncryptionArray[i];
                    NSArray *dicArray = dic.allKeys;
                    for (int j = 0; j < dicArray.count; j++) {
                        if (i == 0) {
                            userno = dic[dicArray[j]];
                        }
                        if (i < MFArequest.noEncryptionArray.count - 1) {
                            signStr = [signStr stringByAppendingFormat:@",\"%@\":\"%@\"",dic.allKeys.firstObject,dic.allValues.firstObject];
                        }else{
                            isType = [dic.allValues.firstObject boolValue];
                        }
                    }
                }
                NSString *para = [xindunsdk encryptBySkey:userno ctx:signStr isType:isType];
                MFArequest.isEncryption = YES;
                MFArequest.encryptionStr = para;
                
            }
        }else{
            if ([request isKindOfClass:[TRUMFARequest class]]) {
                TRUMFARequest *MFArequest = request;
                NSString *userid;
                if (MFArequest.userid.length > 0) {
                    userid = MFArequest.userid;
                }else{
                    userid = [TRUUserAPI getUser].userId;
                }
                NSMutableArray *ctxx;
                NSString *sign;
                BOOL isType;
                if (MFArequest.noEncryptionArray.count == 1) {
                    ctxx = nil;
                    sign = nil;
                    NSDictionary *dic = MFArequest.noEncryptionArray.firstObject;
                    isType = [dic.allValues.firstObject boolValue];
                }else{
                    sign = @"";
                    ctxx = [NSMutableArray array];
                    for (int i = 0; i < MFArequest.noEncryptionArray.count; i++) {
                        NSDictionary *dic = MFArequest.noEncryptionArray[i];
                        NSArray *dicArray = dic.allKeys;
                        for (int j = 0; j < dicArray.count; j++) {
                            if (i < MFArequest.noEncryptionArray.count - 1) {
                                sign = [sign stringByAppendingFormat:@"%@",dic.allValues.firstObject];
                                [ctxx addObject:dic.allKeys.firstObject];
                                [ctxx addObject:dic.allValues.firstObject];
                            }else{
                                isType = [dic.allValues.firstObject boolValue];
                            }
                        }
                    }
                }
                NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:isType];
                MFArequest.isEncryption = YES;
                MFArequest.encryptionStr = paras;
            }
        }
    }
    return originUrlString;
}

@end
