//
//  TFGestureSettingViewController.h
//  Trusfort
//
//  Created by muhuaxin on 16/3/20.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import "TRUBaseViewController.h"

@interface TRUGestureSettingViewController : TRUBaseViewController

@property (nonatomic, copy) NSString *phone;

@property (copy, nonatomic) void(^backBlocked)();

@end
