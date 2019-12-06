//
//  TRULogIdentifyCell.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/29.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRULogIdentifyCell.h"

@interface TRULogIdentifyCell()



@end

@implementation TRULogIdentifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)switchValueChange:(UISwitch *)sender {
    if (_isOnSwitchBlock) {
        _isOnSwitchBlock(sender);
    }
}

- (IBAction)isOnButtonClick:(UIButton *)sender {
    if (_isOnBlock) {
        _isOnBlock(sender);
    }
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
