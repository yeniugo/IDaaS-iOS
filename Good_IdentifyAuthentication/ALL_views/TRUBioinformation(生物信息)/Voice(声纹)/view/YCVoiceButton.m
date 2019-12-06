//
//  YCVoiceButton.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/12/25.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "YCVoiceButton.h"

@implementation YCVoiceButton

//点击刚开始，回调这个方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    YCLog(@"点击刚开始");
    if (self.TouchBeganBlock) {
        self.TouchBeganBlock();
    }
}

//手指移开，点击结束
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    YCLog(@"点击结束");
    if (self.TouchEndBlock) {
        self.TouchEndBlock();
    }
}

@end
