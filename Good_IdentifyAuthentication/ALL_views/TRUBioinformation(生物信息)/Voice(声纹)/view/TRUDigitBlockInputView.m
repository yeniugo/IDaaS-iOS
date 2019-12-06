//
//  TRUDigitBlockInputView.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/5.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUDigitBlockInputView.h"


@interface TRUDigitBlockInputView ()<UIKeyInput>
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, strong) NSMutableString *inputText;
@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, strong) NSMutableArray *imageViews;
@end

static const CGFloat kBlockWidth = 40;
static const CGFloat kBlockHeight = 60;
static const CGFloat kBlockSpace = 5;
@implementation TRUDigitBlockInputView
@synthesize info;
- (instancetype)initWithCount:(NSUInteger)count {
    self = [super init];
    if (self) {
        _count = count;
        _editable = YES;
        _inputText = [[NSMutableString alloc] init];
        _labels = [[NSMutableArray alloc] initWithCapacity:count];
        _imageViews = [[NSMutableArray alloc] initWithCapacity:count];
        
        for (NSUInteger i = 0; i < count; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage imageNamed:@"初始化-密码输入框"];
            [_imageViews addObject:imageView];
            [self addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:25];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor blackColor];
            [_labels addObject:label];
            [self addSubview:label];
        }
        [self sizeToFit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    CGFloat left = (CGRectGetWidth(self.bounds) - kBlockWidth * PointWidthRatio6P * self.count - kBlockSpace * (self.count - 1)) / 2.0;
    CGFloat top = (CGRectGetHeight(self.bounds) - kBlockHeight * PointHeightRatio6P) / 2.0;
    
    for (NSUInteger i = 0; i < self.count; i++) {
        UIImageView *imageView = self.imageViews[i];
        UILabel *label = self.labels[i];
        
        imageView.frame = CGRectMake(left, top, kBlockWidth * PointWidthRatio6P, kBlockHeight * PointHeightRatio6P);
        label.frame = imageView.frame;
        
        left = CGRectGetMaxX(imageView.frame) + kBlockSpace;
    }
}

- (void)sizeToFit {
    self.bounds = CGRectMake(0, 0, kBlockWidth * PointWidthRatio6P * self.count + kBlockSpace * (self.count - 1), kBlockHeight * PointHeightRatio6P);
}

- (BOOL)canBecomeFirstResponder {
    return self.editable;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
}

- (NSString *)info {
    return [self.inputText copy];
}

- (void)setInfo:(NSString *)ainfo {
    info = [ainfo copy];
    self.inputText = [[NSMutableString alloc] initWithString:ainfo];
    [self updateLabelText];
}

#pragma mark - Private methods

- (void)updateLabelText {
    [self.labels makeObjectsPerformSelector:@selector(setText:) withObject:nil];
    for (NSUInteger i = 0; i < MIN(self.inputText.length, self.count); i++) {
        UILabel *label = self.labels[i];
        label.text = [self.inputText substringWithRange:NSMakeRange(i, 1)];
    }
}

#pragma mark - UIKeyInput

- (BOOL)hasText {
    return self.inputText.length > 0;
}

- (void)insertText:(NSString *)text {
    if (text == nil) {
        return;
    }
    
    if ([text isEqualToString:@"\n"]) {
        !self.returnButtonAction ? : self.returnButtonAction(self);
        return;
    }
    
    if ([text isEqualToString:@"0"] || (text.integerValue > 0 && text.integerValue < 10)) {
        if (self.inputText.length < self.count) {
            [self.inputText appendString:text];
            [self updateLabelText];
        }
    }
}

- (void)deleteBackward {
    if (self.inputText.length > 0) {
        [self.inputText deleteCharactersInRange:NSMakeRange(self.inputText.length - 1, 1)];
        [self updateLabelText];
    }
}

#pragma mark - UITextInputTraits

- (UIReturnKeyType)returnKeyType {
    return UIReturnKeyGo;
}

- (UIKeyboardAppearance)keyboardAppearance {
    return UIKeyboardAppearanceDark;
}

- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumbersAndPunctuation;
}

@end
