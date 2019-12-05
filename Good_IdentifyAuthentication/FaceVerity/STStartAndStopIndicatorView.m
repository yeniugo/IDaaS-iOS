//
//  STSrartAndStopIndicatorView.m
//  STSilentLivenessController
//
//  Created by huoqiuliang on 16/12/7.
//  Copyright © 2016年 sensetime. All rights reserved.
//

#import "STStartAndStopIndicatorView.h"

@implementation STStartAndStopIndicatorView

static UIActivityIndicatorView *indicator = nil;
+ (void)sharedIndicatorStartAnimate {
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [mainQueue addOperationWithBlock:^{
        if (indicator == nil) {
            indicator =
                [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [indicator setFrame:CGRectMake(0, 0, 60, 60)];
            [indicator setBackgroundColor:[UIColor clearColor]];
            indicator.color = [UIColor colorWithRed:0 / 255.0 green:121 / 255.0 blue:255 / 255.0 alpha:1];
            [indicator setHidesWhenStopped:YES];
        }

        [indicator setCenter:[UIApplication sharedApplication].keyWindow.center];

        if ([indicator superview] != [UIApplication sharedApplication].keyWindow) {
            [[UIApplication sharedApplication].keyWindow addSubview:indicator];
            if (![indicator isAnimating]) {
                [indicator startAnimating];
            }
        }
    }];
}

+ (void)sharedIndicatorStopAnimate {
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [mainQueue addOperationWithBlock:^{
        if ([indicator superview] == [UIApplication sharedApplication].keyWindow) {
            if ([indicator isAnimating]) {
                [indicator stopAnimating];
            }
            [indicator removeFromSuperview];
        }
    }];
}

@end
