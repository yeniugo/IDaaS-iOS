//
//  DocumentViewController.h
//  anyofficesdk
//
//  Created by ui1 on 14-6-9.
//  Copyright (c) 2014年 pangqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DocumentDelegate <NSObject>

-(void)goBack;

@end

@interface DocumentViewController : UIViewController <UIWebViewDelegate,UIGestureRecognizerDelegate,DocumentDelegate,UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate, UIScrollViewDelegate>
/**
 *  openFile 2打开文件
 *
 *  @param filePath 文件路径
 */
-(void)initFileEnv;
-(void)setFilePath:(NSString *)filePath;
//-(void)openFile:(NSString *)filePath;
-(id)initDocViewWithFilePath:(NSString *)filePath;
-(void)setFileEncodePath:(NSString *)path;
-(void)setSeadyKey:(NSString *)userName withDeiceID:(NSString *)deviceID;

-(id)initDocViewWithFilePath:(NSString *)filePath andDisplayName:(NSString *)displayName;
-(void)setBackButtonHidden:(BOOL)hidden;
/*Begin modify by fanjiepeng on 2016-01-06,for 新增隐藏导航栏接口*/
-(void)setNavigationBarHidden:(BOOL)hidden;
/*End modify by fanjiepeng on 2016-01-06,for 新增隐藏导航栏接口*/

/**
 *  判断是否支持打开后缀为subfix的文件，YES表示支持，NO表示不支持
 *
 *  @param subfix 文件后缀。例如“.ppt”,不去分大小写。
 */
+(BOOL)canOpenThisTypeOfFile:(NSString *)subfix;

/**
 *  设置不支持打开的文件扩展名
 *
 *  @param extensions 文件后缀。例如@[@".ppt",@".word"],不区分大小写。
 */
+(void)setNonsupportFileExtensions:(NSArray *)extensions;

-(void)setNavigationBarBackgroundColor:(UIColor *)color;
-(void)setNavigationBarTitleColor:(UIColor *)color;

@end
