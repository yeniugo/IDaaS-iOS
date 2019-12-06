//
//  TRUDevicesManagerCell.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/29.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUDevicesManagerCell.h"
#import "TRUDeviceModel.h"

@implementation TRUDevicesManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (IBAction)sliderBtnClick:(UIButton *)sender {
//    sender.selected = !sender.selected;
    if (_configPushBlock) {
        _configPushBlock(sender);
    }
}



- (void)setDeviceModel:(TRUDeviceModel *)deviceModel{
    _deviceModel = deviceModel;
    if ([deviceModel.ifself isEqualToString:@"1"]) {
        //        self.deviceNameLabel.text = @"本机";
        self.nameLabel.text = [NSString stringWithFormat:@"%@(本机)",deviceModel.devname];
    }else{
        self.nameLabel.text = deviceModel.devname;
    }
    
    if ([deviceModel.ostype isEqualToString:@"ios"]) {
        self.deviceDetailLabel.text = [NSString stringWithFormat:@"iPhone iOS %@",deviceModel.osversion];
    }else{
        self.deviceDetailLabel.text = [NSString stringWithFormat:@"Android %@",deviceModel.osversion];
    }
    
    if ([deviceModel.ifpush isEqualToString:@"1"]) {
        self.sliderBtn.selected = YES;
    }else{
        self.sliderBtn.selected = NO;
    }
    
    if ([deviceModel.ostype isEqualToString:@"ios"]) {
        self.imgview.image = [UIImage imageNamed:@"deveice_iphone"];
    }else{
        self.imgview.image = [UIImage imageNamed:@"deveice_android"];
    }
    
}

- (void)delButtonClick{
    
    if (self.delDeviceBlock) {
        self.delDeviceBlock(_deviceModel);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
