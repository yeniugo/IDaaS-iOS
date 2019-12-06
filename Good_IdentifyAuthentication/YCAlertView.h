//
//  YCAlertView.h
//  YCAlertView
//
//  Created by zyc on 2017/11/1.
//  Copyright © 2017年 YC. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^OnCancleButtonClick)();
typedef void (^OnSureButtonClick)();


@interface YCAlertView : UIView

@property (nonatomic, copy) OnCancleButtonClick cancleBlock;
@property (nonatomic, copy) OnSureButtonClick sureBlock;


-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title alertMessage:(NSString *)msg confrimBolck:(void (^)())confrimBlock cancelBlock:(void (^)())cancelBlock;
//弹出
-(void)show;

//隐藏
-(void)hide;


@end
