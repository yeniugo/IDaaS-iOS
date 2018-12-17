//
//  TRUNormalButton.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/10/20.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TRUNormalButton;

typedef void (^OnNormalButtonClick)(TRUNormalButton *sender);

@interface TRUNormalButton : UIButton

@property (nonatomic, copy) OnNormalButtonClick homeBlock0xx;

-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title image:(NSString *)imagestr andButtonClickEvent:(OnNormalButtonClick)event;
@end
