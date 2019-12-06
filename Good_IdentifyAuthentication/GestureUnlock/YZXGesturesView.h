//
//  YZXGesturesView.h
//  unlockText
//
//  Created by 尹星 on 2017/10/27.
//  Copyright © 2017年 尹星. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const YZX_KEYCHAIN_SERVICE;
extern NSString *const YZX_KEYCHAIN_ACCOUNT;

//回传选择的id
typedef void (^GestureBlock)(NSArray *selectedID);

typedef void (^GestureErrorBlock)(void);

@interface YZXGesturesView : UIView

/**
 设置密码时，返回设置的手势密码
 */
@property (nonatomic, copy) GestureBlock             gestureBlock;


@property (nonatomic,copy) GestureErrorBlock         gestureErrorBlock;

/**
 判断是设置手势还是手势解锁
 */
@property (nonatomic, assign) BOOL         settingGesture;


- (void)unlockSuccess;
- (void)unlockFailure;
- (void)resetNormal;
@end
