//
//  TRUPortalTitleView.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/8/19.
//  Copyright © 2019 zyc. All rights reserved.
//

#import "TRUPortalTitleView.h"

@interface TRUPortalTitleView()
@property (nonatomic,strong) UILabel *titleLB;
@property (nonatomic,strong) UIView *lineView;
@end

@implementation TRUPortalTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *titleLB = [[UILabel alloc] init];
        [self addSubview:titleLB];
        titleLB.textAlignment = NSTextAlignmentCenter;
        titleLB.frame = self.bounds;
        titleLB.text = @"微 门 户";
        titleLB.font = [UIFont systemFontOfSize:14*PointWidthRatioX];
        self.titleLB = titleLB;
        
        UIView *lineView = [[UIView alloc] init];
        [self addSubview:lineView];
        lineView.backgroundColor = RGBCOLOR(153, 153, 153);
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    self.titleLB.frame = self.bounds;
    self.lineView.frame = CGRectMake(0, self.bounds.size.height-1, self.bounds.size.height-1, 0.5);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
