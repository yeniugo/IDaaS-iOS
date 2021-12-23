//
//  UIImage+Color1.h
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/12/20.
//  Copyright © 2021 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Color1)
+ (UIImage *) ly_imageWithColor:(UIColor *)color;

+ (UIImage *) ly_imageWithColor:(UIColor *)color Size:(CGSize)size;
+ (UIImage *)  ly_imageWithFillColor:(UIColor *)FillColor lineColor:(UIColor *)lineColor Size:(CGSize)size;
- (UIImage *) ly_stretched;
@end

NS_ASSUME_NONNULL_END
