//
//  TRUAuthenticateBtn.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/31.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRUAuthenticateBtn : UIButton
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *textLabel;
- (void)setAuthNumber:(NSInteger)number;
@end
