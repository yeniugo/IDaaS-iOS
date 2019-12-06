//
//  TRUDigitBlockInputView.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/5.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRUDigitBlockInputView : UIView
- (instancetype)initWithCount:(NSUInteger)count;

@property (nonatomic, copy) NSString *info;
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, copy) void (^returnButtonAction)(TRUDigitBlockInputView *blockInputView);
@property (nonatomic, copy) void (^textDidChange)(TRUDigitBlockInputView *blockInputView);

@end
