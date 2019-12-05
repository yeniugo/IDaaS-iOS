//
//  NSString+Regular.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2016/12/29.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import "NSString+Regular.h"

@implementation NSString (Regular)
- (BOOL)isEmail{
    NSString *regExp = @"\\w[-\\w.+]*@([A-Za-z0-9][-A-Za-z0-9]+\\.)+[A-Za-z]{2,14}";
    return [self validateWithRegExp:regExp];
}
- (BOOL)isPhone{
    NSString * regExp = @"^1\\d{10}$";
    return [self validateWithRegExp:regExp];
}
- (BOOL)validateWithRegExp: (NSString *)regExp
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:self];
    
}

@end
