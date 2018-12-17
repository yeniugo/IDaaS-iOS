//
//  TRUAuthenticateTopImageView.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/31.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRUAuthenticateTopImageView : UIView
@property (nonatomic,strong) UIImageView *logImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailsLabel;
- (void)setAuthNumber:(NSInteger)number;
@end
