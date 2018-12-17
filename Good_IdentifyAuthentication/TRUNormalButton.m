//
//  TRUNormalButton.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/10/20.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUNormalButton.h"
#define IWTabBarButtonImageRatio 0.6
#define IWTabBarButtonImageHRatio 0.3
@implementation TRUNormalButton

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW=contentRect.size.width*(IWTabBarButtonImageHRatio);
    CGFloat imageH=contentRect.size.height*(IWTabBarButtonImageHRatio +0.1);
    CGFloat imageX = contentRect.size.width * (1-IWTabBarButtonImageHRatio)/2.f;
    CGFloat imageY = contentRect.size.height * 0.2;
    return CGRectMake(imageX, imageY, imageW , imageH);
}
//内部文字的frame
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleY = contentRect.size.height*IWTabBarButtonImageRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height-titleY;
    return CGRectMake(0, titleY, titleW, titleH);
}

-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title image:(NSString *)imagestr andButtonClickEvent:(OnNormalButtonClick)event
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:imagestr] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _homeBlock0xx = event;
    }
    return self;
}


-(void)onButtonClick:(TRUNormalButton *)sender
{
    //YCLog(@"%@", sender);
    __weak typeof(self) myself = self;
    _homeBlock0xx(myself);
}

@end
