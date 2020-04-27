//
//  TRUMailManagerCell.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2020/4/23.
//  Copyright © 2020 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TRUMailManagerCellDelegate <NSObject>

- (void)cellLogoutClickWith:(NSDictionary *)dic;

@end


@interface TRUMailManagerCell : UITableViewCell
@property (nonatomic,copy) NSDictionary *cellDic;
@property (nonatomic,weak) id<TRUMailManagerCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
