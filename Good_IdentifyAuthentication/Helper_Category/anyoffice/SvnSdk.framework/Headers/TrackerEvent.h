//
//  TrackerEvent.h
//  anyofficesdk
//
//  Created by kf1 on 15-8-27.
//  Copyright (c) 2015年 pangqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackerEvent : NSObject

@property (nonatomic, retain) NSMutableDictionary* mDict;

-(void) initWithCategory:(NSString*)category action:(NSString *)action label:(NSString*)label operation:(NSDictionary*)operation;

-(NSString*) getString;
@end
