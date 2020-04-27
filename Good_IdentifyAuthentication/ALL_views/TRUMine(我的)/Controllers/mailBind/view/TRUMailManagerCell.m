//
//  TRUMailManagerCell.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2020/4/23.
//  Copyright © 2020 zyc. All rights reserved.
//

#import "TRUMailManagerCell.h"

@interface TRUMailManagerCell()
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *deviceTypeLB;
@property (nonatomic,strong) UILabel *devicedetailLB;
@property (nonatomic,strong) UILabel *deviceTimeLB;
@property (nonatomic,strong) UIButton *logoutBtn;
@end

@implementation TRUMailManagerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconView = [[UIImageView alloc] init];
        self.iconView.frame = CGRectMake(20, 15.5, 43, 43);
        self.iconView.layer.cornerRadius = 21.5;
        [self.iconView.layer masksToBounds];
        [self.contentView addSubview:self.iconView];
        self.deviceTypeLB = [[UILabel alloc] init];
        self.deviceTypeLB.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:self.deviceTypeLB];
        self.devicedetailLB = [[UILabel alloc] init];
        self.devicedetailLB.font = [UIFont systemFontOfSize:12.0];
        self.devicedetailLB.textColor = RGBCOLOR(153, 153, 153);
        [self.contentView addSubview:self.devicedetailLB];
        self.deviceTimeLB = [[UILabel alloc] init];
        self.deviceTimeLB.font = [UIFont systemFontOfSize:12.0];
        self.deviceTimeLB.textColor = RGBCOLOR(153, 153, 153);
        [self.contentView addSubview:self.deviceTimeLB];
        self.logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.logoutBtn.frame = CGRectMake(SCREENW - 60 - 20, 21, 60, 32);
        [self.logoutBtn setTitle:@"解绑" forState:UIControlStateNormal];
        [self.logoutBtn setTitleColor:DefaultGreenColor forState:UIControlStateNormal];
        self.logoutBtn.layer.cornerRadius = 5.0;//2.0是圆角的弧度，根据需求自己更改
        self.logoutBtn.layer.borderColor = DefaultGreenColor.CGColor;//设置边框颜色
        self.logoutBtn.layer.borderWidth = 1.0f;//设置边框颜色
        [self.logoutBtn addTarget:self action:@selector(cellLogoutClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.logoutBtn];
        [self.deviceTypeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(89);
            make.top.equalTo(self.contentView.mas_top).with.offset(21);
        }];
        [self.devicedetailLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.deviceTypeLB.mas_right).with.offset(21);
            make.top.equalTo(self.contentView.mas_top).with.offset(21);
            make.right.equalTo(self.contentView.mas_right).with.offset(-100);
        }];
        [self.deviceTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(89);
            make.top.equalTo(self.deviceTypeLB.mas_bottom).with.offset(8.5);
        }];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setCellDic:(NSDictionary *)cellDic{
    self.deviceTypeLB.text = @"iOS";
    self.devicedetailLB.text = @"fafafafdasfsaffasfafdfsfsfasfafafasfafafa";
    self.deviceTimeLB.text = @"fafafafasfaffsdf";
}

- (void)cellLogoutClick{
    if ([self.delegate respondsToSelector:@selector(cellLogoutClickWith:)]) {
        [self.delegate cellLogoutClickWith:self.cellDic];
    }
}


@end
