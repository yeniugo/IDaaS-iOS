//
//  TRUDevicesManagerCell.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/29.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TRUDeviceModel;
@interface TRUDevicesManagerCell : UITableViewCell
/** 设备模型 */
@property (nonatomic, strong) TRUDeviceModel *deviceModel;
/** block */
@property (nonatomic, copy) void (^configPushBlock)(UIButton* btn);
@property (nonatomic, copy) void (^delDeviceBlock)(TRUDeviceModel *model);

@property (weak, nonatomic) IBOutlet UIButton *sliderBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imgview;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *deviceDetailLabel;



@end
