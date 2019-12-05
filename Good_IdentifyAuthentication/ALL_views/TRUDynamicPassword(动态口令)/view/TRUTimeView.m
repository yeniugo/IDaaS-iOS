//
//  TRUTimeView.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/10/13.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUTimeView.h"

@interface TRUTimeView ()

@property (nonatomic, weak) NSTimer *timer;

@end


@implementation TRUTimeView
{
    NSInteger timeNum;
    UILabel *txtlabel2;
}

-(void)startCountWithTime:(NSInteger)timeNumber{
    [self stopCount];
    NSString *txt = [NSString stringWithFormat:@"%zdS", timeNumber];
    timeNum = timeNumber;
    txtlabel2.text = txt;
}

-(void)stopCount{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)dealCount{
    timeNum -- ;
    
    if (timeNum >= 0) {
        NSString *txt = [NSString stringWithFormat:@"%zdS", timeNum];
        txtlabel2.text = txt;
    }else{
        [self stopCount];
    }
}


-(instancetype)initWithFrame:(CGRect)frame withTimelength:(NSInteger)timelength{
    if (self = [super initWithFrame:frame]) {
        timeNum = timelength;
        [self customUIWithTimelength:timelength];
    }
    return self;
}

-(void)customUIWithTimelength:(NSInteger)timelength{
    CGFloat txt1W = 107;
    CGFloat txt2W = 25;
    CGFloat txtH = 25;
    UILabel *txtlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, txt1W, txtH)];
    txtlabel1.text = @"这条动态密码将在";
    txtlabel1.textColor = RGBCOLOR(107, 108, 109);
    
    txtlabel1.font = [UIFont systemFontOfSize:13];
    
    
    txtlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(txt1W, 0, txt2W, txtH)];
    txtlabel2.text = @"30S";
    txtlabel2.textColor = DefaultColor;
    txtlabel2.font = [UIFont systemFontOfSize:13];
    txtlabel2.textAlignment = NSTextAlignmentCenter;
    
    UILabel *txtlabel3 = [[UILabel alloc] initWithFrame:CGRectMake(txt1W +txt2W, 0, 40, txtH)];
    txtlabel3.text = @"后失效";
    txtlabel3.textColor = RGBCOLOR(107, 108, 109);
    txtlabel3.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:txtlabel1];
    [self addSubview:txtlabel2];
    [self addSubview:txtlabel3];
}


@end
