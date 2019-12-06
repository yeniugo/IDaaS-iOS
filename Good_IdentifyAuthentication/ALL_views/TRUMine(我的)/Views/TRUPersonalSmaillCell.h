//
//  TRUPersonalSmaillCell.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/30.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRUPersonalSmailModel.h"
@interface TRUPersonalSmaillCell : UITableViewCell


/**
 是否显示分割线
 */
@property (nonatomic, assign) BOOL isShort;//是否为长短线
@property (nonatomic, strong) TRUPersonalSmailModel *cellModel;
@end
