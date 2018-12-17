//
//  Tracker.h
//  anyofficesdk
//
//  Created by kf1 on 15-8-27.
//  Copyright (c) 2015年 pangqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackerEvent.h"

@interface Tracker : NSObject
@property int type;
@property  (retain)NSString* basic;
@property bool shouldGetUserInfo;

+(Tracker*) getInstance;
+(void) shouldGetUserInfo:(BOOL) getUserInfo;
-(void) send :(TrackerEvent*) event;
-(BOOL) enable;
-(void) getBasicInfo;
@end
