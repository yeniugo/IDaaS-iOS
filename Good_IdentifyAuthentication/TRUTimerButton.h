//
//  TRUTimerButton.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/12.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRUTimerButton : UIButton
/** 时长 */
@property (nonatomic, assign) NSInteger timelength;
@property (nonatomic, copy) NSString *tipText;
- (void)startCount;
- (void)stopCount;

@end
