//
//  TRUMutableLoginModel.h
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2020/1/7.
//  Copyright © 2020 zyc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRUMutableLoginModel : NSObject

@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *token;
@end

NS_ASSUME_NONNULL_END
