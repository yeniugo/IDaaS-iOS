//
//  TRUPersonalDetailsCell.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/31.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRUPersonalDetailsModel.h"
#import "TRUBaseViewController.h"
@interface TRUPersonalDetailsCell : UITableViewCell
@property (nonatomic,strong) TRUPersonalDetailsModel *cellDate;//三种类型，值分别为0，1，2
@property (nonatomic,strong) TRUBaseViewController *rootVC;
@end
