//
//  TRUConst.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2016/12/2.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#ifndef TRUMacros_h
#define TRUMacros_h


//#define ENV_DEBUG

#ifdef DEBUG
# define YCLog(fmt, ...) NSLog((@"[函数名:%s]" "[行号:%d]" fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define YCLog(...);
#endif


#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW [UIScreen mainScreen].bounds.size.width

#define lineDefaultColor  [UIColor colorWithRed:189.0 / 255 green:222.0 / 255 blue:204.0 / 255 alpha:1.0]

#define ViewDefaultBgColor  [UIColor colorWithRed:247.0 / 255 green:249.0 / 255 blue:250.0 / 255 alpha:1.0]
#define DefaultColor  [UIColor colorWithRed:32.0 / 255 green:144.0 / 255 blue:54.0 / 255 alpha:1.0]

#define TRUPUSHNOTIFICATION  @"TRUPUSHNOTIFICATIONKEY"


#define UIColorHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <  568.0)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//#define PixelHeightRatio6P (SCREEN_HEIGHT / 2208.0)
//#define PointHeightRatio6P (SCREEN_HEIGHT / 736.0)
//#define PixelWidthRatio6P (SCREEN_WIDTH / 1242.0)
//#define PointWidthRatio6P (SCREEN_WIDTH / 414.0)


#define PixelHeightRatio6P (SCREEN_HEIGHT / 2208.0)
#define PointHeightRatio6P (SCREEN_HEIGHT / 736.0)
#define PixelWidthRatio6P (SCREEN_WIDTH / 1242.0)
#define PointWidthRatio6P (SCREEN_WIDTH / 414.0)
//本次设计按照6的尺寸设计，所以以6作为标准
#define PointHeightRatio6 (SCREEN_HEIGHT / 750.0)
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//#define PixelHeightRatio6 (SCREEN_HEIGHT / 1334.0)
//#define PointHeightRatio6 (SCREEN_HEIGHT / 677.0)
//#define PixelWidthRatio6 (SCREEN_WIDTH / 750.0)
//#define PointWidthRatio6 (SCREEN_WIDTH / 375.0)


#define	APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_VERSION_EQUAL_TO(v) ([APP_VERSION compare:v options:NSNumericSearch] == NSOrderedSame)
#define APP_VERSION_GREATER_THAN(v) ([APP_VERSION compare:v options:NSNumericSearch] == NSOrderedDescending)
#define APP_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([APP_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define APP_VERSION_LESS_THAN(v) ([APP_VERSION compare:v options:NSNumericSearch] == NSOrderedAscending)
#define APP_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([APP_VERSION compare:v options:NSNumericSearch] != NSOrderedDescending)

#define SYSTEM_VERSION [[UIDevice currentDevice] systemVersion]
#define SYSTEM_VERSION_EQUAL_TO(v) ([SYSTEM_VERSION compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([SYSTEM_VERSION compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([SYSTEM_VERSION compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <  568.0)
#define IS_IPHONE_5         (IS_IPHONE && fabs((double)SCREEN_MAX_LENGTH - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6         (IS_IPHONE && fabs((double)SCREEN_MAX_LENGTH - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6P        (IS_IPHONE && fabs((double)SCREEN_MAX_LENGTH - (double)736) < DBL_EPSILON)

#define LAUNCH_IMAGE_IPHONE4  @"LaunchImage-700"
#define LAUNCH_IMAGE_IPHONE5  @"LaunchImage-700-568h"
#define LAUNCH_IMAGE_IPHONE6  @"LaunchImage-800-667h"
#define LAUNCH_IMAGE_IPHONE6P @"LaunchImage-800-Portrait-736h"


#define TRUUserInfoID @"993d3d1ide762af60e2f13387ad1user"

#define TRUShowLoginAuthViewKey @"TRUShowLoginAuthViewKey"

#define TRUEnterBackgroundKey @"TRUEnterBackgroundKey"

//#define DEBUGENV @"DEBUGENV"//测试环境

#endif /* TRUConst_h */
