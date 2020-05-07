//
//  TRUPortalCell.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/3/19.
//  Copyright © 2019 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRUPortalModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TRUPortalCell : UICollectionViewCell
@property (nonatomic,strong) TRUPortalModel *cellModel;
/// 0:默认cell，1左下角，2右下角
//@property (nonatomic,assign) int cellType;
@end

NS_ASSUME_NONNULL_END
