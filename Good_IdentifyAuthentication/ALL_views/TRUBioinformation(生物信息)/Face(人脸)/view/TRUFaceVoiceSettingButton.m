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

-(void)commonInit{
    self.backgroundColor = [UIColor whiteColor];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.imageView.contentMode = UIViewContentModeRight;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.x = 20.0;
    self.imageView.x = self.width - self.imageView.width - 20.0;
    self.imageView.size = CGSizeMake(16.0, 16.0);
    self.imageView.y = (self.height - self.imageView.size.height) * 0.5;
}

@end
