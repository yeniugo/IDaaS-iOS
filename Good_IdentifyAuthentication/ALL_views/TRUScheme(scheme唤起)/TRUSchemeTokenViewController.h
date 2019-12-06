//
//  TRUSchemeToken.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/16.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUBaseViewController.h"

@interface TRUSchemeTokenViewController : TRUBaseViewController
@property (assign, nonatomic) int schemetype;
@property (assign, nonatomic) BOOL isShowAuth;//是否该显示showAuth
@property (assign, nonatomic) BOOL isNeedpush;//是否该显示push
@property (nonatomic, copy) void (^completionBlock)(NSDictionary *tokenDic);
//@property (assign, nonatomic) BOOL isFirstLogin;//是否为第一次登陆,默认值为NO
@end
