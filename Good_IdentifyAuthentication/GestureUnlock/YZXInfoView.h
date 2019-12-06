//
//  YZXInfoView.h
//  YZXUnlock
//
//  Created by hukai on 2019/7/18.
//  Copyright © 2019 尹星. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZXInfoView : UIView
- (void)changSuccessWithArray:(NSArray *)array;
- (void)changeFailureWithArray:(NSArray *)array;
- (void)changeNormal;
@end

NS_ASSUME_NONNULL_END
