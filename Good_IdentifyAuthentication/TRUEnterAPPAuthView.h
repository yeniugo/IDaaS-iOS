//
//  TRUEnterAPPAuthView.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/2/16.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NSInteger AuthViewType;
NS_ENUM(AuthViewType) {
    AuthViewTypeNone =  0,
    AuthViewTypeAuth =  1,
    AuthViewTypeLoading =  2,
    AuthViewTypeAuthWithBlock = 3,
    };
@interface TRUEnterAPPAuthView : UIWindow
@property (nonatomic, copy) void (^didClickLoginSuccessBlock)();

+ (void)showAuthView;

+ (void)showLoading;

+ (void)showAuthViewWithCompletionBlock:(void (^)(void ))success;

+ (void)dismissAuthView;

+ (void)dismissAuthViewAndCleanStatus;
@end
