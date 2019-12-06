//
//  TRUPersonalSmaillCell.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/30.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUPersonalSmaillCell.h"

@interface TRUPersonalSmaillCell()
@property (weak, nonatomic) IBOutlet UIView *backGroudView;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowIcon;
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;
@property (weak, nonatomic) IBOutlet UILabel *rightLB;
@property (weak, nonatomic) IBOutlet UIView *rightCircleView;//自动更新
@property (weak, nonatomic) IBOutlet UILabel *centerLB;


@property (nonatomic,strong) UIView *lineView;//下划线
@end

@implementation TRUPersonalSmaillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    [self setAccessoryType:UITableViewCellAccessoryNone];
//    self.backGroudView.layer.cornerRadius = 4*PointHeightRatio6;
//    self.backGroudView.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = RGBCOLOR(234, 234, 234);
    [self addSubview:self.lineView];
    self.isShort = NO;
    self.rightCircleView.backgroundColor = RGBCOLOR(255, 46, 41);
    self.rightCircleView.layer.cornerRadius = 3;
    self.rightCircleView.layer.masksToBounds = YES;
    self.centerLB.textColor = RGBCOLOR(255, 46, 41);
}

//-(void)setIsShowLine:(BOOL)isShowLine{
//    _isShowLine = isShowLine;
//    self.lineView.hidden = !isShowLine;
//}

-(void)setCellModel:(TRUPersonalSmailModel *)cellModel{
    _cellModel = cellModel;
//    self.isShort = YES;
    switch (cellModel.cellType) {
        case PersonalSmaillCellNormal:
        {
            self.icon.hidden = NO;
            self.icon.image = [UIImage imageNamed:cellModel.leftIcon];
            self.message.hidden = NO;
            self.message.text = cellModel.leftStr;
            self.rightArrowIcon.hidden = NO;
            self.rightIcon.hidden = YES;
            self.rightLB.hidden = YES;
            self.rightCircleView.hidden = YES;
            self.centerLB.hidden = YES;
        }
            break;
        case PersonalSmaillCellRightIcon:
        {
            self.icon.hidden = NO;
            self.icon.image = [UIImage imageNamed:cellModel.leftIcon];
            self.message.hidden = NO;
            self.message.text = cellModel.leftStr;
            self.rightArrowIcon.hidden = YES;
            self.rightIcon.hidden = NO;
            self.rightIcon.image = [UIImage imageNamed:cellModel.rightIcon];
            self.rightLB.hidden = YES;
            self.rightCircleView.hidden = YES;
            self.centerLB.hidden = YES;
        }
            break;
        case PersonalSmaillCellRightLBwithIcon:
        {
            self.icon.hidden = NO;
            self.icon.image = [UIImage imageNamed:cellModel.leftIcon];
            self.message.hidden = NO;
            self.message.text = cellModel.leftStr;
            self.rightArrowIcon.hidden = YES;
            self.rightIcon.hidden = YES;
            self.rightLB.hidden = NO;
            self.rightLB.text = cellModel.rightStr;
            self.rightCircleView.hidden = !cellModel.canUpdate;
            self.centerLB.hidden = YES;
        }
            break;
        case PersonalSmaillCellCenterLB:
        {
            self.icon.hidden = YES;
            self.message.hidden = YES;
            self.rightArrowIcon.hidden = YES;
            self.rightIcon.hidden = YES;
            self.rightLB.hidden = YES;
            self.rightCircleView.hidden = YES;
            self.centerLB.hidden = NO;
            self.centerLB.text = cellModel.CenterStr;
        }
            break;
        default:
            break;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if(self.isShort){
        self.lineView.frame = CGRectMake(16+4*PointHeightRatio6, self.bounds.size.height, self.bounds.size.width-26-8*PointHeightRatio6, -1);
    }else{
        self.lineView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width-0, -1);
    }
    
//    if (self.subviews.count>1) {
    
//        for (int i = 1;i<self.subviews.count;i++) {
//            [self.subviews[i] removeFromSuperview];
//        }
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
