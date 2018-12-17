//
//  YCVoiceButton.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/12/25.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCVoiceButton : UIButton

/** 回调 */
@property (nonatomic, copy) void (^TouchEndBlock)();

@property (nonatomic, copy) void (^TouchBeganBlock)();
@end
