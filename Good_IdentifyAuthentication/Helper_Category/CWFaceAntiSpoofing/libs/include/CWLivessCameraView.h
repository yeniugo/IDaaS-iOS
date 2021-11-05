//
//  CWLivessCameraView.h
//  CloudwalkFaceSDKDemo
//
//  Created by 马辉 on 2021/2/8.
//  Copyright © 2021 DengWuPing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CWLivessCameraView : UIView

@property (nonatomic, strong) UIView *cameraView;
@property (nonatomic, copy) void(^outTimeCallBack)(void);
@property (nonatomic, copy) void(^cancelCallBack)(void);
@property (nonatomic, strong) UIView *bMaskView;

- (void)pageStartAnimation;
- (void)actionsAnimation:(NSArray *)actions;
- (void)actionStepIndex:(NSInteger)index;

- (void)stopAllTimer;
- (void)creatTimerWithTime:(NSInteger)time;
- (void)showTipText:(NSString *)text;
- (void)hiddenTipView:(BOOL)hidden;

- (void)stopAnimations;
- (void)hiddenErrorTipView;
- (void)circleProgressAnimation;

- (void)showHackCheckingLabel;
- (void)showCountDownLabel:(BOOL)show;
@end

NS_ASSUME_NONNULL_END
