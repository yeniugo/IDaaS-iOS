//
//  YCAnimationNumberView.m
//  YCFlopAnimation
//
//  Created by zyc on 2017/11/17.
//  Copyright © 2017年 YC. All rights reserved.
//

#import "YCAnimationNumberView.h"
#import "UIView+FrameExt.h"

@interface YCAnimationNumberView()

@property (nonatomic, strong) NSMutableArray *imgViewsArr;
@property (nonatomic, assign) int isImgNumer;

@property (nonatomic, strong) NSMutableArray *textLabelsArr;
@property (nonatomic, assign) int isTextNumer;
@property (nonatomic, assign) int isTwoTextNumer;
@end
@implementation YCAnimationNumberView
{
    NSTimer *imgTimer;
    NSTimer *textTimer;
    NSTimer *textdissTimer;
    NSTimer *imgDissTimer;
    NSTimer *textTwoTimer;
    BOOL _isfirst;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        UIImageView *bgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 2)];
        [self addSubview:bgview];
        bgview.backgroundColor = ViewDefaultBgColor;
        UIImageView *bgview2 = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 1, 0, 2, frame.size.height)];
        [self addSubview:bgview2];
        bgview2.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(BOOL)checkNumberView{
    int labelNum = 0;
    for (id iview in self.subviews) {
        if ([iview isKindOfClass:[UILabel class]]) {
            labelNum++;
        }
    }
    if (labelNum >0 && labelNum == 6) {
        return YES;
    }else{
        return NO;
    }
}
-(void)drawRect:(CGRect)rect{
    self.backgroundColor = self.bgColor;
    if (_isfirst) {
        if (_textLabelsArr.count >0) {
            for (int index = 0; index <self.text.length; index++) {
                NSString *charStr = [_text substringWithRange:NSMakeRange(index, 1)];
                UILabel *label = _textLabelsArr[index];
                label.text = nil;
                label.text = charStr;
            }
        }else{
            [self AnimationStart:rect isvoice:_isVoice];
            UIImageView *bgview2 = [[UIImageView alloc] initWithFrame:CGRectMake(rect.size.width - 1, 0, 2, rect.size.height)];
            [self addSubview:bgview2];
            bgview2.backgroundColor = [UIColor whiteColor];
            UIImageView *bgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1, rect.size.width, 2)];
            [self addSubview:bgview];
            bgview.backgroundColor = [UIColor whiteColor];
        }
    }else{
        for (int index = 0; index <self.text.length; index++) {
            NSString *charStr = [_text substringWithRange:NSMakeRange(index, 1)];
            UILabel *label = _textLabelsArr[index];
            label.text = nil;
            label.text = charStr;
        }
    }
}



-(void)AnimationStart:(CGRect)rect isvoice:(BOOL)isVoice{
    //初始化
    if (!_imgViewsArr) {
        _imgViewsArr = [NSMutableArray array];
    }
    if (!_textLabelsArr) {
        _textLabelsArr = [NSMutableArray array];
    }
    _isImgNumer = 0;
    _isTextNumer = 0;
    //计算每位验证码/密码的所在区域的宽和高
    float gapW = 0.0;
    float width = 0.0;
    float height = 0.0;
    
    gapW = _spacing * (float)(self.text.length +1);
    width = (rect.size.width -gapW)/(float)self.text.length;
    height = rect.size.height;
    
    for (int index = 0; index <self.text.length; index++) {
        //背景
        //card_text_bg.png
        UIImageView *imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        imgview.frame = CGRectMake(_spacing + (_spacing +width)*index, 0, width, height);
        [self addSubview:imgview];
        
        //验证码/密码
        //截取字符串中的每一个字符
        NSString *charStr = [_text substringWithRange:NSMakeRange(index, 1)];
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(_spacing + (_spacing +width)*index + 1, 0, width - 2, height );
        label.text = nil;
        label.text = charStr;
        label.textColor = RGBCOLOR(73, 158, 40);
        label.font = self.textFont;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [_textLabelsArr addObject:label];
    }
}




//间距
-(void)setSpacing:(CGFloat)spacing{
    _spacing = spacing;
    [self setNeedsDisplay];
}
//赋值
-(void)setNumberStr:(NSString *)numstr isFirst:(BOOL)isFirst{
    _text = numstr;
    _isfirst = isFirst;
    [self setNeedsDisplay];
}
-(void)setText:(NSString *)text{
    _text = text;
    [self setNeedsDisplay];
}
//背景颜色
-(void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    //背景颜色
    self.backgroundColor = _bgColor;
    [self setNeedsDisplay];
}
//font
-(void)setTextFont:(UIFont *)textFont{
    _textFont = textFont;
    [self setNeedsDisplay];
}
//是否是声纹
-(void)setIsVoice:(BOOL)isVoice{
    _isVoice = isVoice;
    [self setNeedsDisplay];
}
@end
