//
//  SDKMdm.h
//  anyofficesdk
//
//  Created by kf1 on 15/11/12.
//  Copyright (c) 2015年 pangqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDKMdmDelegate <NSObject>

@optional
// callback
-(void)onReceivedViolation:(NSArray *)resultInfo;

//截屏事件回调
-(NSString *)didReceivedScreenShotEvent:(NSString *)className;

@end

@interface SDKMdm : NSObject

// delegate object
@property (nonatomic, assign) id<SDKMdmDelegate> delegate;

+ (SDKMdm*)getInstance;
+ (void)addScreenShortOb;

//开启截屏审计
-(void)startScreenShotAuditing;

//关闭截屏审计
-(void)stopScreenShotAuditing;




/*Begin modify by fanjiepeng on 2016-05-12,for 工行: SDK防截屏*/
+(UIImage *)convertRootViewToImage;
/*End modify by fanjiepeng on 2016-05-12,for 工行: SDK防截屏*/

/*Begin modify by fanjiepeng on 2016-04-19,for DTS2016040505759*/
//设置当前显示的类名
-(void)setCurViewControllerClassName:(NSString *)className;

//获取当前显示的类名
-(NSString *)getCurViewControllerClassName;
/*End modify by fanjiepeng on 2016-04-19,for DTS2016040505759*/

/*Begin modify by fanjiepeng on 2016-05-20,for 工行: SDK防截屏*/
-(BOOL)isSystemInterface;
-(void)setSystemInterface:(BOOL)status;
/*End modify by fanjiepeng on 2016-05-20,for 工行: SDK防截屏*/

// Set delegate Method
- (void)setMdmCheckCallback:(id<SDKMdmDelegate>)SDKMdmDelegate;

// C
void addCheckResult(int rID, int rPolicy);
void onReceivedViolationToUI();
void addCheckResultDetailType(int rID,int rType);

@end

/*Begin modify by fanjiepeng on 2016-04-19,for DTS2016040505759*/
@interface UIViewController (SDKMdm)

@end
/*End modify by fanjiepeng on 2016-04-19,for DTS2016040505759*/