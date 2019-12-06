//
//  TRUMineMenuView.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/27.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUMineMenuView.h"

@implementation TRUMineMenuView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self customUI];
        
    }
    return self;
}

-(void)customUI{
    //六个按钮
    //划线 四横一竖
    
    CGFloat gapH = 0;
    if (SCREENW == 320) {
        gapH = 50;
        
    }else if(SCREENW == 375){
        gapH = 75;
    }else{
        gapH = 90;
    }
    
    UILabel *linelabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 1.f)];
    linelabel2.backgroundColor = RGBCOLOR(230, 230, 230);
    [self addSubview:linelabel2];
    
    UILabel *linelabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, gapH*1 , SCREENW, 1.f)];
    linelabel3.backgroundColor = RGBCOLOR(230, 230, 230);
    [self addSubview:linelabel3];
    
    UILabel *linelabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0, gapH*2, SCREENW, 1.f)];
    linelabel4.backgroundColor = RGBCOLOR(230, 230, 230);
    [self addSubview:linelabel4];
    
    UILabel *linelabel5 = [[UILabel alloc] initWithFrame:CGRectMake(0, gapH*3 - 1, SCREENW, 1.f)];
    linelabel5.backgroundColor = RGBCOLOR(230, 230, 230);
    [self addSubview:linelabel5];
    //一竖
    UILabel *linelabel6 = [[UILabel alloc] initWithFrame:CGRectMake(SCREENW/2.f, 0, 1.f, gapH*3)];
    linelabel6.backgroundColor = RGBCOLOR(230, 230, 230);
    [self addSubview:linelabel6];
    
}

@end
