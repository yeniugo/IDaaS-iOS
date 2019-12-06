//
//  TRUSSHViewCell.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/6/12.
//  Copyright © 2019 zyc. All rights reserved.
//

#import "TRUSSHViewCell.h"

@interface TRUSSHViewCell()
@property (weak, nonatomic) IBOutlet UILabel *account;
@property (weak, nonatomic) IBOutlet UILabel *ipAddress;
@property (weak, nonatomic) IBOutlet UIImageView *statusIMG;
@property (weak, nonatomic) IBOutlet UILabel *statusLB;
@property (weak, nonatomic) IBOutlet UIImageView *OSicon;
@property (weak, nonatomic) IBOutlet UILabel *OSLB;

@end

@implementation TRUSSHViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCellModel:(TRUSSHViewModel *)cellModel{
    _cellModel = cellModel;
    NSArray *tempArray = [cellModel.userName componentsSeparatedByString:@"|"];
    self.account.text = tempArray[0];
    self.ipAddress.text = tempArray[1];
    if (cellModel.appType == 1) {
        self.OSicon.image = [UIImage imageNamed:@"windowsssh"];
        self.OSLB.text = @"Windows";
    }else if(cellModel.appType == 2){
        self.OSicon.image = [UIImage imageNamed:@"linuxssh"];
        self.OSLB.text = @"Linux";
    }
    switch ([cellModel.status integerValue]) {
        case 0:
        {
            self.statusLB.text = @"待审批";
            self.statusIMG.image = [UIImage imageNamed:@"SSHshenpizhong"];
            self.statusLB.hidden = NO;
            self.statusIMG.hidden = NO;
        }
            break;
        case 1:
        {
            self.statusLB.hidden = YES;
            self.statusIMG.hidden = YES;
            
        }
            break;
        case 2:
        {
            self.statusLB.text = @"已拒绝";
            self.statusIMG.image = [UIImage imageNamed:@"SSHshenpijujue"];
            self.statusLB.hidden = NO;
            self.statusIMG.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
