//
//  UIImage+Resize.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/19.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)
- (UIImage *)resizeImageWithSize:(CGSize)size;
- (UIImage *)stretchImageWithFLeftCapWidth:(CGFloat)fLeftCapWidth
                             fTopCapHeight:(CGFloat)fTopCapHeight
                                  desWidth:(CGFloat)desWidth
                                 desHeight:(CGFloat)desHeight
                             sLeftCapWidth:(CGFloat)sLeftCapWidth
                             sTopCapHeight:(CGFloat)sTopCapHeight;
@end
