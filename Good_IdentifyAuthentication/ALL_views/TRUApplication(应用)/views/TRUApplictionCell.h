//
//  TRUApplictionCell.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/27.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TRUAuthModel;

@interface TRUApplictionCell : UICollectionViewCell

@property (nonatomic, strong) TRUAuthModel *authModel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *isNewImageView;
@property (weak, nonatomic) IBOutlet UIImageView *appIconImageView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgY;

@end
