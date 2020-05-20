//
//  TRURoundNumberBtn.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/11/1.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRURoundNumberBtn.h"

@interface TRURoundNumberBtn()
@property (nonatomic,assign) CGFloat imageW;
@end

@implementation TRURoundNumberBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageW = 20;
        self.userInteractionEnabled = NO;
//        [self setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        self.backgroundColor = RGBCOLOR(239, 148, 37);
        [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self setTintColor:[UIColor whiteColor]];
        self.layer.cornerRadius = self.imageW/2;
        self.layer.masksToBounds =YES;
    }
    return self;
}

- (void)setAuthNumber:(NSInteger)number{
    NSString *numStr = [NSString stringWithFormat:@"%ld",number];
    self.titleLabel.text = numStr;
    [self setTitle:numStr forState:UIControlStateNormal];
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:self.titleLabel.font.fontName size:self.titleLabel.font.pointSize]}];
    CGFloat showW;
    if (titleSize.width > self.imageW) {
        showW = titleSize.width;
    }else{
        showW = self.imageW;
    }
    self.bounds = CGRectMake(0, 0, showW , self.imageW);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
//    YCLog(@"TRURoundNumberBtn.frame = %@",NSStringFromCGRect(self.frame));
}

@end
