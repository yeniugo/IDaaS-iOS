//
//  TRUAboutUSCell.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/29.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUAboutUSCell.h"

@interface TRUAboutUSCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *txtspacingConstraint;

@end

@implementation TRUAboutUSCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (SCREENW == 320.0) {
        _txtspacingConstraint.constant = 5;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
