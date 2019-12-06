//
//  YZXInfoView.m
//  YZXUnlock
//
//  Created by hukai on 2019/7/18.
//  Copyright © 2019 尹星. All rights reserved.
//

#import "YZXInfoView.h"
#import "YZXPointView.h"
#import "YZXDefine.h"

@interface YZXInfoView()
//可变数组，用于存放初始化的点击按钮
@property (nonatomic, strong) NSMutableArray             *YZXPointViews;
@end


@implementation YZXInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        [self p_initData];
        [self p_initView];
    }
    return self;
}

- (void)p_initView
{
    //初始化开始点位和结束点位
//    self.startPoint = CGPointZero;
//    self.endPoint = CGPointZero;
    //布局手势按钮
    for (int i = 0; i<9 ; i++) {
        YZXPointView *pointView = [[YZXPointView alloc] initWithFrame:CGRectMake((i % 3) * (YZX_VIEW_WIDTH / 2.0 - 8.0) + 1, (i / 3) * (YZX_VIEW_HEIGHT / 2.0 - 8.0) + 1, 10, 10)
                                                               withID:[NSString stringWithFormat:@"%d",i + 1]];
        pointView.isInfo = YES;
        [self addSubview:pointView];
        [self.YZXPointViews addObject:pointView];
    }
}

- (NSMutableArray *)YZXPointViews
{
    if (!_YZXPointViews) {
        _YZXPointViews = [NSMutableArray arrayWithCapacity:9];
    }
    return _YZXPointViews;
}

- (void)changSuccessWithArray:(NSArray *)array{
    for (YZXPointView *YZXPointView in self.YZXPointViews) {
        if ([array containsObject:YZXPointView.ID]) {
            YZXPointView.isSuccess = YES;
        }else{
            YZXPointView.isSuccess = NO;
        }
    }
}

- (void)changeFailureWithArray:(NSArray *)array{
    for (YZXPointView *YZXPointView in self.YZXPointViews) {
        if ([array containsObject:YZXPointView.ID]) {
            YZXPointView.isError = YES;
        }else{
            YZXPointView.isError = NO;
        }
    }
}

- (void)changeNormal{
    for (YZXPointView *YZXPointView in self.YZXPointViews) {
        YZXPointView.isSelected = NO;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
