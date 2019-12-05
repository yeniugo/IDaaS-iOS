//
//  TRULogToFile.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/8/26.
//  Copyright © 2019 zyc. All rights reserved.
//

#import "TRULogToFile.h"

@interface TRULogToFile()

@end


@implementation TRULogToFile
static id _TRULogToFile = nil;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _TRULogToFile = [super allocWithZone:zone];
        TRULogToFile *view = _TRULogToFile;
        
    });
    return _TRULogToFile;
}

//copy在底层 会调用copyWithZone:
- (id)copyWithZone:(NSZone *)zone{
    return  _TRULogToFile;
}
+ (id)copyWithZone:(struct _NSZone *)zone{
    return  _TRULogToFile;
}
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return _TRULogToFile;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return _TRULogToFile;
}

+ (void)initWithFile{
    
}

@end
