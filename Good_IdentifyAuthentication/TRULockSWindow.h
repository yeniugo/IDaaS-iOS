//
//  TRULockSWindow.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/9/19.
//  Copyright © 2019 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRULockSWindow : UIWindow
+ (void)showAuthView;

//+ (void)showLoading;

//+ (void)showAuthViewWithCompletionBlock:(void (^)(void ))success;

+ (void)dismissAuthView;

+ (void)dismissAuthViewAndCleanStatus;

+ (BOOL)isLocked;
@end

NS_ASSUME_NONNULL_END
