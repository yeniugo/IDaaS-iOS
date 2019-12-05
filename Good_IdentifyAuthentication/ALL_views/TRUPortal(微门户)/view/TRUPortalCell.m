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
    self.backgroundColor = [UIColor whiteColor];
    self.imageview = [[UIImageView alloc] init];
    [self addSubview:self.imageview];
    self.textlabel = [[UILabel alloc] init];
    
    self.textlabel.font = [UIFont systemFontOfSize:13.0];
    self.textlabel.textAlignment = NSTextAlignmentCenter;
//    self.textlabel.font = [UIFont systemFontOfSize:13.0];
//    [self.textlabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.textlabel setNumberOfLines:1];
//    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.layer.borderWidth = 0.5;
    [self addSubview:self.textlabel];
    return self;
}

- (void)setCellModel:(TRUPortalModel *)cellModel{
    _cellModel = cellModel;
    [self.imageview yy_setImageWithURL:[NSURL URLWithString:cellModel.iconUrl] placeholder:[UIImage imageNamed:@"personicon"]];
    self.textlabel.text = cellModel.appName;
//    self.textlabel.text = @"fafafa";
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageview.frame = CGRectMake(42/125.0*self.bounds.size.width, 31/125.0*self.bounds.size.width, 44/125.0*self.bounds.size.width, 44/125.0*self.bounds.size.width);
    self.textlabel.frame = CGRectMake(0, 94/125.0*self.bounds.size.width, self.bounds.size.width, 94/125.0*13);
//    self.textlabel.text = @"fafafa";
//    [self.textlabel sizeToFit];
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    UIColor *lineColor = RGBCOLOR(211, 211, 211);
    if (self.lineType&collectioncellLineLeft) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.backgroundColor = [UIColor clearColor].CGColor;
        layer.lineWidth = 0.5;
        layer.borderWidth = 0.5;
        layer.strokeColor = lineColor.CGColor;
        layer.fillColor = nil;
        CGMutablePathRef path=CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, 0, rect.size.height);
        layer.path = path;
        [self.contentView.layer addSublayer:layer];
        CGPathRelease(path);
    }
    if (self.lineType&collectioncellLineTop) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.backgroundColor = [UIColor clearColor].CGColor;
        //        let layer = CAShapeLayer()
        layer.lineWidth = 0.5;
        layer.borderWidth = 0.5;
        layer.strokeColor = lineColor.CGColor;
        CGMutablePathRef path=CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, rect.size.width, 0);
        layer.path = path;
        [self.contentView.layer addSublayer:layer];
        CGPathRelease(path);
    }
    if (self.lineType&collectioncellLineRight) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.backgroundColor = [UIColor clearColor].CGColor;
        //        let layer = CAShapeLayer()
        layer.lineWidth = 0.5;
        layer.borderWidth = 0.5;
        layer.strokeColor = lineColor.CGColor;
        CGMutablePathRef path=CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, rect.size.width, 0);
        CGPathAddLineToPoint(path, NULL, rect.size.width, rect.size.height);
        layer.path = path;
        [self.contentView.layer addSublayer:layer];
        CGPathRelease(path);
    }
    if (self.lineType&collectioncellLineBottom) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.backgroundColor = [UIColor clearColor].CGColor;
        //        let layer = CAShapeLayer()
        layer.lineWidth = 0.5;
        layer.borderWidth = 0.5;
        layer.strokeColor = lineColor.CGColor;
        CGMutablePathRef path=CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 0, rect.size.height);
        CGPathAddLineToPoint(path, NULL, rect.size.width, rect.size.height);
        layer.path = path;
        [self.contentView.layer addSublayer:layer];
        CGPathRelease(path);
    }
}

@end
