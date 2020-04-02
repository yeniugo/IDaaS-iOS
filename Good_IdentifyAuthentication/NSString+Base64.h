//
//  NSString+Base64.h
//  Good_IdentifyAuthentication
//
//  Created by Trusfort on 2020/3/13.
//  Copyright © 2020 zyc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Base64)
- (NSString *)base64Encode;
- (NSString *)base64Decode;
@end

NS_ASSUME_NONNULL_END
