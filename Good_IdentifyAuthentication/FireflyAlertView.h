//
//  FireflyAlertView.h
//  FireflyFramework
//
//  Created by wenyanjie on 15/4/17.
//  Copyright (c) 2015年 cmbc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertViewBlock)(void);

@interface FireflyAlertView : UIView


/**
 自定义弹框
 
 @param title 标题
 @param message 显示信息
 @param buttonTitle 取消按钮标题
 @return id
 */
+ (id)showWithTitle:(NSString *)title
            message:(NSString *)message
        buttonTitle:(NSString *)buttonTitle;


/**
 自定义弹框
 
 @param title 标题
 @param message 显示信息
 @param cancelTitle 取消按钮标题
 @param cancelBlock 点击取消按钮执行block
 @param otherTitle 确定按钮标题
 @param otherBlock 点击确定按钮执行block
 @return id
 */
+ (id)showWithTitle:(NSString *)title
            message:(NSString *)message
        cancelTitle:(NSString *)cancelTitle
        cancelBlock:(AlertViewBlock)cancelBlock
         otherTitle:(NSString *)otherTitle
         otherBlock:(AlertViewBlock)otherBlock;

@end
