//
//  TRUPersonalSmailModel.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/8/21.
//  Copyright © 2019 zyc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum _PersonalSmaillCellType {
    PersonalSmaillCellNormal  = 0, //头部icon文本加标题加尾部箭头
//    PersonalSmaillCellRightLB,      //头部icon文本加标题加尾部文本箭头
    PersonalSmaillCellRightIcon,    //头部icon文本加标题加尾部图标
    PersonalSmaillCellRightLBwithIcon,  //头部icon文本加标题加尾部图标+文本
    PersonalSmaillCellCenterLB          //居中显示文字
} PersonalSmaillCellType;
@interface TRUPersonalSmailModel : NSObject
@property (nonatomic,assign) PersonalSmaillCellType cellType;
@property (nonatomic,copy) NSString *leftIcon;
@property (nonatomic,copy) NSString *leftStr;
@property (nonatomic,copy) NSString *rightIcon;
@property (nonatomic,copy) NSString *rightStr;
@property (nonatomic,copy) NSString *CenterStr;
@property (nonatomic,assign) BOOL canUpdate;
@property (nonatomic,copy) NSString *disVC;
@property (nonatomic, copy) void (^cellClickBlock)(void);
@end

NS_ASSUME_NONNULL_END
