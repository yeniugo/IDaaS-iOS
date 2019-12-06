//
//  TRUTimerButton.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/12.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUTimerButton.h"

@interface TRUTimerButton ()
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation TRUTimerButton
static NSInteger totalCount;

- (void)startCount{
    [self stopCount];
     self.enabled = NO;
    
    totalCount = self.timelength;
    totalCount --;
    NSString *title = [NSString stringWithFormat:@"%zds%@", totalCount, self.tipText];
    [self setTitle:title forState:UIControlStateDisabled];
   
        __weak typeof(self) weskself = self;
    if (!self.timer) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weskself selector:@selector(dealCount) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        weskself.timer = timer;
    }
}
- (void)stopCount{
    
    [self.timer invalidate];
    self.timer = nil;
    self.enabled = YES;
    [self setTitle:@"" forState:UIControlStateDisabled];
}
- (void)dealCount{
    totalCount -- ;
    
    if (totalCount > 0) {
        NSString *title = [NSString stringWithFormat:@"%zds%@", totalCount, self.tipText];
        [self setTitle:title forState:UIControlStateDisabled];
    }else{
//        self.enabled = YES;
        
        [self stopCount];
    }
}
- (void)setTimelength:(NSInteger)timelength{
    _timelength = timelength;
    totalCount = timelength;
}

@end
