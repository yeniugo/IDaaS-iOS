//
//  TRUVoiceBaseViewController.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/5.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUBaseViewController.h"
#import <iflyMSC/IFlyISVDelegate.h>
#import <iflyMSC/IFlyISVRecognizer.h>
#import <iflyMSC/IFlySpeechError.h>
#import "TRUVoiceConst.h"
#import <Lottie/Lottie.h>

@interface TRUVoiceBaseViewController : TRUBaseViewController
@property (nonatomic, assign) BOOL resetVoice;
/** 密码 */
@property (nonatomic, strong) NSArray *passwords;
@property (nonatomic, copy) NSString *sst;
/** 语音识别对象 */
@property (nonatomic, strong) IFlyISVRecognizer *isvRecognizer;

@property (nonatomic, strong) LOTAnimationView *vocieLotView;

@property (nonatomic, weak) UIButton *pressBtn;

//@property (nonatomic, copy) void (^authFailure)();//检测失败后执行

- (NSString *)generateVoiceId;

- (void)initMsg:(NSString *)msg;
- (void)setNumber:(NSString *)number;
- (void)setSSTLable:(NSInteger)index total:(NSInteger)total;
- (void)startRecVoice;
- (void)onResult:(NSDictionary *)dic;
- (void)onError:(IFlySpeechError *) errorCode;
- (void)onCompleted:(IFlySpeechError *)errorCode;
- (void)setIsvParamWithAuthId:(NSString *) auth_id withPassword:(NSString *) password withSSType:(NSString*)sst;

@end
