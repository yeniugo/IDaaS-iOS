//
//  TRUPersonalSmaillCell.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/30.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUPersonalSmaillCell.h"

@interface TRUPersonalSmaillCell()
@property (weak, nonatomic) IBOutlet UIView *backGroudView;
@property (nonatomic,strong) UIView *lineView;//下划线
@end

@implementation TRUPersonalSmaillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    [self setAccessoryType:UITableViewCellAccessoryNone];
    self.backGroudView.layer.cornerRadius = 4*PointHeightRatio6;
    self.backGroudView.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = RGBCOLOR(234, 234, 234);
    [self addSubview:self.lineView];
    self.isShort = NO;
}

//-(void)setIsShowLine:(BOOL)isShowLine{
//    _isShowLine = isShowLine;
//    self.lineView.hidden = !isShowLine;
//}

-(void)layoutSubviews{
    [super layoutSubviews];
    if(self.isShort){
        self.lineView.frame = CGRectMake(16+4*PointHeightRatio6, self.bounds.size.height, self.bounds.size.width-26-8*PointHeightRatio6, -1);
    }else{
        self.lineView.frame = CGRectMake(16, self.bounds.size.height, self.bounds.size.width-26, -1);
    }
    
//    if (self.subviews.count>1) {
    
//        for (int i = 1;i<self.subviews.count;i++) {
//            [self.subviews[i] removeFromSuperview];
//        }
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
