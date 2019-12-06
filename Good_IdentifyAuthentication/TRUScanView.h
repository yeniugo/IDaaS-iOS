//
//  TRUScanView.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2016/12/13.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRUScanView : UIView
- (instancetype)initWithScanLine;
- (void)beginScanning;
- (void)stopScaning;
- (void)resumeAnimation;
- (void)stopAnimation;
/** block */
@property (nonatomic, copy) void (^scanResultBlock)(NSString *result);
@property (nonatomic, weak) UIView *scanView;
@end
