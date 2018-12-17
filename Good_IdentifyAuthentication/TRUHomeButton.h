//
//  TRUHomeButton.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/27.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRUHomeButton;

typedef void (^OnButtonClick)(TRUHomeButton *sender);

@interface TRUHomeButton : UIButton

@property (nonatomic, copy) OnButtonClick homeBlock0xx;

-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title image:(NSString *)imagestr andButtonClickEvent:(OnButtonClick)event;

-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title state:(UIControlState)state andButtonClickEvent:(OnButtonClick)event;

-(instancetype)initWithFrame:(CGRect)frame  withButtonClickEvent:(OnButtonClick)event;


//带下划线的
-(instancetype)initWithFrame:(CGRect)frame withUnlineTitle:(NSString *)title UnlineColor:(UIColor *)color andButtonClickEvent:(OnButtonClick)event;


@end
