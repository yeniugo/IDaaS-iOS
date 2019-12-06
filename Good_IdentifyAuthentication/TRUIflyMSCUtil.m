//
//  TRUIflyMSCUtil.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/4/17.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUIflyMSCUtil.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import <iflyMSC/IFlyISVRecognizer.h>

@implementation TRUIflyMSCUtil


/*
 * Used to query or delete the voiceprint model in server
 * @cmd:
 "del": delete model
 "que": query model
 * @authid: user id ,can be @"tianxia" or other;
 * @pwdt: voiceprint type
 1: fixed txt voiceprint code ,like @"我的地盘我做主"
 2: free voiceprint code , user can speek anything,but 5 times
 trainning the speech shall be same
 3: number serial voiceprint code ,like @"98765432" and so on
 * @ptxt: voiceprint txt,only fixed voiceprint and number serial have this,
 in free voiceprint model this param shall be set nil
 * @vid: another voiceprint type model,user can use this to query or delete
 model in server can be @"jakillasdfasdjjjlajlsdfhdfdsadff",totally 32 bits;
 * NOTES:
 when vid is not nil,then the server will judge the vid first
 while the vid is nil, server can still query or delete the voiceprint model
 by other params
 */
//-(BOOL) sendRequest:(NSString*)cmd authid:(NSString *)auth_id  pwdt:(int)pwdt ptxt:(NSString *)ptxt vid:(NSString *)vid err:(int *)err;

+ (BOOL)checkIFlyModel{
    NSString *userid = [TRUUserAPI getUser].userId;
    if (userid == nil || userid.length == 0) {
        return NO;
    }
    NSString *authid = [xindunsdk getCIMSVoiceAuthIDForUser:userid];
    IFlyISVRecognizer *recogizer = [IFlyISVRecognizer sharedInstance];
    int err;
    return [recogizer sendRequest:@"que" authid:authid pwdt:3 ptxt:nil vid:nil err:&err];
}



@end
