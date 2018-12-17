//
//  MyTabBar.m
//  lottie_jsonTest
//
//  Created by zyc on 2017/10/16.
//  Copyright © 2017年 zyc. All rights reserved.
//
 
#import "MyTabBar.h"
#import "MyTabBarButton.h"
#import "TRUButton.h"
#import <Lottie/Lottie.h>

#define IWTabBarButtonLotImageRatio 0.6

@interface MyTabBar()
@property(nonatomic,strong)NSMutableArray *tabBarButtons;
@property(nonatomic,weak)MyTabBarButton *selectedButton;

@property(nonatomic,strong)NSMutableArray *viewsArr;
@property(nonatomic,weak)LOTAnimationView *selectedview;

@property(nonatomic,strong)TRUButton *scanButton;
@property(nonatomic,strong)UIImageView *bgImgView;
 
@end
@implementation MyTabBar
-(NSMutableArray *)tabBarButtons{
    if(_tabBarButtons == nil){
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}
-(NSMutableArray *)viewsArr{
    if (_viewsArr == nil) {
        _viewsArr = [NSMutableArray array];
    }
    return _viewsArr;
}
-(instancetype)init{
    if (self = [super init]) {
        [self customScanButton];
    }
    return self;
}

-(void)customScanButton{
    _scanButton = [TRUButton buttonWithType:UIButtonTypeCustom];
    [_scanButton setImage:[UIImage imageNamed:@"scanlogin_normal"] forState:UIControlStateNormal];
    [_scanButton setImage:[UIImage imageNamed:@"scanlogin_selected"] forState:UIControlStateHighlighted];
    [_scanButton setTitle:@"扫一扫" forState:UIControlStateNormal];
    [_scanButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_scanButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _scanButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [_scanButton addTarget:self action:@selector(scanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
   
    UIImage *img = [UIImage imageNamed:@"tabbarbg"];
    CGFloat tw = [UIScreen mainScreen].bounds.size.width;
    CGFloat iw = img.size.width;
    if (tw > iw) {
        CGFloat th = tw / iw * img.size.height;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(tw, th), NO, [UIScreen mainScreen].scale);
        [img drawInRect:CGRectMake(0, 0, tw, th)];
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }

    _bgImgView = [[UIImageView alloc] init];
    _bgImgView.contentMode = UIViewContentModeCenter;
    _bgImgView.image = img;
    _bgImgView.userInteractionEnabled = YES;
    
    [self addSubview:_bgImgView];
    [self addSubview:_scanButton];
}


- (void)scanButtonClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(scanQRButtonClick)]) {
        [self.delegate scanQRButtonClick];
    }
}

-(void)addTabBarButtonWithItem:(UITabBarItem *)item{
    
    //1、创建按钮 创建LOTAnimationView
    
    NSString *jsonStr;
    NSInteger TagNum;
    if ([item.title isEqualToString:@"应用"]){
        TagNum = 100;
        jsonStr = @"tabbardata01.json";
    }else if ([item.title isEqualToString:@"动态口令"]){
        TagNum = 101;
        jsonStr = @"tabbardata02.json";
    }else if ([item.title isEqualToString:@"生物信息"]){
        TagNum = 102;
        jsonStr = @"tabbardata03.json";
    }else{
        TagNum = 103;
        jsonStr = @"tabbardata04.json";
    }
    LOTAnimationView *aniView = [LOTAnimationView animationNamed:jsonStr];
    aniView.tag = TagNum;
    
    if (aniView.tag == 100) {
        _selectedview = aniView;
    }
    
    [self addSubview:aniView];
    
    
    MyTabBarButton *button=[[MyTabBarButton alloc]init];
    [self addSubview:button];
    
    //添加按钮到数组中
    [self.viewsArr addObject:aniView];
    [self.tabBarButtons addObject:button];
    
    //2、设置数据
    button.item=item;
    
    //3、监听按钮点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    //4、默认选中第零个
    if(self.tabBarButtons.count==1){
        
        [_selectedview play];
        [self buttonClick:button];
    }
    
    
}

//监听按钮点击
-(void)buttonClick:(MyTabBarButton *)button{
   //通知代理
    if([self.delegate respondsToSelector:@selector(tabBar:didselectedButtonFrom:to:)]){
        [self.delegate tabBar:self didselectedButtonFrom:(int )self.selectedButton.tag to:(int)button.tag];
    }
    self.selectedButton.selected=NO;
    button.selected=YES;
    self.selectedButton=button;
    
    [self.selectedview stop];
    
    for (LOTAnimationView *kview in _viewsArr) {
        if (kview.tag == 100 +button.tag) {
            self.selectedview = kview;
        }
    }
    [self.selectedview play];
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat buttonW = self.frame.size.width/(self.tabBarButtons.count +1);
    
    self.bgImgView.frame = CGRectMake(0, -20.f, self.frame.size.width, self.frame.size.height);
    
    self.scanButton.frame = CGRectMake(2 *buttonW, -self.frame.size.height * 0.6f +1, buttonW, self.frame.size.height * 1.5f);
    
    CGFloat buttonH = self.frame.size.height;
    
    CGFloat buttonY = 1;
    
    for(int index = 0;index<self.tabBarButtons.count;index++){
        
        CGFloat buttonX = 0.0;
        if (index <= 1) {
            buttonX = index*buttonW;
        }else{
            buttonX = (index +1)*buttonW;
        }
        
        LOTAnimationView *lotview = self.viewsArr[index];
        
        CGFloat lotviewW = 0;
        CGFloat lotviewH = 0;
        if (index == 1) {
            lotviewW = 41;
            lotviewH = 32;
        }else{
            lotviewW = 34;
            lotviewH = 30;
        }
        lotview.frame = CGRectMake(buttonX +(buttonW -lotviewW)/2.f, buttonY, lotviewW, lotviewH);
        MyTabBarButton *button = self.tabBarButtons[index];
        button.frame=CGRectMake(buttonX, buttonY, buttonW, buttonH);
        button.tag=index;
        
    }
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        
    }
    if (self.hidden || self.alpha <= 0.01 || !self.userInteractionEnabled){
        return nil;
    }
    CGPoint btnP = [self.scanButton convertPoint:point fromView:self];
    if ([self.scanButton pointInside:btnP withEvent:event]) {
        return self.scanButton;
    }
    
    return [super hitTest:point withEvent:event];
    
}

//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//    
//    if (CGRectContainsPoint(self.frame, point)) {
//        YCLog(@"self.frame");
//    }
//    if (CGRectContainsPoint(self.scanButton.frame, point)) {
//        YCLog(@"scanButton");
//    }
//    if (CGRectContainsRect(self.frame, self.scanButton.frame)) {
//        YCLog(@"在不在");
//    }else{
//        YCLog(@"真不在");
//    }
//    return NO;
//}
//

@end
