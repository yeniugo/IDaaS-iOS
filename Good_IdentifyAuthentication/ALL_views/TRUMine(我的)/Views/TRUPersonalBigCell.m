//
//  TRUPersonalBigCell.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/30.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUPersonalBigCell.h"
#import  <YYWebImage/YYWebImage.h>
#import "TRUUserAPI.h"
@interface TRUPersonalBigCell()
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLB;
@property (weak, nonatomic) IBOutlet UILabel *userDepartmentLB;
@property (nonatomic,strong) UIView *lineView;//下划线
@end


@implementation TRUPersonalBigCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setCustomUI];
}

- (void)setCustomUI{
    self.userNameLB.text = [TRUUserAPI getUser].realname;
    self.userDepartmentLB.text = [TRUUserAPI getUser].department;
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = RGBCOLOR(234, 234, 234);
    [self addSubview:self.lineView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.lineView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, -1);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
