//
//  TRUThirdVoiceVerifyViewController.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2018/1/17.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUVoiceBaseViewController.h"

@interface TRUThirdVoiceVerifyViewController : TRUVoiceBaseViewController
@property (nonatomic, assign) BOOL isMoreVerify;
@property (nonatomic, copy) NSString *voicetoken;
@property (nonatomic, assign) BOOL isPushVerify;

@property (nonatomic, copy) void (^popThirdVoiceBlock)();

@end
