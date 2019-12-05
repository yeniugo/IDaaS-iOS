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
typedef NS_OPTIONS(NSUInteger, collectioncellLine) {
    collectioncellLineNone                 = 0,
    collectioncellLineLeft                 = 1 << 0,
    collectioncellLineTop                  = 1 << 1,
    collectioncellLineRight                = 1 << 2,
    collectioncellLineBottom               = 1 << 3
};
@interface TRUPortalCell : UICollectionViewCell
@property (nonatomic,strong) TRUPortalModel *cellModel;
@property (nonatomic,assign) collectioncellLine lineType;
@end

NS_ASSUME_NONNULL_END
