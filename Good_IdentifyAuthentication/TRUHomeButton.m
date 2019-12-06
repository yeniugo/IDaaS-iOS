//
//  TRUHomeButton.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/27.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUHomeButton.h"
#define IWTabBarButtonImageRatio 0.4
@implementation TRUHomeButton


-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW=contentRect.size.width*(IWTabBarButtonImageRatio - 0.1);
    CGFloat imageH=contentRect.size.height*IWTabBarButtonImageRatio;
    CGFloat imageX = contentRect.size.width * (1-IWTabBarButtonImageRatio +0.1)/2.f;
    return CGRectMake(imageX, 0, imageW , imageH);
}

//内部文字的frame
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleY = contentRect.size.height*IWTabBarButtonImageRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height-titleY;
    return CGRectMake(0, titleY, titleW, titleH);
}

-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title state:(UIControlState)state andButtonClickEvent:(OnButtonClick)event
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:state];
        [self setTitleColor:[UIColor blackColor] forState:state];
        [self addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _homeBlock0xx = event;
    }
    return self;
}



-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title image:(NSString *)imagestr andButtonClickEvent:(OnButtonClick)event
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:imagestr] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _homeBlock0xx = event;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame  withButtonClickEvent:(OnButtonClick)event{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _homeBlock0xx = event;
    }
    return self;
    
}

-(instancetype)initWithFrame:(CGRect)frame withUnlineTitle:(NSString *)title UnlineColor:(UIColor *)color andButtonClickEvent:(OnButtonClick)event{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _homeBlock0xx = event;
        [self setTitleColor:color forState:UIControlStateNormal];
        
        //button 折行显示设置
        /*
         NSLineBreakByWordWrapping = 0,         // Wrap at word boundaries, default
         NSLineBreakByCharWrapping,     // Wrap at character boundaries
         NSLineBreakByClipping,     // Simply clip 裁剪从前面到后面显示多余的直接裁剪掉
         
         文字过长 button宽度不够时: 省略号显示位置...
         NSLineBreakByTruncatingHead,   // Truncate at head of line: "...wxyz" 前面显示
         NSLineBreakByTruncatingTail,   // Truncate at tail of line: "abcd..." 后面显示
         NSLineBreakByTruncatingMiddle  // Truncate middle of line:  "ab...yz" 中间显示省略号
         */
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        // you probably want to center it
        self.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
        
        // underline Terms and condidtions
        NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:title];
        
        //设置下划线...
        /*
         NSUnderlineStyleNone                                    = 0x00, 无下划线
         NSUnderlineStyleSingle                                  = 0x01, 单行下划线
         NSUnderlineStyleThick NS_ENUM_AVAILABLE(10_0, 7_0)      = 0x02, 粗的下划线
         NSUnderlineStyleDouble NS_ENUM_AVAILABLE(10_0, 7_0)     = 0x09, 双下划线
         */
        [tncString addAttribute:NSUnderlineStyleAttributeName
                          value:@(NSUnderlineStyleSingle)
                          range:(NSRange){0,[tncString length]}];
        //此时如果设置字体颜色要这样
        [tncString addAttribute:NSForegroundColorAttributeName value:color  range:NSMakeRange(0,[tncString length])];
        
        //设置下划线颜色...
        [tncString addAttribute:NSUnderlineColorAttributeName value:color range:(NSRange){0,[tncString length]}];
        [self setAttributedTitle:tncString forState:UIControlStateNormal];
        
    }
    return self;
    
}

-(void)onButtonClick:(TRUHomeButton *)sender
{
//    YCLog(@"%@", sender);
    __weak typeof(self) myself = self;
    _homeBlock0xx(myself);
}



@end
