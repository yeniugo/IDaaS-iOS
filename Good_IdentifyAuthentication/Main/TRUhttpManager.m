//
//  TRUhttpManager.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2018/8/6.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUhttpManager.h"
#import "AFNetworking.h"

@implementation TRUhttpManager

/**
 * CIMS数据请求
 */
+ (void)sendCIMSRequestWithUrl:(NSString *)url withParts:(NSDictionary *)parts onResult:(void (^)(int errorno, id responseBody))onResult{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//返回格式
    // 超时时间
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    // 设置接收的Content-Type
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
    
    YCLog(@"url = %@",url);
    [manager POST:url parameters:parts progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YCLog(@" response = %@",responseObject);
        if (onResult) {
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)responseObject;
                int status = [dic[@"status"] intValue];
                int result = status == 1000 ? 0 : status;
                id response_body = nil;
                if ([dic.allKeys containsObject:@"response_body"]) {
                    response_body = dic[@"response_body"];
                    response_body = [response_body isKindOfClass:[NSNull class]] ? nil : response_body;
                }
                onResult(result, response_body);
                if (result!=0) {
                    YCLog(@"url = %@ afn result = %d",url,result);
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onResult(-5004, nil);
    }];
    
    
}

@end
