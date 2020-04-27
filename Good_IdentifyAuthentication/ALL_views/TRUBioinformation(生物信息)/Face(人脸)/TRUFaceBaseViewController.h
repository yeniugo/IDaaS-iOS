//
//  TRUFaceBaseViewController.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/5.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUBaseViewController.h"

@interface TRUFaceBaseViewController : TRUBaseViewController
@property (assign, nonatomic) int maxDetectionTimes;//最大检测次数
//@property (nonatomic, copy) void (^authFailure)();//检测失败后执行
- (NSMutableArray *) getActionSequence;
- (void) onDetectSuccessWithImages:(NSMutableArray *) images;
- (void) onDetectFailWithMessage:(NSString *) message;
- (void) restartDetection;
- (void) restartGroupDetection;
@end
