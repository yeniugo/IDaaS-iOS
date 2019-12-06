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
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    
    self.backgroundColor = self.bgColor;
    UIImageView *bgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 2)];
    [self addSubview:bgview];
    bgview.backgroundColor = self.bgColor;
    
    UIImageView *bgview2 = [[UIImageView alloc] initWithFrame:CGRectMake(rect.size.width - 1, 0, 2, rect.size.height)];
    [self addSubview:bgview2];
    bgview2.backgroundColor = self.bgColor;
    
    //已有的text，要去除
    if (!_isfirst) {
        _isTextNumer = _isImgNumer = 0;
        //执行动画，让密码动态消失
        _isTwoTextNumer = 0;
        if (textdissTimer) {
            [textdissTimer invalidate];
            textdissTimer = nil;
        }
        textdissTimer = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(textLabelAnimationRunDown) userInfo:nil repeats:YES];
        [textdissTimer fire];
        
    }else{
        [self AnimationStart:rect isvoice:_isVoice];
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
    if (isVoice) {
        gapW = _spacing * (float)(self.text.length +1);
        width = (rect.size.width -gapW - 10)/(float)self.text.length;
        height = rect.size.height;
    }else{
        gapW = _spacing * (float)(self.text.length +1);
        width = (rect.size.width -gapW)/(float)self.text.length;
        height = rect.size.height;
    }
    
    
    if (isVoice) {//声纹页面
        for (int index = 0; index <self.text.length; index++) {
            //背景
            UIImageView *imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_text_bg.png"]];
            if (index <4) {
                imgview.frame = CGRectMake(_spacing + (_spacing +width)*index, 0, width, height);
            }else{
                imgview.frame = CGRectMake(5+_spacing + (_spacing +width)*index, 0, width, height);
            }
            
            [_imgViewsArr addObject:imgview];
            //验证码/密码
            //截取字符串中的每一个字符
            NSString *charStr = [_text substringWithRange:NSMakeRange(index, 1)];
            UILabel *label = [[UILabel alloc] init];
            if (index <4) {
                label.frame = CGRectMake(_spacing + (_spacing +width)*index + 1, 40, width - 2, height );
            }else{
                label.frame = CGRectMake(5+_spacing + (_spacing +width)*index + 1, 40, width - 2, height );
            }
            label.text = charStr;
            label.textColor = DefaultColor;
            label.font = self.textFont;
            label.textAlignment = NSTextAlignmentCenter;
            [_textLabelsArr addObject:label];
        }
    }else{
        for (int index = 0; index <self.text.length; index++) {
            //背景
            UIImageView *imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_text_bg.png"]];
            imgview.frame = CGRectMake(_spacing + (_spacing +width)*index, 0, width, height);
            [_imgViewsArr addObject:imgview];
            
            //验证码/密码
            //截取字符串中的每一个字符
            NSString *charStr = [_text substringWithRange:NSMakeRange(index, 1)];
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(_spacing + (_spacing +width)*index + 1, 40, width - 2, height );
            label.text = charStr;
            label.textColor = DefaultColor;
            label.font = self.textFont;
            label.textAlignment = NSTextAlignmentCenter;
            [_textLabelsArr addObject:label];
        }
    }
    //使用NSTimer模拟延迟执行animation--imageview
    
    imgTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(imgviewAnimationRunUp) userInfo:nil repeats:YES];
    [imgTimer fire];
}
-(void)AnimationEnd{
    //给密码labelArr中的label重新赋值
    for (int index = 0; index <self.text.length; index++) {
        NSString *charStr = [_text substringWithRange:NSMakeRange(index, 1)];
        UILabel *label = _textLabelsArr[index];
        //调整label 的y值
        label.y = 40;
        label.text = charStr;
    }
}

-(void)imgviewAnimationRunUp{
    _isImgNumer++;
    
    if (_isImgNumer <= _text.length) {
        UIImageView *imgview = _imgViewsArr[_isImgNumer -1];
        [self addSubview:imgview];
        [self appendAnimation:imgview];
    }else{
        //取消timer
        [imgTimer invalidate];
        imgTimer = nil;
        //使用NSTimer模拟延迟执行animation--textlabel
        textTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(textLabelAnimationRunUp) userInfo:nil repeats:YES];
        [textTimer fire];
    }
}

-(void)imgviewAnimationRunDown{
    _isImgNumer++;
    
    if (_isImgNumer <= _text.length) {
        UIImageView *imgview = _imgViewsArr[_isImgNumer -1];
        [self addSubview:imgview];
        [self appendAnimation:imgview];
        
    }else{
        //取消timer
        [imgDissTimer invalidate];
        imgDissTimer = nil;
        
        [self AnimationEnd];
        
        textTwoTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(textLabelAnimationRunUpTwo) userInfo:nil repeats:YES];
        [textTwoTimer fire];
        
    }
}
//text-diss
-(void)textLabelAnimationRunDown{
    _isTextNumer++;
    
    if (_isTextNumer <= _text.length) {
        UILabel *label = _textLabelsArr[_isTextNumer -1];
        label.y = 0;
        [self addSubview:label];
        [self LableEndAnimation:label];
        if (_isTextNumer == 6) {
            imgDissTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(imgviewAnimationRunDown) userInfo:nil repeats:YES];
            [imgDissTimer fire];
        }
    }else{
        for (id iview in self.subviews) {
            if ([iview isKindOfClass:[UILabel class]]) {
                [iview removeFromSuperview];
            }
        }
        [textdissTimer invalidate];
        textdissTimer = nil;
        
    }
}

-(void)textLabelAnimationRunUp{
    _isTextNumer++;
    
    if (_isTextNumer <= _text.length) {
        UILabel *label = _textLabelsArr[_isTextNumer -1];
        [self addSubview:label];
        [self LableBeginAnimation:label];
    }else{
        [textTimer invalidate];
        textTimer = nil;
    }
}

-(void)textLabelAnimationRunUpTwo{
    _isTwoTextNumer++;
    if (_isTwoTextNumer <= _textLabelsArr.count) {
        UILabel *label = _textLabelsArr[_isTwoTextNumer -1];
        [self addSubview:label];
        [self LableBeginAnimation:label];
    }else{
        [textTwoTimer invalidate];
        textTwoTimer = nil;
    }
}


//UIImageView开始动画
-(void)appendAnimation:(UIImageView *)bgView{
    CABasicAnimation *animation = [[CABasicAnimation alloc] init];
    animation.keyPath = @"transform.rotation.x";
    
    animation.beginTime = 0.0;
    animation.fromValue = [NSNumber numberWithFloat:M_PI/2.f];
    animation.toValue = [NSNumber numberWithFloat:0.0];
    animation.duration = 0.5;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [bgView.layer addAnimation:animation forKey:@"rotation_append"];
    
}
//UIImageView结束动画
-(void)dissAnimation:(UIImageView *)bgview{
    CABasicAnimation *animation = [[CABasicAnimation alloc] init];
    animation.keyPath = @"transform.rotation.x";
    animation.beginTime = 0.0;
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:M_PI/2.f];
    animation.duration = 0.5;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [bgview.layer addAnimation:animation forKey:@"rotation_diss"];
}

//UILabel开始动画
-(void)LableBeginAnimation:(UILabel *)label{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];///.y的话就向下移动。
    //是否设置fromValue，可以改变展示效果
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:-40.0f];
    animation.duration = 0.3;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    animation.fillMode = kCAFillModeForwards;
    [label.layer addAnimation:animation forKey:@"moveBegin"];
}
//UILabel结束动画
-(void)LableEndAnimation:(UILabel *)label{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];///.y的话就向下移动。
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:-40.0f];
    animation.duration = 0.3;
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    animation.repeatCount = 1;
    animation.fillMode = kCAFillModeForwards;
    [label.layer addAnimation:animation forKey:@"moveEnd"];
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
