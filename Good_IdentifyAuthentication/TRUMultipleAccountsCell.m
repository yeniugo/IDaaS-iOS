//
//  TRUMultipleAccountsCell.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/12/18.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUMultipleAccountsCell.h"
#import <YYWebImage.h>

@interface TRUMultipleAccountsCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIView *twoModelView;
@property (weak, nonatomic) IBOutlet UIView *threeModelView;
@property (weak, nonatomic) IBOutlet UILabel *twoAccount;
@property (weak, nonatomic) IBOutlet UILabel *twoUserName;
@property (weak, nonatomic) IBOutlet UILabel *threeAccount;
@property (weak, nonatomic) IBOutlet UILabel *threeAppName;
@property (weak, nonatomic) IBOutlet UILabel *threeUserName;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (strong,nonatomic) UIView *lineView;

@end

@implementation TRUMultipleAccountsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.iconView.layer.cornerRadius = 45.0/2;
    self.iconView.layer.masksToBounds =YES;
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = RGBCOLOR(234, 234, 234);
    [self addSubview:self.lineView];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.lineView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, -1);
}

- (void)setCellModel:(id)cellModel{
    _cellModel = cellModel;
    if ([cellModel isKindOfClass:[TRUUserModel class]]) {
        TRUUserModel *model = cellModel;
        self.threeModelView.hidden = YES;
        self.twoModelView.hidden = NO;
        self.twoAccount.text = model.realname;
        self.twoUserName.text = model.realname;
        self.iconView.image = [UIImage imageNamed:@"DefaultAvatar"];
    }else if([cellModel isKindOfClass:[TRUSubUserModel class]]){
        TRUSubUserModel *model = cellModel;
        if(model.appName.length){
            self.threeModelView.hidden = NO;
            self.twoModelView.hidden = YES;
            self.threeAccount.text = model.activation;
            self.threeUserName.text = model.username;
            self.threeAppName.text = model.appName;
            if(model.img.length){
                [self.iconView yy_setImageWithURL:[NSURL URLWithString:model.img] placeholder:[UIImage imageNamed:@"DefaultAvatar"]];
            }
        }else{
            self.threeModelView.hidden = YES;
            self.twoModelView.hidden = NO;
            self.twoAccount.text = model.activation;
            self.twoUserName.text = model.username;
            self.iconView.image = [UIImage imageNamed:@"DefaultAvatar"];
        }
    }
}

-(void)setCellSetSelectImage:(BOOL)cellSetSelectImage{
    _cellSetSelectImage = cellSetSelectImage;
    self.selectImageView.highlighted = cellSetSelectImage;
    if ([self.cellModel isKindOfClass:[TRUUserModel class]]) {
        TRUUserModel *model = self.cellModel;
//        YCLog(@"model.username = %@,highlighted = %d",model.realname,cellSetSelectImage);
    }else{
        TRUSubUserModel *model = self.cellModel;
//        YCLog(@"model.username = %@,highlighted = %d",model.username,cellSetSelectImage);
    }
    
}

-(void)setCellNeedSelect:(BOOL)cellNeedSelect{
    _cellNeedSelect = cellNeedSelect;
    self.selectImageView.hidden = !cellNeedSelect;
//    if (!cellNeedSelect) {
//        self.selectImageView.hidden = YES;
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    self.selectImageView.highlighted = selected;
//    YCLog(@"highlighted %d",selected);
    // Configure the view for the selected state
}

@end
