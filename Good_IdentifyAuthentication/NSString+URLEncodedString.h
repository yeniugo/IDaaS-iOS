//
//  NSString+URLEncodedString.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2020/5/11.
//  Copyright © 2020 zyc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (URLEncodedString)
- (NSString *)gtm_stringByEscapingForURLArgument;
- (NSString *)gtm_stringByUnescapingFromURLArgument;
@end

NS_ASSUME_NONNULL_END
