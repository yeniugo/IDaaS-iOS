//
//  TRUApplictionCell.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/27.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUApplictionCell.h"
#import "TRUAuthModel.h"
#import <YYWebImage.h>

@implementation TRUApplictionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (SCREENW == 320) {
        _imgWidth.constant = 40;
        _imgHeight.constant = 40;
        _imgY.constant = 20;
    }else{
        _imgWidth.constant = 55;
        _imgHeight.constant = 55;
        _imgY.constant = 25;
    }
    
}


- (void)setAuthModel:(TRUAuthModel *)authModel{
    _authModel = authModel;
    self.nameLabel.text = self.authModel.appname;
    if (authModel.appid) {
        [self.appIconImageView yy_setImageWithURL:[NSURL URLWithString:self.authModel.iconurl] placeholder:[UIImage imageNamed:@"authplaceholder"]];
    }else{
        self.appIconImageView.image = nil;
    }
    if (_authModel.isactive) {
        self.isNewImageView.hidden = YES;
    }else{
        self.isNewImageView.hidden = NO;
    }
    [self.contentView setNeedsLayout]; //更新视图
    [self.contentView layoutIfNeeded];
    
}

@end
