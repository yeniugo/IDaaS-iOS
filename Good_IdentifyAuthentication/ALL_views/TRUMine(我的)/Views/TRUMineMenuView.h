//
//  TRUMineMenuView.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/27.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRUMineMenuView : UIView
//app登录验证
@property (nonatomic, copy) void (^logIdentifyBtnBlock)();
//设备管理
@property (nonatomic, copy) void (^deviceManagerBtnBlock)();
//生物信息
@property (nonatomic, copy) void (^bioinfoBtnBlock)();
//问题反馈
@property (nonatomic, copy) void (^feedbackBtnBlock)();
//关于我们
@property (nonatomic, copy) void (^aboutBtnBlock)();
//解除绑定
@property (nonatomic, copy) void (^unbingBtnBlock)();


@end
