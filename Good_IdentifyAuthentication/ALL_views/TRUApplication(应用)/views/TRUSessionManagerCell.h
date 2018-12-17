//
//  TRUSessionManagerCellTableViewCell.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/9/11.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRUSessionManagerModel;

@interface TRUSessionManagerCell : UITableViewCell
/** model */
@property (nonatomic, strong) TRUSessionManagerModel *sessionModel;
/** 按钮点击block */
@property (nonatomic, copy) void (^logoutBtnClickBlock)();;
@end
