//
//  TRUApplicationTopView.h
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/27.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRUApplicationViewController.h"

@class TRUHomeButton;
@class TRUOtherButton;

@interface TRUApplicationTopView : UIView
//今日验证
@property(nonatomic,strong)TRUHomeButton *identifyBtn;
//今日验证number
@property(nonatomic,strong)UILabel *identifyLabel;
//当前请求
@property(nonatomic,strong)TRUHomeButton *requestBtn;
//当前请求number
@property(nonatomic,strong)UILabel *requestLabel;
//设备管理
@property(nonatomic,strong)TRUHomeButton *deviceManagerBtn;
//当前请求number
@property(nonatomic,strong)UILabel *deviceLabel;
//用户协议
@property(nonatomic,strong)TRUHomeButton *UseragreementBtn;
//大图
@property(nonatomic,strong)UIImageView *BigImageview;

//查询
@property(nonatomic,strong)TRUHomeButton *searchBtn;
//消息
@property(nonatomic,strong)TRUHomeButton *newsBtn;


@property(nonatomic,strong)UIImageView *requestImgview;


@property (copy, nonatomic) void(^detailPushVC)();


@property(nonatomic, strong)TRUApplicationViewController *MainVc;




-(void)bigViewsHidden:(float)alphaA;



@end
