//
//  AnyOfficeAuthenticationOption.h
//  SvnSdk
//
//  Created by l00174413 on 8/1/16.
//  Copyright © 2016 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnyOfficeAuthenticationOption : NSObject

@property NSString* authenticationTitle;

@property BOOL authenticateInBackground;

@property BOOL authenticateUseSSO;

@property NSString* internetGatewayAddress;
@property NSString* intranetGatewayAddress;



@property NSString* username;
@property NSString* password;

@end
