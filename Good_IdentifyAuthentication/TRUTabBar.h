//
//  TRUTabBar.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/10.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TRUTabBarScanButtonDelegate <NSObject>

- (void)scanQRButtonClick;

@end
@interface TRUTabBar : UITabBar
@property (nonatomic, weak) id<TRUTabBarScanButtonDelegate> scanButtonDelegate;
@end
