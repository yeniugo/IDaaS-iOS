//
//  AnyOfficeWaterMarkManager.h
//  
//
//  Created by yWX334266 on 16/7/4.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WaterMarkViewStyle) {
    WaterMarkViewStyleNone = 0,
    WaterMarkViewStyleNormal,
    WaterMarkViewStyleSnow,
    WaterMarkViewStyleFast,
    WaterMarkViewStyleCount
};

@interface AnyOfficeWaterMarkOption : NSObject

@property(nonatomic,retain)NSString *text;/*水印文字内容*/
@property(nonatomic,retain)UIFont *textFont;/*水印字体*/
@property(nonatomic,assign)CGFloat textAlpha;/*水印文字透明度*/
@property(nonatomic,retain)UIColor *textColor;/*水印文字颜色*/
@property(nonatomic,assign)WaterMarkViewStyle style;/*水印风格*/
@property(nonatomic,assign)BOOL canAnimation;/*水印文字是否动画展示*/

@end

@interface AnyOfficeWaterMarkManager : NSObject

+(AnyOfficeWaterMarkManager*)getInstance;

/*水印初始化函数，调用该接口初始化，并显示水印*/
- (void)showWaterMarkWithOption:(AnyOfficeWaterMarkOption *)option;

/*隐藏水印*/
- (void)hideWaterMark;

/*显示水印*/
- (void)showWaterMark;

/*************************************************/
- (void)showWaterMarkInnerIsWindowChange:(BOOL)isWindowChange;
- (BOOL)shouldShowWaterMarks;
- (BOOL)shouldHideWaterMarkForTheMoment;
- (void)hideWaterMarkForTheMoment;
- (void)resumeWaterMark;


@end

