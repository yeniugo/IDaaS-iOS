//
//  TRUFaceVoiceSettingButton.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/11.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUFaceVoiceSettingButton.h"

@implementation TRUFaceVoiceSettingButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self commonInit];
}

-(void)setIsDeleteBtn:(BOOL)isDeleteBtn{
    _isDeleteBtn = isDeleteBtn;
    if (isDeleteBtn) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.imageView.hidden = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }else{
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.imageView.hidden = NO;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
}

-(void)commonInit{
    self.backgroundColor = [UIColor whiteColor];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.imageView.contentMode = UIViewContentModeRight;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.x = 20.0;
    self.titleLabel.width = self.bounds.size.width;
    self.imageView.x = self.width - self.imageView.width - 20.0;
    self.imageView.size = CGSizeMake(16.0, 16.0);
    self.imageView.y = (self.height - self.imageView.size.height) * 0.5;
}

@end
