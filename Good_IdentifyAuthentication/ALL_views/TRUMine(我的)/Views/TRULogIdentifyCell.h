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

@property (nonatomic, copy) void (^isOnBlock)(UIButton* btn);


@end
