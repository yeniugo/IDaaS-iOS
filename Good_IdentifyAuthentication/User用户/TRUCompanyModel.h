//
//  TRUCompanyModel.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2018/1/19.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRUCompanyModel : NSObject


/** 应用管理员id */
@property (nonatomic, copy) NSString *spid;
/** 服务方的名称 */
@property (nonatomic, copy) NSString *spname;
/** cims的地址 */
@property (nonatomic, copy) NSString *cims_server_url;
/** 图标名称 */
@property (nonatomic, copy) NSString *icon_url;
/** 激活方式 */
@property (nonatomic, copy) NSString *activation_mode;
/** Logo地址 */
@property (nonatomic, copy) NSString *logo_url;
/** 公司简介 */
@property (nonatomic, copy) NSString *desc;
/** 用户协议地址 */
@property (nonatomic, copy) NSString *user_agreement_url;
/** 开机启动图片地址 */
@property (nonatomic, copy) NSString *start_up_img_url;
/** 公司电话 */
@property (nonatomic, copy) NSString *telephone;
/** 公司官网 */
@property (nonatomic, copy) NSString *website;
/** 自定义软件名称 */
@property (nonatomic, copy) NSString *software_name;


+ (instancetype)modelWithDic:(NSDictionary *)dic;
@end
