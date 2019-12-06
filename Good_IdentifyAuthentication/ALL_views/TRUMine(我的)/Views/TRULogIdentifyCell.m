//
//  TRULogIdentifyCell.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/29.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRULogIdentifyCell.h"

@interface TRULogIdentifyCell()

@property (nonatomic,strong) UIView *lineView;

@end

@implementation TRULogIdentifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    UIView *lineView = [[UIView alloc] init];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = RGBCOLOR(234,234,234);
    self.lineView = lineView;
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

-(void)layoutSubviews{
    [super layoutSubviews];
    self.lineView.frame = CGRectMake(0, self.bounds.size.height -1, self.bounds.size.width, 0.5);
}

@end
