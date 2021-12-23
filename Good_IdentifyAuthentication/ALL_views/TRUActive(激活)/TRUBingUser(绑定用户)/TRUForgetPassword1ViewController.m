//
//  TRUForgetPassword1ViewController.m
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/12/16.
//  Copyright © 2021 zyc. All rights reserved.
//

#import "TRUForgetPassword1ViewController.h"
#import "CRBoxInputView.h"
#import "CRLineView.h"
#import "TRUForgetPassword2ViewController.h"
#import "ZKVerifyAlertView.h"
#import "xindunsdk.h"
#import "TRUhttpManager.h"
@interface TRUForgetPassword1ViewController ()
@property (nonatomic,weak) NSTimer *timer;
@property (nonatomic,weak) UIButton *verifyBtn;
@property (nonatomic, weak) CRBoxInputView *boxInputView;

@end

@implementation TRUForgetPassword1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *lable1 = [[UILabel alloc] init];
    lable1.text = @"1.输入账号";
    UILabel *lable2 = [[UILabel alloc] init];
    lable2.text = @">";
    lable2.textAlignment = NSTextAlignmentCenter;
    UILabel *lable3 = [[UILabel alloc] init];
    lable3.text = @"2.安全验证";
    UILabel *lable4 = [[UILabel alloc] init];
    lable4.text = @">";
    lable4.textAlignment = NSTextAlignmentCenter;
    UILabel *lable5 = [[UILabel alloc] init];
    lable5.text = @"3.重置密码";
    
    [self.view addSubview:lable1];
    [self.view addSubview:lable2];
    [self.view addSubview:lable3];
    [self.view addSubview:lable4];
    [self.view addSubview:lable5];
    
    UILabel *showLB = [[UILabel alloc] init];
    showLB.text = @"验证码已发送到";
    [self.view addSubview:showLB];
    
    [lable1 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.top.equalTo(self.view.mas_topMargin).offset(10);
    }];
    
    [lable3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(lable1);
    }];
    
    [lable5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(lable1);
    }];
    [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lable1.mas_right);
        make.right.equalTo(lable3.mas_left);
        make.top.equalTo(lable1);
    }];
    [lable4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lable3.mas_right);
        make.right.equalTo(lable5.mas_left);
        make.top.equalTo(lable1);
    }];
    
    [showLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lable1);
        make.top.equalTo(lable1.mas_bottom).offset(40);
    }];
    
    CRBoxInputCellProperty *cellProperty = [CRBoxInputCellProperty new];
    cellProperty.cellCursorColor = [UIColor blackColor];
    cellProperty.cellCursorWidth = 2;
    cellProperty.cellCursorHeight = 27;
    cellProperty.cornerRadius = 0;
    cellProperty.borderWidth = 0;
    cellProperty.cellFont = [UIFont boldSystemFontOfSize:24];
    cellProperty.cellTextColor = [UIColor blackColor];
    cellProperty.showLine = YES;
    cellProperty.customLineViewBlock = ^CRLineView * _Nonnull{
        CRLineView *lineView = [CRLineView new];
        lineView.underlineColorNormal = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        lineView.underlineColorSelected = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        lineView.underlineColorFilled = [UIColor blackColor];
        [lineView.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(4);
            make.left.right.bottom.offset(0);
        }];
        
        lineView.selectChangeBlock = ^(CRLineView * _Nonnull lineView, BOOL selected) {
            if (selected) {
                [lineView.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(6);
                }];
            } else {
                [lineView.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(4);
                }];
            }
        };

        return lineView;
    };

    CRBoxInputView *_boxInputView = [[CRBoxInputView alloc] initWithCodeLength:6];
    _boxInputView.mainCollectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    CGFloat w = (SCREENW - 80 - 60)/6;
    _boxInputView.boxFlowLayout.itemSize = CGSizeMake(w, 52);
    _boxInputView.customCellProperty = cellProperty;
    [_boxInputView loadAndPrepareViewWithBeginEdit:YES];
    self.boxInputView = _boxInputView;
    [self.view addSubview:_boxInputView];
    [_boxInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lable1.mas_left).offset(-10);
        make.right.equalTo(lable5.mas_right);
        make.top.equalTo(showLB.mas_bottom).offset(30);
        make.height.equalTo(@(50));
    }];
    UIButton *verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [verifyBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
    [verifyBtn setTitleColor:DefaultGreenColor forState:UIControlStateNormal];
    [verifyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [verifyBtn addTarget:self action:@selector(verifyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verifyBtn];
    self.verifyBtn = verifyBtn;
    [verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(_boxInputView.mas_bottom).offset(20);
    }];
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn.layer setMasksToBounds:YES];
    [nextBtn.layer setCornerRadius:5.0];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitle:@"下一步" forState:UIControlStateHighlighted];
    nextBtn.backgroundColor = DefaultGreenColor;
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_boxInputView);
        make.top.equalTo(verifyBtn.mas_bottom).offset(40);
        make.height.equalTo(@(50));
    }];
    self.verifyBtn.enabled = NO;
    [self startTimer];
    
    [self verifyBtnClick:nil];
}

- (void)verifyBtnClick:(UIButton *)btn{
    __weak typeof(self) weakSelf = self;
    ZKVerifyAlertView *verifyView = [[ZKVerifyAlertView alloc] initWithMaximumVerifyNumber:100 results:^(ZKVerifyState state) {
        [weakSelf sendMessage];
    }];
    [verifyView show];
}

- (void)sendMessage{
    __weak typeof(self) weakSelf = self;
    NSString *signStr;
    NSString *para;
//    signStr = [NSString stringWithFormat:@",\"userno\":\"%@\",\"type\":\"%s\"}", self.accountStr, [self.type UTF8String]];
    signStr = [NSString stringWithFormat:@",\"userno\":\"%@\",\"type\":\"%@\"}", self.accountStr, @"phone"];
    para = [xindunsdk encryptBySkey:self.accountStr ctx:signStr isType:NO];
    NSDictionary *paramsDic = @{@"params" : para};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/apply4active"] withParts:paramsDic onResultWithMessage:^(int errorno, id responseBody, NSString *message) {
        if (errorno == 0) {
            [weakSelf showHudWithText:@"发送验证码成功"];
            [weakSelf hideHudDelay:2.0];
        }else{
            
        }
    }];
}

- (void)nextBtnClick:(UIButton *)btn{
    __weak typeof(self) weakSelf = self;
    NSString *signStr;
    NSString *para;
    signStr = [NSString stringWithFormat:@",\"authcode\":\"%@\",\"phone\":\"%@\"}", self.boxInputView.textValue, self.accountStr];
    para = [xindunsdk encryptBySkey:self.accountStr ctx:signStr isType:NO];
    NSDictionary *paramsDic = @{@"params" : para};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/user/verifyAuthCode"] withParts:paramsDic onResultWithMessage:^(int errorno, id responseBody, NSString *message) {
        if (errorno == 0) {
            TRUForgetPassword2ViewController *vc = [[TRUForgetPassword2ViewController alloc] init];
            vc.accountStr = weakSelf.accountStr;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            
        }
    }];
    
}

- (void)startTimer{
    __weak typeof(self) weakSelf = self;
    [weakSelf stopTimer];
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:weakSelf selector:@selector(startButtonCount) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.timer = timer;
    [timer fire];
    
}
- (void)stopTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        totalTime = 60;
    }
}
static int totalTime = 60;
- (void)startButtonCount{
    
    if (totalTime >= 1) {
        totalTime -- ;
        NSString *leftTitle  = [NSString stringWithFormat:@"已发送(%ds)",totalTime];
        [self.verifyBtn setTitle:leftTitle forState:UIControlStateNormal];
    }else{
        totalTime = 60;
        [self.verifyBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        self.verifyBtn.enabled = YES;
        [self stopTimer];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
