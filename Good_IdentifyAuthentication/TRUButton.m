//
//  TRUButton.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2016/12/16.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import "TRUButton.h"

@implementation TRUButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize contentSize = self.frame.size;
    CGSize imgSize = self.imageView.frame.size;
    
    self.imageView.frame = CGRectMake((contentSize.width - imgSize.width) * 0.5, 0, imgSize.width, imgSize.height);
    self.titleLabel.frame = CGRectMake(0, imgSize.height +1, contentSize.width, (contentSize.height - imgSize.height));
    
}



@end
