//
//  TRUSSHViewModel.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/6/14.
//  Copyright © 2019 zyc. All rights reserved.
//

#import "TRUSSHViewModel.h"

@implementation TRUSSHViewModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"keyid" : @"id",
             };
}
@end
