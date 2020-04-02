//
//  UIScrollView+UITouch.h
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2020/4/2.
//  Copyright © 2020 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (UITouch)
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
@end

NS_ASSUME_NONNULL_END
