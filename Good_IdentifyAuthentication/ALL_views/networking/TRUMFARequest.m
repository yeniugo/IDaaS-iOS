//
//  TRUMFARequest.m
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/12/2.
//  Copyright © 2021 zyc. All rights reserved.
//

#import "TRUMFARequest.h"
#import "xindunsdk.h"
#import "YYModel.h"

@implementation TRUMFARequest

- (id)initPostArray:(NSArray *)array{
    self = [super init];
    if (self) {
        _noEncryptionArray = array;
    }
    return self;
}


- (id)requestArgument {
    if (self.isEncryption) {
        return @{
            @"params": self.encryptionStr
        };
    }else{
        return self.noEncryptionArray;
    }
}


- (void)requestCompleteFilter{
    NSDictionary *dic1 = self.responseJSONObject;
    int code = [dic1[@"code"] intValue];
    if (code == 1000 || code == 0) {
        NSDictionary *dic = [xindunsdk decodeServerResponse:dic1[@"response_body"]];
        int code = [dic[@"code"] intValue];
        if (code == 0) {
            if ([dic[@"resp"] isKindOfClass:[NSDictionary class]]) {
                self.rep = [NSClassFromString(self.dicModelClassStr) yy_modelWithDictionary:dic[@"resp"]];
            }else if ([dic[@"resp"] isKindOfClass:[NSArray class]]){
                NSArray *dicArray = dic[@"resp"];
                self.rep = [NSArray yy_modelArrayWithClass:NSClassFromString(self.arrModelClassStr) json:dicArray];
            }
        }
    }else{
        self.failureCompletionBlock(self);
        [self requestFailedFilter];
        self.successCompletionBlock = nil;
    }
}

- (void)requestFailedFilter{
    if (self.responseJSONObject) {
        NSDictionary *dic = self.responseJSONObject;
        int code = [dic[@"code"] intValue];
        if (code == 1000 || code == 0) {
            
        }else{
            self.status = code;
            self.message = dic[@"msg"];
        }
    }else{
        self.status = -5004;
        self.message = @"网络错误，稍后请重试";
//        NSLog(@"222");
    }
}

- (BOOL)isActive{
    NSSet <NSString *>*noActiveSet = [NSSet setWithObjects:@"/mapi/01/init/apply4active",
                                                           @"/mapi/01/init/active",
                                                           @"/mapi/01/init/checkUserInfo",
                                      nil];
    if ([noActiveSet containsObject:self.requestUrl]) {
        //未激活
        return NO;
    }else{
        //已激活
        return YES;
    }
}

@end
