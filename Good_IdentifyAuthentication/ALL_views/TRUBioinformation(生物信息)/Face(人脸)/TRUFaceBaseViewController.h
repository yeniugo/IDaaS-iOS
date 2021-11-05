//
//  TRUFaceBaseViewController.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/5.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUBaseViewController.h"
//#import "BDFaceRemindAnimationView.h"

typedef enum : NSUInteger {
    CommonStatus,
    PoseStatus,
    occlusionStatus
} WarningStatus;

@interface TRUFaceBaseViewController : TRUBaseViewController


@property (nonatomic,assign) int maxDetectionTimes;

- (void) onDetectSuccessWithImages:(UIImage *) images;
- (void) onDetectFailWithMessage:(NSString *) message;
- (void) restartDetection;
- (void) restartGroupDetection;
@end
