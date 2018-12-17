//
//  TRUThirdFaceVerifyViewController.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2018/1/16.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUFaceBaseViewController.h"

@interface TRUThirdFaceVerifyViewController : TRUFaceBaseViewController
@property (nonatomic, copy) NSString *facetoken;
@property (nonatomic, assign) BOOL isMoreVerify;
@property (nonatomic, assign) BOOL isPushVerify;
@property (nonatomic, copy) void (^popThirdFaceBlock)();
@end
