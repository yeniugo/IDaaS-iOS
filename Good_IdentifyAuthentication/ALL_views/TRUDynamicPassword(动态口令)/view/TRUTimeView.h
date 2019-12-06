//
//  TRUTimeView.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/10/13.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRUTimeView : UIView


-(instancetype)initWithFrame:(CGRect)frame withTimelength:(NSInteger)timelength;
- (void)startCountWithTime:(NSInteger)timeNumber;
- (void)stopCount;

@end
