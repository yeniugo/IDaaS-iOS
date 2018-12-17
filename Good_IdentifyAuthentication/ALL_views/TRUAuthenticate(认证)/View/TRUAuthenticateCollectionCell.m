//
//  TRUAuthenticateCollectionCell.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/11/28.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUAuthenticateCollectionCell.h"
#import "TRURoundNumberBtn.h"
@interface TRUAuthenticateCollectionCell()
@property (nonatomic,strong) TRURoundNumberBtn *roundBtn;
@end

@implementation TRUAuthenticateCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        UIImageView *iconImageView = [[UIImageView alloc] init];
        self.iconImageView = iconImageView;
        [self addSubview:iconImageView];
        UILabel *textLabel = [[UILabel alloc] init];
        self.textLabel = textLabel;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightThin];
        [self addSubview:textLabel];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds =YES;
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.roundBtn = [TRURoundNumberBtn buttonWithType:UIButtonTypeCustom];
        self.roundBtn.hidden = YES;
        [self.contentView addSubview:self.roundBtn];
        
//        UIView* selectedBGView = [[UIView alloc] initWithFrame:self.bounds];
//
//        selectedBGView.backgroundColor = lineDefaultColor;
//
//        self.selectedBackgroundView = selectedBGView;
        
    }
    return self;
}

- (void)setAuthNumber:(NSInteger)number{
    YCLog(@"number = %d",number);
    if (number==0) {
        self.roundBtn.hidden = YES;
    }else{
        self.roundBtn.hidden = NO;
        //        self.roundBtn.titleLabel.text = [NSString stringWithFormat:@"%ld",number];
        //        [self.roundBtn setTitle:[NSString stringWithFormat:@"%ld",number] forState:UIControlStateNormal];
        [self.roundBtn setAuthNumber:number];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat iconImageH = 32*PointHeightRatio6;
    CGFloat iconImageW = 40*PointHeightRatio6;
    CGFloat iconImageX = (self.bounds.size.width - iconImageW)/2;
    CGFloat iconImageY = self.bounds.size.height*0.32;
    self.iconImageView.frame = CGRectMake(iconImageX, iconImageY, iconImageW, iconImageH);
    
    CGFloat textLabelH = 16;
    CGFloat textLabelW = self.bounds.size.width;
    CGFloat textLabelX = 0;
    CGFloat textLabelY = self.bounds.size.height*0.8-textLabelH;
    self.textLabel.frame = CGRectMake(textLabelX, textLabelY, textLabelW, textLabelH);
    
    CGFloat roundBtnW = self.roundBtn.frame.size.width;
    CGFloat roundBtnH = self.roundBtn.frame.size.height;
    CGFloat roundBtnX = self.bounds.size.width - roundBtnW - 10;
    CGFloat roundBtnY = 10;
    self.roundBtn.frame = CGRectMake(roundBtnX, roundBtnY, roundBtnW, roundBtnH);
}
@end
