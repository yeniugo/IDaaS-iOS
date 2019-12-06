//
//  TRUPortalView.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/8/19.
//  Copyright © 2019 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRUPortalModel.h"
#import "TRUPushAuthModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TRUPortalView : UIView
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, copy) void (^portalClick)(TRUPortalModel *model);
@property (nonatomic, copy) void (^authBtnClick)(TRUPushAuthModel *model);
@property (nonatomic, copy) void (^refreshBlock)(void);
@property (nonatomic,strong) TRUPushAuthModel *model;
- (void)stopRefresh;
@end

NS_ASSUME_NONNULL_END
