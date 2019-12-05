//
//  TRUSessionManagerCellTableViewCell.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/9/11.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUSessionManagerCell.h"
#import "TRUSessionManagerModel.h"


@interface TRUSessionManagerCell ()
@property (weak, nonatomic) IBOutlet UILabel *loginIPLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;

@end

@implementation TRUSessionManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setSessionModel:(TRUSessionManagerModel *)sessionModel{
    _sessionModel = sessionModel;
    self.loginIPLabel.text = [NSString stringWithFormat:@"登录IP：%@", sessionModel.ipAddr];
    self.regionLabel.text = [NSString stringWithFormat:@"%@", sessionModel.browserExplorer];
}
- (IBAction)logoutBtnClick:(UIButton *)sender {
    if (self.logoutBtnClickBlock) {
        self.logoutBtnClickBlock();
    }
}

@end
