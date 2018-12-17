//
//  TRUEnterAPPAuthView.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/2/16.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRUEnterAPPAuthView : UIWindow
@property (nonatomic, copy) void (^didClickLoginSuccessBlock)();

+ (void)showAuthView;

+ (void)showAuthViewWithCompletionBlock:(void (^)(void ))success;

+ (void)dismissAuthView;

+ (void)dismissAuthViewAndCleanStatus;
@end
