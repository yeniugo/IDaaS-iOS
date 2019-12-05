//
//  MyTabBarButton.m
//  lottie_jsonTest
//
//  Created by zyc on 2017/10/17.
//  Copyright © 2017年 zyc. All rights reserved.
//
 
//封装button
#define IWTabBarButtonImageRatio 0.55
#import "MyTabBarButton.h"

@interface MyTabBarButton()

@end

@implementation MyTabBarButton

//内部文字的frame
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleY = contentRect.size.height*IWTabBarButtonImageRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height-titleY;
    return CGRectMake(0, titleY , titleW, titleH);
}
//设置item
-(void)setItem:(UITabBarItem *)item{
    _item = item;
    //设置 文字
    [self setTitle:self.item.title forState:UIControlStateNormal];
}


-(id)initWithFrame:(CGRect)frame{
    
    if(self=[super initWithFrame:frame]){
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        [self setTitleColor:RGBCOLOR(102, 102, 102) forState:UIControlStateNormal];
        [self setTitleColor:DefaultGreenColor forState:UIControlStateSelected];
        
    }//选中状态
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat imageX;
    CGFloat imageY;
    CGFloat imageW;
    CGFloat imageH;
    imageW = self.imageView.image.size.width;
    imageH = self.imageView.image.size.height;
    imageX = (self.bounds.size.width - imageW)/2;
    imageY = 6;
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
}

@end
