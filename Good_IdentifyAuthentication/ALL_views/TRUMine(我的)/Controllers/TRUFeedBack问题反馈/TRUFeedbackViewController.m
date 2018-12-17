//
//  TRUFeedbackViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/10/16.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUFeedbackViewController.h"

@interface TRUFeedbackViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *txtview;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@end

@implementation TRUFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
    self.title = @"问题反馈";
}
-(void)customUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _sendBtn.backgroundColor = DefaultColor;
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.layer.cornerRadius = 3;
    
    
    _txtview.layer.masksToBounds = YES;
    _txtview.layer.cornerRadius = 3;
    _txtview.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _txtview.layer.borderWidth = 1;
    _txtview.delegate = self;
}

- (IBAction)sendBtnClick:(id)sender {
    
    [self.view endEditing:YES];
    if (_txtview.text.length == 0) {
        [self showHudWithText:@"反馈内容不能为空"];
        [self hideHudDelay:2.0];
        return;
    }
    [self showHudWithText:@"正在提交..."];
    [self hideHudDelay:2.0];
    [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:2.1];
    
}


#pragma mark -UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        _placeholderLabel.hidden = YES;
        if (textView.text.length <200) {
            _numLabel.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
        }else{
            [self showConfrimCancelDialogViewWithTitle:@"提示" msg:@"您最多输入200字，请简要概述你的问题！" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:nil cancelBlock:nil];
        }
    }else{
        _numLabel.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
        _placeholderLabel.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
