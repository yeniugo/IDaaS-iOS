//
//  TRUDynamicCodeLabel.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/14.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRUDynamicCodeLabel : UILabel
/// 间距
@property (nonatomic, assign) CGFloat   spacing;
/// 间距
@property (nonatomic, assign) CGFloat   midSpacing;
/// 边框线宽度
@property (nonatomic, assign) CGFloat   lineWidth;
/// 边框颜色
@property (nonatomic, strong) UIColor   *borderColor;
/// 边框圆角
@property (nonatomic, assign) CGFloat   cornerRadius;
@end
