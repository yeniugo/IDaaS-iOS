//
//  TRUhttpManager.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2018/8/6.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUhttpManager.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "TRUNetworkStatus.h"
#import <arpa/inet.h>
#import <netdb.h>
@implementation TRUhttpManager

/**
 * CIMS数据请求
 */
+ (void)sendCIMSRequestWithUrl:(NSString *)url withParts:(NSDictionary *)parts onResult:(void (^)(int errorno, id responseBody))onResult{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSString *host = [NSURL URLWithString:url].host;
    [self resolveHost:host onResult:^(BOOL canhost, BOOL isIpV6) {
        if (canhost) {
            if (isIpV6) {
                [HAMLogOutputWindow printLog:@"ipv6"];
            }else{
                [HAMLogOutputWindow printLog:@"ipv4"];
            }
        }else{

        }
    }];
    if ((delegate.thirdAwakeTokenStatus==2) || (delegate.thirdAwakeTokenStatus==3)) {
        if (![url hasSuffix:@"/mapi/01/device/delete"]) {
            return;
        }
    }
    if ([TRUNetworkStatus currentNetworkStatus]==NotReachable) {
        onResult(-5004, nil);
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式


    manager.responseSerializer = [AFJSONResponseSerializer serializer];//返回格式
    // 超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    // 设置接收的Content-Type
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];

    YCLog(@"url = %@",url);
    NSDate *date = [NSDate date];
    long time = [date timeIntervalSince1970];
    NSString *log1 = [NSString stringWithFormat:@"请求开始 url = %@",url];
    DDLogError(log1);
//    [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"%@ 请求时间 %ld",url,time]];
    [manager POST:url parameters:parts progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YCLog(@" response = %@",responseObject);
        NSString *log2 = [NSString stringWithFormat:@"请求结束 url = %@",url];
        DDLogError(log2);
        NSDate *date1 = [NSDate date];
        long time1 = [date1 timeIntervalSince1970];
        if (onResult) {

            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)responseObject;
                int status = [dic[@"status"] intValue];
                int result = status == 1000 ? 0 : status;
                NSString *log3 = [NSString stringWithFormat:@"请求结束 url = %@,status = %d",url,status];
                DDLogError(log3);
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

+ (void)sendCIMSRequestWithUrl:(NSString *)url withParts:(NSDictionary *)parts onResultWithMessage:(void (^)(int errorno, id responseBody,NSString *message))onResult{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSString *host = [NSURL URLWithString:url].host;
    [self resolveHost:host onResult:^(BOOL canhost, BOOL isIpV6) {
        if (canhost) {
            if (isIpV6) {
                [HAMLogOutputWindow printLog:@"ipv6"];
            }else{
                [HAMLogOutputWindow printLog:@"ipv4"];
            }
        }else{

        }
    }];
    if ((delegate.thirdAwakeTokenStatus==2) || (delegate.thirdAwakeTokenStatus==3)) {
        if (![url hasSuffix:@"/mapi/01/device/delete"]) {
            return;
        }
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//返回格式
    // 超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    // 设置接收的Content-Type
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];

    YCLog(@"url = %@",url);
    NSDate *date = [NSDate date];
    long time = [date timeIntervalSince1970];
    NSString *log1 = [NSString stringWithFormat:@"请求开始 url = %@",url];
    DDLogError(log1);
    [manager POST:url parameters:parts progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YCLog(@" response = %@",responseObject);
        NSString *log2 = [NSString stringWithFormat:@"请求结束 url = %@",url];
        DDLogError(log2);
        NSDate *date1 = [NSDate date];
        long time1 = [date1 timeIntervalSince1970];
        if (onResult) {

            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)responseObject;
                int status = [dic[@"status"] intValue];
                int result = status == 1000 ? 0 : status;
                NSString *log3 = [NSString stringWithFormat:@"请求结束 url = %@,status = %d",url,status];
                DDLogError(log3);
                id response_body = nil;
                if ([dic.allKeys containsObject:@"response_body"]) {
                    response_body = dic[@"response_body"];
                    response_body = [response_body isKindOfClass:[NSNull class]] ? nil : response_body;
                }
                NSString *message=nil;
                if ([dic.allKeys containsObject:@"msg"]) {
                    message = dic[@"msg"];
                    message = [message isKindOfClass:[NSNull class]] ? nil : message;
                }
                onResult(result, response_body,message);
                if (result!=0) {
                    YCLog(@"url = %@ afn result = %d",url,result);
                }
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onResult(-5004, nil,nil);
    }];


}

//+ (void)sendCIMSRequestWithUrl:(NSString *)url withParts:(NSDictionary *)parts onResult:(void (^)(int errorno, id responseBody))onResult{
//    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    if ((delegate.thirdAwakeTokenStatus==2) || (delegate.thirdAwakeTokenStatus==3)) {
//        if (![url hasSuffix:@"/mapi/01/device/delete"]) {
//            return;
//        }
//    }
//    if ([TRUNetworkStatus currentNetworkStatus]==NotReachable) {
//        onResult(-5004, nil);
//    }
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSString *certFilePath = [[NSBundle mainBundle] pathForResource:@"ida.bsb.com.cn" ofType:@"cer"];
//    // 自签名证书转换成二进制数据
//    NSData *certData = [NSData dataWithContentsOfFile:certFilePath];
//    // 将二进制数据放到NSSet中
//    NSSet *certSet = [NSSet setWithObject:certData];
//    /* AFNetworking中的AFSecurityPolicy实例化方法
//     第一个参数：
//     AFSSLPinningModeNone,    //不验证
//     AFSSLPinningModePublicKey,     //只验证公钥
//     AFSSLPinningModeCertificate,     //验证证书
//     第二个参数：存放二进制证书数据的NSSet
//     */
//    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:certSet];
//    manager.securityPolicy = policy;
//    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
//
//
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];//返回格式
//    // 超时时间
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = 30.0f;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//
//    // 设置接收的Content-Type
//    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
//
//    YCLog(@"url = %@",url);
//    NSDate *date = [NSDate date];
//    long time = [date timeIntervalSince1970];
//    //    [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"%@ 请求时间 %ld",url,time]];
//    NSString *log1 = [NSString stringWithFormat:@"请求开始 url = %@",url];
//    DDLogError(log1);
//    [manager POST:url parameters:parts progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        YCLog(@" response = %@",responseObject);
//        NSString *log2 = [NSString stringWithFormat:@"请求结束 url = %@",url];
//        DDLogError(log2);
//        NSDate *date1 = [NSDate date];
//        long time1 = [date1 timeIntervalSince1970];
//        if (onResult) {
//
//            if ([responseObject isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *dic = (NSDictionary *)responseObject;
//                int status = [dic[@"status"] intValue];
//                int result = status == 1000 ? 0 : status;
//                NSString *log3 = [NSString stringWithFormat:@"请求结束 url = %@,status = %d",url,status];
//                DDLogError(log3);
//                id response_body = nil;
//                if ([dic.allKeys containsObject:@"response_body"]) {
//                    response_body = dic[@"response_body"];
//                    response_body = [response_body isKindOfClass:[NSNull class]] ? nil : response_body;
//                }
//                onResult(result, response_body);
//                if (result!=0) {
//                    YCLog(@"url = %@ afn result = %d",url,result);
//                }
//            }
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        onResult(-5004, nil);
//    }];
//
//
//}
//
//+ (void)sendCIMSRequestWithUrl:(NSString *)url withParts:(NSDictionary *)parts onResultWithMessage:(void (^)(int errorno, id responseBody,NSString *message))onResult{
//    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    if ((delegate.thirdAwakeTokenStatus==2) || (delegate.thirdAwakeTokenStatus==3)) {
//        if (![url hasSuffix:@"/mapi/01/device/delete"]) {
//            return;
//        }
//    }
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSString *certFilePath = [[NSBundle mainBundle] pathForResource:@"ida.bsb.com.cn" ofType:@"cer"];
//    // 自签名证书转换成二进制数据
//    NSData *certData = [NSData dataWithContentsOfFile:certFilePath];
//    // 将二进制数据放到NSSet中
//    NSSet *certSet = [NSSet setWithObject:certData];
//    /* AFNetworking中的AFSecurityPolicy实例化方法
//     第一个参数：
//     AFSSLPinningModeNone,    //不验证
//     AFSSLPinningModePublicKey,     //只验证公钥
//     AFSSLPinningModeCertificate,     //验证证书
//     第二个参数：存放二进制证书数据的NSSet
//     */
//    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:certSet];
//    manager.securityPolicy = policy;
//    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];//返回格式
//    // 超时时间
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = 30.0f;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//
//    // 设置接收的Content-Type
//    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
//
//    YCLog(@"url = %@",url);
//    NSDate *date = [NSDate date];
//    long time = [date timeIntervalSince1970];
//    NSString *log1 = [NSString stringWithFormat:@"请求开始 url = %@",url];
//    DDLogError(log1);
//    [manager POST:url parameters:parts progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        YCLog(@" response = %@",responseObject);
//        NSString *log2 = [NSString stringWithFormat:@"请求结束 url = %@",url];
//        DDLogError(log2);
//        NSDate *date1 = [NSDate date];
//        long time1 = [date1 timeIntervalSince1970];
//        if (onResult) {
//
//            if ([responseObject isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *dic = (NSDictionary *)responseObject;
//                int status = [dic[@"status"] intValue];
//                int result = status == 1000 ? 0 : status;
//                NSString *log3 = [NSString stringWithFormat:@"请求结束 url = %@,status = %d",url,status];
//                DDLogError(log3);
//                id response_body = nil;
//                if ([dic.allKeys containsObject:@"response_body"]) {
//                    response_body = dic[@"response_body"];
//                    response_body = [response_body isKindOfClass:[NSNull class]] ? nil : response_body;
//                }
//                NSString *message=nil;
//                if ([dic.allKeys containsObject:@"msg"]) {
//                    message = dic[@"msg"];
//                    message = [message isKindOfClass:[NSNull class]] ? nil : message;
//                }
//                onResult(result, response_body,message);
//                if (result!=0) {
//                    YCLog(@"url = %@ afn result = %d",url,result);
//                }
//            }
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        onResult(-5004, nil,nil);
//    }];
//
//
//}

+(BOOL)resolveHost:(NSString*)hostname onResult:(void (^)(BOOL canhost, BOOL isIpV6))onResult

{
    
    Boolean result;
    
    CFHostRef hostRef;
    
    CFArrayRef addresses;
    
    NSString*ipAddress =nil;
    
    hostRef =CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)hostname);
//    NSLog(@"resolve hostRef=%@",hostRef);
    if(hostRef) {
        
        result =CFHostStartInfoResolution(hostRef,kCFHostAddresses,NULL);// pass an error instead of NULL here to find out why it failed
//        NSLog(@"resolve result=%d",result);
        if(result) {
            addresses =CFHostGetAddressing(hostRef, &result);
            
        }
        
    }
    
    if(result) {
        
        CFIndex index =0;
        
        CFDataRef ref = (CFDataRef)CFArrayGetValueAtIndex(addresses, index);
        
        int port=0;
        
        struct sockaddr*addressGeneric;
        
        NSData*myData = (__bridge NSData*)ref;
        
        addressGeneric = (struct sockaddr*)[myData bytes];
        
        switch(addressGeneric->sa_family) {
                
            case AF_INET: {
                
                struct sockaddr_in*ip4;
                
                char dest[INET_ADDRSTRLEN];
                
                ip4 = (struct sockaddr_in*)[myData bytes];
                
                port =ntohs(ip4->sin_port);
                
                ipAddress = [NSString stringWithFormat:@"%s",inet_ntop(AF_INET, &ip4->sin_addr, dest,sizeof dest)];
//                NSLog(@"resolve AF_INET,ipAddress=%@",ipAddress);
                NSString *log = [NSString stringWithFormat:@"ipv4地址,IP地址为=%@",ipAddress];
                DDLogError(log);
                onResult(YES,NO);
            }
                
                break;
                
            case AF_INET6: {
                //NSLog(@"resolve AF_INET6");
                struct sockaddr_in6*ip6;
                
                char dest[INET6_ADDRSTRLEN];
                
                ip6 = (struct sockaddr_in6*)[myData bytes];
                
                port =ntohs(ip6->sin6_port);
                
                ipAddress = [NSString stringWithFormat:@"%s",inet_ntop(AF_INET6, &ip6->sin6_addr, dest,sizeof dest)];
//                NSLog(@"resolve AF_INET6,ipAddress=%@",ipAddress);
                NSString *log = [NSString stringWithFormat:@"ipv6地址,IP地址为=%@",ipAddress];
                DDLogError(log);
                onResult(YES,YES);
            }
                
                break;
                
            default:
                
                ipAddress =nil;
//                NSLog(@"resolve NO NET TYPE");
                onResult(NO,NO);
                break;
                
        }
        
    }
    
    if(ipAddress) {
        
        return YES;
        
    }else{
        
        return NO;
        
    }
    
}

-(BOOL)resolveHost:(NSString*)hostname onResult:(void (^)(BOOL canhost, BOOL isIpV6))onResult

{
    
    Boolean result;
    
    CFHostRef hostRef;
    
    CFArrayRef addresses;
    
    NSString*ipAddress =nil;
    
    hostRef =CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)hostname);
//    NSLog(@"resolve hostRef=%@",hostRef);
    if(hostRef) {
        
        result =CFHostStartInfoResolution(hostRef,kCFHostAddresses,NULL);// pass an error instead of NULL here to find out why it failed
//        NSLog(@"resolve result=%d",result);
        if(result) {
            
            addresses =CFHostGetAddressing(hostRef, &result);
            
        }
        
    }
    
    if(result) {
        
        CFIndex index =0;
        
        CFDataRef ref = (CFDataRef)CFArrayGetValueAtIndex(addresses, index);
        
        int port=0;
        
        struct sockaddr*addressGeneric;
        
        NSData*myData = (__bridge NSData*)ref;
        
        addressGeneric = (struct sockaddr*)[myData bytes];
        
        switch(addressGeneric->sa_family) {
                
            case AF_INET: {
                
                struct sockaddr_in*ip4;
                
                char dest[INET_ADDRSTRLEN];
                
                ip4 = (struct sockaddr_in*)[myData bytes];
                
                port =ntohs(ip4->sin_port);
                
                ipAddress = [NSString stringWithFormat:@"%s",inet_ntop(AF_INET, &ip4->sin_addr, dest,sizeof dest)];
//                NSLog(@"resolve AF_INET,ipAddress=%@",ipAddress);
                onResult(YES,NO);
            }
                
                break;
                
            case AF_INET6: {
                //NSLog(@"resolve AF_INET6");
                struct sockaddr_in6*ip6;
                
                char dest[INET6_ADDRSTRLEN];
                
                ip6 = (struct sockaddr_in6*)[myData bytes];
                
                port =ntohs(ip6->sin6_port);
                
                ipAddress = [NSString stringWithFormat:@"%s",inet_ntop(AF_INET6, &ip6->sin6_addr, dest,sizeof dest)];
//                NSLog(@"resolve AF_INET6,ipAddress=%@",ipAddress);
                onResult(YES,YES);
            }
                
                break;
                
            default:
                
                ipAddress =nil;
//                NSLog(@"resolve NO NET TYPE");
                onResult(NO,NO);
                break;
                
        }
        
    }
    
    if(ipAddress) {
        
        return YES;
        
    }else{
        
        return NO;
        
    }
    
}

@end
