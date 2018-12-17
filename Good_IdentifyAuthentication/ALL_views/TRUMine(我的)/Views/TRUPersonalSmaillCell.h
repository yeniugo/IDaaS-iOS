//
//  TRUPersonalSmaillCell.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/30.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRUPersonalSmaillCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

/**
 是否显示分割线
 */
@property (nonatomic, assign) BOOL isShort;//是否为长短线
@end
