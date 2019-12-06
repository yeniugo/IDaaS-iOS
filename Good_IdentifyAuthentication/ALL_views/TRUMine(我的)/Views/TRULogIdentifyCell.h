//
//  TRULogIdentifyCell.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/29.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRULogIdentifyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *txtLabel;

@property (weak, nonatomic) IBOutlet UIImageView *ArrowIcon;

@property (weak, nonatomic) IBOutlet UIButton *isOnButton;

@property (weak, nonatomic) IBOutlet UISwitch *isOnSwitch;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (nonatomic, copy) void (^isOnBlock)(UIButton* btn);

@property (nonatomic, copy) void (^isOnSwitchBlock)(UISwitch* switchBtn);



@end
