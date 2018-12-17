//
//  TRUVerifyFaceViewController.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/11/27.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUBaseViewController.h"

@interface TRUVerifyFaceViewController : TRUBaseViewController

//是否打开指纹验证
@property (nonatomic, assign) BOOL openFaceAuth;
//是否正在进行指纹验证
@property (nonatomic, assign) BOOL isDoingAuth;

@property (copy, nonatomic) void(^backBlocked)(BOOL ison);

@property (nonatomic, copy) void (^completionBlock)();

@end
