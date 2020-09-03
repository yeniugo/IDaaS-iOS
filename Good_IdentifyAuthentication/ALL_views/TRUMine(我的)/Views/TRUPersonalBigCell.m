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
#import "TRUCompanyAPI.h"
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
    self.userNameLB.font = [UIFont systemFontOfSize:23.0];
    self.userNameLB.textColor = [UIColor whiteColor];
//    self.userDepartmentLB.text = [TRUUserAPI getUser].department;
    NSString *activeStr = [TRUCompanyAPI getCompany].activation_mode;
    self.userDepartmentLB.textColor = [UIColor whiteColor];
    self.userDepartmentLB.layer.cornerRadius = 12;
    self.userDepartmentLB.layer.borderWidth = 1;
    self.userDepartmentLB.layer.borderColor = RGBCOLOR(102, 182, 255).CGColor;
    self.userDepartmentLB.layer.masksToBounds = YES;
    self.userDepartmentLB.backgroundColor = RGBACOLOR(20, 158, 255, 1.0);
    if (activeStr.length>0) {
        NSArray *arr = [activeStr componentsSeparatedByString:@","];
        if (arr.count>0) {
            NSString *modeStr = arr[0];
            if ([modeStr isEqualToString:@"1"]) {//激活方式 激活方式(1:邮箱,2:手机,3:工号)
                self.userDepartmentLB.text = [NSString stringWithFormat:@"  %@  ",[TRUUserAPI getUser].email];
            }else if ([modeStr isEqualToString:@"2"]){
                self.userDepartmentLB.text = [NSString stringWithFormat:@"  %@  ",[TRUUserAPI getUser].phone];
            }else if ([modeStr isEqualToString:@"3"]){
                self.userDepartmentLB.text = [NSString stringWithFormat:@"  %@  ",[TRUUserAPI getUser].employeenum];
            }else if ([modeStr isEqualToString:@"4"]) {//激活方式 激活方式(1:邮箱,2:手机,3:工号)
                self.userDepartmentLB.text = [NSString stringWithFormat:@"  %@  ",[TRUUserAPI getUser].employeenum];
            }else if ([modeStr isEqualToString:@"5"]){
                self.userDepartmentLB.text = [NSString stringWithFormat:@"  %@  ",[TRUUserAPI getUser].employeenum];
            }
        }
        
    }
    self.contentView.backgroundColor = DefaultGreenColor;
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = RGBCOLOR(234, 234, 234);
    [self addSubview:self.lineView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    self.lineView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, -1);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
