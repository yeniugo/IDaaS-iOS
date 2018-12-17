//
//  TRUOtherButton.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/12/13.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TRUOtherButton;

typedef void (^OnOtherButtonClick)(TRUOtherButton *sender);

@interface TRUOtherButton : UIButton

@property (nonatomic, copy) OnOtherButtonClick homeBlock0xx;

-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title image:(NSString *)imagestr andButtonClickEvent:(OnOtherButtonClick)event;

-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title state:(UIControlState)state andButtonClickEvent:(OnOtherButtonClick)event;

-(instancetype)initWithFrame:(CGRect)frame  withButtonClickEvent:(OnOtherButtonClick)event;


//带下划线的
-(instancetype)initWithFrame:(CGRect)frame withUnlineTitle:(NSString *)title UnlineColor:(UIColor *)color andButtonClickEvent:(OnOtherButtonClick)event;

@end
