//
//  TRUHomeSizeLabel.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/29.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUHomeSizeLabel.h"

@implementation TRUHomeSizeLabel

-(instancetype)initWithFrame:(CGRect)frame withText:(NSString *)text font:(UIFont *)font lineheight:(CGFloat)lineheight backGroundColor:(UIColor *)bgColor wordColor:(UIColor *)color{

    if (self = [super initWithFrame:frame]) {
        self.text = text;
        self.backgroundColor = bgColor;
        self.font = font;
        self.textColor = color;
        self.numberOfLines = 0;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragraphStyle setLineSpacing:lineheight];//调整行间距
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
        self.attributedText = attributedString;
        [self sizeToFit];
    }
    
    return self;
}

@end
