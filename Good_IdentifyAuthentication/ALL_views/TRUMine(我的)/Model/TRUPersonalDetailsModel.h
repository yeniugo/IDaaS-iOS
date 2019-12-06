//
//  TRUPersonalDetailsModel.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/31.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRUPersonalDetailsModel : NSObject
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) NSString *detailsStr;
@property (nonatomic,copy) NSString *centerStr;
@property (nonatomic,assign) int type;//cell三种类型，值分别为0，1，2
@property (nonatomic,copy) NSString *selectStr;//调用函数，对于type2,是editButton处理事件，对于type3,是点击整个cell事件。
@end
