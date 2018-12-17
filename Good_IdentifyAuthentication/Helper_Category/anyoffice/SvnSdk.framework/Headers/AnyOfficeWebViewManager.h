//
//  AnyOfficeWebViewManager.h
//  AnyOffice
//
//  Created by kf1 on 14-1-10.
//
//

#import <Foundation/Foundation.h>
#import "AnyOfficeWebView.h"
#include "anyoffice_login.h"
#include "anyoffice_sdkconfig.h"

@interface AnyOfficeWebViewManager : NSObject


+ (void)setGatwayPolicyToWebView:(AnyOfficeWebView *)webView;

+ (void)loadSso:(NSString *)url withWebView:(AnyOfficeWebView *)webview;//�����¼�ӿ�

+ (void)loadUrl:(NSString *)url withWebView:(AnyOfficeWebView *)webView;//�ǵ����¼�ӿ�

@end
