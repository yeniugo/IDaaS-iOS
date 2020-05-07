//
//  TRUPortalCell.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/3/19.
//  Copyright © 2019 zyc. All rights reserved.
//

#import "TRUPortalCell.h"
#import <YYWebImage.h>
@interface TRUPortalCell ()
@property (nonatomic,strong) UIImageView *imageview;
@property (nonatomic,strong) UILabel *textlabel;
@end

@implementation TRUPortalCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.imageview = [[UIImageView alloc] init];
    [self addSubview:self.imageview];
    self.textlabel = [[UILabel alloc] init];
    self.backgroundColor = [UIColor whiteColor];
    self.textlabel.font = [UIFont systemFontOfSize:13.0];
    self.textlabel.textAlignment = NSTextAlignmentCenter;
//    self.textlabel.font = [UIFont systemFontOfSize:13.0];
//    [self.textlabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.textlabel setNumberOfLines:1];
    [self addSubview:self.textlabel];
    return self;
}

- (void)setCellModel:(TRUPortalModel *)cellModel{
    _cellModel = cellModel;
    if (cellModel.appName.length) {
        [self.imageview yy_setImageWithURL:[NSURL URLWithString:cellModel.iconUrl] placeholder:[UIImage imageNamed:@"personicon"]];
    }else{
        self.imageview.image = nil;
    }
    self.textlabel.text = cellModel.appName;
    [self resetUI];
//    self.textlabel.text = @"fafafa";
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageview.frame = CGRectMake(42/125.0*self.bounds.size.width, 31/125.0*self.bounds.size.width, 44/125.0*self.bounds.size.width, 44/125.0*self.bounds.size.width);
    self.textlabel.frame = CGRectMake(0, 94/125.0*self.bounds.size.width, self.bounds.size.width, 94/125.0*13);
//    self.textlabel.text = @"fafafa";
//    [self.textlabel sizeToFit];
    [self resetUI];
}

- (void)resetUI{
    switch (self.cellModel.cellType) {
        case 0:
        {
            self.layer.mask = nil;
        }
            break;
        case 1:
        {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: self.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(5,5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.bounds;
            maskLayer.path = maskPath.CGPath;
            self.layer.mask = maskLayer;
        }
            break;
        case 2:
        {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: self.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(5,5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.bounds;
            maskLayer.path = maskPath.CGPath;
            self.layer.mask = maskLayer;
        }
            break;
        default:
            break;
    }
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        YCLog(@"选中cell");
    }else{
        YCLog(@"取消选中cell");
    }
}

@end
