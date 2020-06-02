//
//  TRUWebLoginManagerCell.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2020/4/22.
//  Copyright © 2020 zyc. All rights reserved.
//

#import "TRUWebLoginManagerCell.h"

@interface TRUWebLoginManagerCell()
@property (nonatomic,strong) UILabel *timeLB;
@property (nonatomic,strong) UILabel *systemLB;
@property (nonatomic,strong) UIView *verticalLine;
@property (nonatomic,strong) UIView *bottomCircle;
@property (nonatomic,strong) UIView *topCircle;
//@property (nonatomic,assign) BOOL isFirst;
@property (nonatomic,assign) BOOL isClean;
@end


@implementation TRUWebLoginManagerCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.timeLB = [[UILabel alloc] init];
        self.timeLB.font = [UIFont systemFontOfSize:12.0];
        self.timeLB.frame = CGRectMake(48, 11.5, 72, 30);
        self.timeLB.numberOfLines = 2;
        self.timeLB.textAlignment = NSTextAlignmentCenter;
        self.timeLB.textColor = RGBCOLOR(153, 153, 153);
        [self.contentView addSubview:self.timeLB];
        self.systemLB = [[UILabel alloc] init];
        self.systemLB.font = [UIFont systemFontOfSize:14.0];
        self.systemLB.frame = CGRectMake(160, 11.5, SCREENW - 160 - 30, 20);
        [self.contentView addSubview:self.systemLB];
        self.verticalLine = [[UIView alloc] initWithFrame:CGRectMake(140, 26, 1, 44)];
        self.verticalLine.backgroundColor = [UIColor colorWithRed:0.898 green:0.898 blue:0.898 alpha:1.0];
        [self.contentView addSubview:self.verticalLine];
        self.bottomCircle = [[UIView alloc] initWithFrame:CGRectMake(140.5-7-1,12, 14, 14)];
        self.bottomCircle.layer.cornerRadius = 7;
        self.bottomCircle.backgroundColor = RGBACOLOR(0, 150, 255, 0.4);
        [self.bottomCircle.layer masksToBounds];
        self.topCircle = [[UIView alloc] initWithFrame:CGRectMake(140.5-4-1, 15, 8, 8)];
        self.topCircle.layer.cornerRadius = 4;
        self.topCircle.backgroundColor = RGBACOLOR(0, 150, 255, 1.0);
        [self.topCircle.layer masksToBounds];
        [self.contentView addSubview:self.topCircle];
        [self.contentView addSubview:self.bottomCircle];
//        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)setCellDic:(NSDictionary *)cellDic{
    _cellDic = cellDic;
    NSString *string = cellDic[@"otherAppTimes"];
    string = [string stringByReplacingOccurrencesOfString:@" "withString:@"\n"];
    self.timeLB.text = string;
    self.systemLB.text = cellDic[@"otherAppName"];
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    self.bottomCircle.frame = CGRectMake(135.5,15,8,8);
//    if (self.isClean) {
//        self.systemLB.hidden = YES;
//        self.timeLB.hidden = YES;
//        self.bottomCircle.hidden = YES;
//        self.topCircle.hidden = YES;
//    }else{
//        self.systemLB.hidden = NO;
//        self.timeLB.hidden = NO;
//        self.bottomCircle.hidden = NO;
//        self.topCircle.hidden = NO;
//    }
    if (self.isFirst) {
        self.verticalLine.frame = CGRectMake(138.5+1, 26, 1, self.height - (70-44)+1);
    }else{
        self.verticalLine.frame = CGRectMake(138.5+1, 0, 1, self.frame.size.height+1);
    }
    
}

@end
