//
//  AnyOfficeUALogoutOption.h
//  
//
//  Created by mail on 16/6/20.
//
//

#import <Foundation/Foundation.h>
@protocol LoginDelegate;

@interface AnyOfficeUALogoutOption : NSObject

@property (nonatomic,assign)BOOL isBackground;
@property (nonatomic,assign)BOOL isCleanSession;
@property (nonatomic,assign)id<LoginDelegate> loginDelegate;

@end
