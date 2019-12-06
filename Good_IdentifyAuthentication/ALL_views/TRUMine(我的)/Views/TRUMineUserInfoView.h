//
//  TRUMineUserInfoView.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/26.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonClickBlock)();

@interface TRUMineUserInfoView : UIView
@property (nonatomic, copy) ButtonClickBlock changePhoneBlock;
@property(nonatomic, strong) UILabel * nameLabel;
@property(nonatomic, strong) UILabel * departmentLabel;
@property(nonatomic, strong) UILabel * emailLabel;
@property(nonatomic, strong) UILabel * phoneLabel;
@property(nonatomic, strong) UILabel * userNumLabel;
//头像
@property(nonatomic, strong) UIImageView *userImageView;

-(void)setModel;

@end
