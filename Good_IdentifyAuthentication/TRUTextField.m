//
//  TRUTextField.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/16.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUTextField.h"

@interface TRUTextField()
@property (nonatomic, weak) UIButton *seeOrHideButton;
@property (nonatomic, weak) UIButton *clearButton;
@property (nonatomic, weak) UIView *line;
@end


@implementation TRUTextField
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit{
    
    UIView *rightView = [[UIView alloc] init];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearBtn setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *seeorHideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [seeorHideBtn setImage:[UIImage imageNamed:@"eye_normal"] forState:UIControlStateNormal];
    [seeorHideBtn setImage:[UIImage imageNamed:@"eye_selected"] forState:UIControlStateSelected];
    [seeorHideBtn addTarget:self action:@selector(seeHideButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    seeorHideBtn.hidden = YES;
    [rightView addSubview:self.clearButton = clearBtn];
    [rightView addSubview:self.seeOrHideButton = seeorHideBtn];
    self.rightView = rightView;
    self.rightViewMode = UITextFieldViewModeWhileEditing;
    self.rightView.hidden = YES;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHex:TextFieldLineColorHex];
    [self addSubview:self.line = line];
    
    [self addTarget:self action:@selector(textchange:) forControlEvents:UIControlEventEditingChanged];
    
    self.font = [UIFont systemFontOfSize:kFieldFontSize];
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:kFieldPlaceHolderFontSize], NSForegroundColorAttributeName : [UIColor colorWithHex:TipTextColorHex]};
    NSString *pls = self.placeholder.length > 0 ? self.placeholder : @"";
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:pls attributes:dic];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize rightSize = CGSizeZero;
    if (self.seeOrHideButton.hidden) {
        rightSize = CGSizeMake(25.0, self.height);
         self.clearButton.frame = CGRectMake(2.0, 0, 21, self.height);
    }else{
        rightSize = CGSizeMake(50.0, self.height);
        self.clearButton.frame = CGRectMake(28.0, 0, 21, self.height);
        self.seeOrHideButton.frame = CGRectMake(0, 0, 21, self.height);
    }
    self.rightView.size = rightSize;
    self.line.frame = CGRectMake(0, self.frame.size.height - 1.0, self.frame.size.width, 1.0);
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry{
    [super setSecureTextEntry:secureTextEntry];
    self.seeOrHideButton.selected = !secureTextEntry;
}
#pragma mark 按钮事件
- (void)seeHideButtonClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.secureTextEntry = !btn.isSelected;
}
- (void)clearButtonClick:(UIButton *)btn{
    self.text = nil;
    self.rightView.hidden = YES;
}
- (void)textchange:(UITextField *)field{
    self.rightView.hidden = field.text.length == 0;
}
- (void)setSecureButtonShow:(BOOL)secureButtonShow{
    self.seeOrHideButton.hidden = !secureButtonShow;
    [self setNeedsLayout];
}

@end
