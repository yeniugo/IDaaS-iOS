//
//  FireflyAlertView.m
//  FireflyFramework
//
//  Created by wenyanjie on 15/4/17.
//  Copyright (c) 2015年 cmbc. All rights reserved.
//

#import "FireflyAlertView.h"
//#import "FireflyCommonGlobalVar.h"

#define backgroundAlpha 0.25
#define contentWidth 280
#define contentPadding 15
#define DefaultTitle @"提示"

static FireflyAlertView *alertViewInstance;

@interface FireflyAlertView()

@property (nonatomic, strong) AlertViewBlock cancelBlock;
@property (nonatomic, strong) AlertViewBlock otherBlock;
@property (nonatomic, strong) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSString *otherButtonTitle;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIView *contentView;

- (void)initViewWithTitle:(NSString *)aTitle message:(NSString *)aMessage;
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
        cancelTitle:(NSString *)cancelTitle
        cancelBlock:(AlertViewBlock)cancelBlock
         otherTitle:(NSString *)otherTitle
         otherBlock:(AlertViewBlock)otherBlock;
- (void)clickCancelButton:(id)sender;
- (void)clickOtherButton:(id)sender;
- (void)show;
- (void)dismissSelf;

@end

@implementation FireflyAlertView

+ (id)showWithTitle:(NSString *)title
            message:(NSString *)message
        buttonTitle:(NSString *)buttonTitle;
{
    return  [[self class] showWithTitle:title
                                message:message
                            cancelTitle:buttonTitle
                            cancelBlock:nil
                             otherTitle:nil
                             otherBlock:nil];
}

+ (id)showWithTitle:(NSString *)title
            message:(NSString *)message
        cancelTitle:(NSString *)cancelTitle
        cancelBlock:(AlertViewBlock)cancelBlock
         otherTitle:(NSString *)otherTitle
         otherBlock:(AlertViewBlock)otherBlock
{
    if (alertViewInstance)
    {
        [alertViewInstance removeFromSuperview];
        alertViewInstance = nil;
    }
    
    alertViewInstance = [[self alloc] initWithTitle:title
                                            message:message
                                        cancelTitle:cancelTitle
                                        cancelBlock:cancelBlock
                                         otherTitle:otherTitle
                                         otherBlock:otherBlock];
    [alertViewInstance show];
    return alertViewInstance;
}

#pragma mark- private method

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
        cancelTitle:(NSString *)cancelTitle
        cancelBlock:(AlertViewBlock)cancelBlk
         otherTitle:(NSString *)otherTitle
         otherBlock:(AlertViewBlock)otherBlk
{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)])
    {
        if (title.length == 0)
        {
            title = DefaultTitle;
        }
        
        self.cancelButtonTitle = cancelTitle;
        self.otherButtonTitle = otherTitle;
        self.cancelBlock = cancelBlk;
        self.otherBlock = otherBlk;
        
        [self initViewWithTitle:title message:message];
    }
    return self;
}

- (void)initViewWithTitle:(NSString *)aTitle message:(NSString *)aMessage
{
    CGRect backviewFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.backGroundView = [[UIView alloc] initWithFrame:backviewFrame];
    self.backGroundView.backgroundColor = [UIColor blackColor];
    self.backGroundView.alpha = backgroundAlpha;
    [self addSubview:self.backGroundView];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 5;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentWidth, 40)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = aTitle;
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:titleLabel];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40.0, contentWidth, 0.5)];
    topLine.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:topLine];
    
    CGSize contentSize;
    CGFloat textWidth = contentWidth- 2 * contentPadding;
    NSAttributedString *titleAttriString = [[NSAttributedString alloc] initWithString:aMessage
                                                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
    CGRect titleRect = [titleAttriString boundingRectWithSize:CGSizeMake(textWidth, self.frame.size.height - 200)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                      context:nil];
    contentSize = titleRect.size;
    UILabel *messasgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentPadding,
                                                                       topLine.frame.origin.y + contentPadding,
                                                                       textWidth,
                                                                       contentSize.height)];
    messasgeLabel.backgroundColor = [UIColor clearColor];
    messasgeLabel.text = aMessage;
    messasgeLabel.textAlignment = NSTextAlignmentCenter;
    messasgeLabel.textColor = [UIColor darkGrayColor];
    messasgeLabel.font = [UIFont systemFontOfSize:15];
    messasgeLabel.numberOfLines = 0;
    messasgeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:messasgeLabel];
    
    CGFloat gapY = CGRectGetMaxY(messasgeLabel.frame) + 26;
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  gapY,
                                                                  contentWidth,
                                                                  0.5)];
//    bottomLine.backgroundColor = UIColorFromHexValue(0xa0a7b5);
    [self.contentView addSubview:bottomLine];
    
    //需要创2个按钮
    if(self.otherButtonTitle.length >0)
    {
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
        cancelButton.frame = CGRectMake(contentWidth / 2, gapY, contentWidth / 2, 44);
        [cancelButton setTitle:self.cancelButtonTitle
                      forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor darkGrayColor]
                           forState:UIControlStateNormal];
        
        [cancelButton setBackgroundImage:[[UIImage imageNamed:@"alert_button_high"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)] forState:UIControlStateNormal];
        [cancelButton addTarget:self
                         action:@selector(clickCancelButton:)
               forControlEvents:UIControlEventTouchUpInside];
        cancelButton.layer.masksToBounds = YES;
        cancelButton.layer.cornerRadius = 5;
        [self.contentView addSubview:cancelButton];
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.backgroundColor = [UIColor clearColor];
        sureButton.titleLabel.font = [UIFont systemFontOfSize:17];
        sureButton.frame = CGRectMake(0, gapY, contentWidth / 2 -1, 44);
        [sureButton setTitle:self.otherButtonTitle
                    forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor darkGrayColor]
                         forState:UIControlStateNormal];
        [sureButton setBackgroundImage:[[UIImage imageNamed:@"alert_button_high"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)] forState:UIControlStateNormal];
        sureButton.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
//        [sureButton setBackgroundImage:[FireflyImageManager imageNamed:@"common_UI_alert_button_high"
//                                                                resize:UIEdgeInsetsMake(2, 2, 2, 2)]
//                              forState:UIControlStateHighlighted];
        [sureButton addTarget:self
                       action:@selector(clickOtherButton:)
             forControlEvents:UIControlEventTouchUpInside];
        sureButton.layer.masksToBounds = YES;
        sureButton.layer.cornerRadius = 5;
        [self.contentView addSubview:sureButton];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(contentWidth / 2, gapY, 0.5, 45)];
//        lineView.backgroundColor = UIColorFromHexValue(0xa0a7b5);
        [self.contentView addSubview:lineView];
    }
    else
    {
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
        cancelButton.frame = CGRectMake(0, gapY, contentWidth, 44);
        [cancelButton setTitle:self.cancelButtonTitle
                      forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor darkGrayColor]
                           forState:UIControlStateNormal];

        [cancelButton setBackgroundImage:[[UIImage imageNamed:@"alert_button_high"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)] forState:UIControlStateNormal];
//        cancelButton.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);

        
        [cancelButton addTarget:self
                         action:@selector(clickCancelButton:)
               forControlEvents:UIControlEventTouchUpInside];
        cancelButton.layer.masksToBounds = YES;
        cancelButton.layer.cornerRadius = 5;
        [self.contentView addSubview:cancelButton];
    }
    
    CGFloat contentHeight = gapY + 44;

//    if ([FireflyCommonGlobalVar sharedInstance].isKeyboardShowing)
//    {
//        self.contentView.frame = CGRectMake((ScreenWidth - contentWidth) / 2,
//                                            (ScreenHeight - contentHeight) / 2 - 60,
//                                            contentWidth,
//                                            contentHeight);
//    }
//    else
//    {
        self.contentView.frame = CGRectMake((SCREENW - contentWidth) / 2,
                                            (SCREENH - contentHeight) / 2,
                                            contentWidth,
                                            contentHeight);
//    }
    
    [self addSubview:self.contentView];
}

-(void)dealloc
{
    if (self.cancelBlock)
    {
        self.cancelBlock = nil;
    }
    
    if (self.otherBlock)
    {
        self.otherBlock = nil;
    }
}


-(void)clickCancelButton:(id)sender
{
    [self dismissSelf];
    
    if (self.cancelBlock){
        self.cancelBlock();
    }
}

-(void)clickOtherButton:(id)sender
{
    [self dismissSelf];
    
    if (self.otherBlock)
    {
        self.otherBlock();
    }
}

- (void)show
{
    self.contentView.transform = CGAffineTransformIdentity;
    self.contentView.alpha = 0.0f;
    self.backGroundView.alpha = 0.0f;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.2f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                        self.contentView.transform = CGAffineTransformMakeScale(1.15f, 1.15f);
                        self.contentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                        self.contentView.alpha = 1.0f;
                        self.backGroundView.alpha = backgroundAlpha;
                     }
                     completion:^(BOOL finished){
        
                     }];
}

- (void)dismissSelf
{
    self.contentView.transform = CGAffineTransformIdentity;
    self.backGroundView.alpha = backgroundAlpha;
    
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.75f, 0.75f);
        self.contentView.alpha   = 0.01f;
        self.backGroundView.alpha = 0.0f;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

@end
