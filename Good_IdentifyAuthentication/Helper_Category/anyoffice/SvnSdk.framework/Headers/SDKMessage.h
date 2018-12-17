//
//  SDKMessage.h
//  anyofficesdk
//
//  Created by SDK_Fanjiepeng on 15/7/30.
//  Copyright (c) 2015年 pangqi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  SDK消息类型：数据升级
 */
#define SDK_MESSAGE_DATA_UPGRADE  1
/**
 * SDK消息定义
 */

@protocol SDKMessageHandlerDelegate;



@interface SDKMessage : NSObject
/**
 * 消息类型
 */
@property  NSInteger* msgCode;
/**
 * 消息参数，当只需要传递一个数值时建议使用此字段。
 */
@property  NSInteger* arg1;
/**
 * 消息参数，当只需要传递一段文本时建议使用此字段。
 */
@property(strong,nonatomic) NSString* arg2;
/**
 * 消息参数，当需要传递复杂数据时建议使用此字段。
 */
@property(strong,nonatomic) NSObject* obj;

-(id)initWithDelegate:(id<SDKMessageHandlerDelegate>)delegate;
-(void)SDKHandleMessage:( SDKMessage *) msg;
@end

@protocol SDKMessageHandlerDelegate <NSObject>
/* 网关登录返回时调用此接口将结果通知上层。*/
-(void)handleMessage:( SDKMessage *) msg;
@end


