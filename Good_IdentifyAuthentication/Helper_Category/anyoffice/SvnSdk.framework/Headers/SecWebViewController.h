//
//  SecWebViewController.h
//  anyofficesdk
//
//  Created by num1 on 16-09-01.
//  Copyright (c) 2016年 fanjiepeng 2016-09-01. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    /**
     * 用户手动关闭webapp。
     */
    WEBAPP_CLOSE_BY_USER = 0,
    
    
    /**
     * webapp通过代码自动关闭。
     */
    WEBAPP_CLOSE_BY_CODE = 1
    
    
}WEBAPP_CLOSE_TYPE;


@protocol WebAppDidFinishCloseDelegate <NSObject>

-(void)webAppDidFinishClose:(WEBAPP_CLOSE_TYPE)type;

@end


@interface SecWebViewController : UIViewController
@property (nonatomic,assign) id<WebAppDidFinishCloseDelegate>delegate;
@property (nonatomic, retain) NSURL *originUrl;
@property (nonatomic, copy) NSString *webAppName;


- (id)initWithURL:(NSURL*)url topTitle:(NSString *)title;
- (id)initWithURL:(NSURL*)url topTitle:(NSString *)title ssoFlag:(BOOL)isSingleSignOn;

-(void)setURLBarHidden:(BOOL)hidden;
-(void)setDidFinishCloseWebappDelegate:(id<WebAppDidFinishCloseDelegate>)delegate;


-(void)showSecWebViewConttroller;
-(void)dismissSecWebViewConttroller;

-(BOOL)registerShareToWeChatAppID:(NSString *)appID;
-(BOOL)setSharePlatformDomain:(NSString *)domain;

-(void)setNavigationBarBackgroundColor:(UIColor *)color;
-(void)setNavigationBarTitleColor:(UIColor *)color;

@end
