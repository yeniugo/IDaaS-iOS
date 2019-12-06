//
//  TRUSSHAddViewController.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/6/14.
//  Copyright © 2019 zyc. All rights reserved.
//

#import "TRUSSHAddViewController.h"
#import "xindunsdk.h"
#import "TRUhttpManager.h"
#import "TRUUserAPI.h"
#import "NSString+Regular.h"
#import "NSString+Trim.h"
@interface TRUSSHAddViewController ()<UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) UITextField *userTF;
@property (nonatomic,strong) UITextField *ipTF;
@property (nonatomic,strong) UITextView *descTV;
@property (nonatomic,strong) UILabel *placeHolderLabel;
@property (nonatomic,strong) UIButton *pickViewBtn;
@property (nonatomic,strong) UIPickerView *pickView;
@property (nonatomic,assign) int selectRow;
@property (nonatomic,assign) int lastSelectRow;
@property (nonatomic,strong) UILabel *selectLB;
@property (nonatomic,weak) id lastEditView;
@end

@implementation TRUSSHAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomUI];
    self.title = @"运维账号绑定申请";
}

- (void)setCustomUI{
//    UILabel *userLB = [[UILabel alloc] init];
//    [self.view addSubview:userLB];
    UIView *backGroudView = [[UIView alloc] init];
    [self.view addSubview:backGroudView];
    backGroudView.backgroundColor = RGBCOLOR(247, 249, 250);
    backGroudView.frame = CGRectMake(0, kNavBarAndStatusBarHeight + 43+20, SCREENW, 80+200);
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:selectBtn];
    selectBtn.frame = CGRectMake(0, kNavBarAndStatusBarHeight,SCREENW  , 60);
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *showTextLB = [[UILabel alloc] init];
    showTextLB.textColor = RGBCOLOR(51, 51, 51);
    showTextLB.text = @"选择应用";
    [selectBtn addSubview:showTextLB];
    showTextLB.frame = CGRectMake(20, 20, 100, 20);
    
    UILabel *selectLB = [[UILabel alloc] init];
    selectLB.textColor = RGBCOLOR(51, 51, 51);
    selectLB.text = @"我的windows认证应用";
    selectLB.textAlignment = NSTextAlignmentRight;
    [selectBtn addSubview:selectLB];
    selectLB.frame = CGRectMake(SCREENW - 40 - 200 - 20 -5 + 20, 20, 200, 20);
    self.selectLB = selectLB;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"RightAccessoryDisclosureLight"];
    [selectBtn addSubview:imageView];
    imageView.frame = CGRectMake(SCREENW - 40 - 20 + 20, 12+10, 8, 16);
    
    UIImageView *arrow = [[UIImageView alloc] init];
    [selectBtn addSubview:arrow];
    
    UIView *userBGView = [[UIView alloc] init];
    userBGView.backgroundColor = [UIColor whiteColor];
    [backGroudView addSubview:userBGView];
    userBGView.frame = CGRectMake(20,5+20, SCREENW - 40 , 40);
    userBGView.layer.cornerRadius = 5;
    userBGView.layer.borderWidth = 1;
    userBGView.layer.borderColor = RGBCOLOR(215, 215, 215).CGColor;
    
    UITextField *userTF = [[UITextField alloc] init];
    userTF.backgroundColor = [UIColor clearColor];
    userTF.placeholder = @"账号名称";
    [backGroudView addSubview:userTF];
    userTF.frame = CGRectMake(30,5+20, SCREENW - 60 , 40);
    self.userTF = userTF;
    [userTF addTarget:self action:@selector(userTFEditing:)  forControlEvents:UIControlEventAllEditingEvents];
//    UILabel *ipLB = [[UILabel alloc] init];
//    [self.view addSubview:ipLB];
//    UIView *line1 = [[UIView alloc] init];
//    [backGroudView addSubview:line1];
//    line1.backgroundColor = [UIColor lightGrayColor];
//    line1.frame = CGRectMake(20, 40, SCREENW - 40, 0.5);
    
    UIView *ipBGView = [[UIView alloc] init];
    ipBGView.backgroundColor = [UIColor whiteColor];
    [backGroudView addSubview:ipBGView];
    ipBGView.frame = CGRectMake(20, 40+10+20+5, SCREENW - 40 , 40);
    ipBGView.layer.cornerRadius = 5;
    ipBGView.layer.borderWidth = 1;
    ipBGView.layer.borderColor = RGBCOLOR(215, 215, 215).CGColor;
    
    
    UITextField *ipTF = [[UITextField alloc] init];
    ipTF.backgroundColor = [UIColor clearColor];
    ipTF.placeholder = @"设备ip";
    [backGroudView addSubview:ipTF];
    ipTF.frame = CGRectMake(30, 40+10+20+5, SCREENW - 60 , 40);
    self.ipTF = ipTF;
    [ipTF addTarget:self action:@selector(ipTFEditing:)  forControlEvents:UIControlEventAllEditingEvents];
    
//    UIView *line2 = [[UIView alloc] init];
//    [backGroudView addSubview:line2];
//    line2.backgroundColor = [UIColor lightGrayColor];
//    line2.frame = CGRectMake(20, 80, SCREENW - 40, 0.5);
    
    UIView *descBGView = [[UIView alloc] init];
    descBGView.backgroundColor = [UIColor whiteColor];
    [backGroudView addSubview:descBGView];
    descBGView.frame = CGRectMake(20, 80+15+20+5+5, SCREENW - 40, 60);
    descBGView.layer.cornerRadius = 5;
    descBGView.layer.borderWidth = 1;
    descBGView.layer.borderColor = RGBCOLOR(215, 215, 215).CGColor;
    
    UITextView *descTV = [[UITextView alloc] init];
    descTV.font = [UIFont systemFontOfSize:17.0];
    descTV.backgroundColor = [UIColor clearColor];
    descTV.delegate = self;
    [backGroudView addSubview:descTV];
    descTV.frame = CGRectMake(30, 80+15+20+5+5, SCREENW - 60, 60);
    self.descTV = descTV;
    descTV.delegate = self;
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.backgroundColor = DefaultGreenColor;
    [submitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:submitBtn];
    submitBtn.frame = CGRectMake(30, kNavBarAndStatusBarHeight+240 + 40, SCREENW - 60, 50);
    [submitBtn addTarget:self action:@selector(submitBnClick:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = 5;
    submitBtn.layer.masksToBounds = YES;
    
    self.placeHolderLabel = [[UILabel alloc] init];
    [self.descTV addSubview:self.placeHolderLabel];
    self.placeHolderLabel.text = @"备注";
    self.placeHolderLabel.frame = CGRectMake(3, 5, 100, 20);
    self.placeHolderLabel.textColor = RGBCOLOR(220, 220, 220);
    
    [userTF addTarget:self action:@selector(startEdit:) forControlEvents:UIControlEventEditingDidBegin];
    [ipTF addTarget:self action:@selector(startEdit:) forControlEvents:UIControlEventEditingDidBegin];
//    [descTV addTarget:self action:@selector(startEdit:) forControlEvents:UIControlEventEditingDidBegin];
}

- (void)startEdit:(UITextField *)textField{
    self.lastEditView = textField;
}

- (void)selectBtnClick:(UIButton *)btn{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (!self.pickViewBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.pickViewBtn = btn;
        btn.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
        btn.frame = self.view.bounds;
        [btn addTarget:self action:@selector(alertViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        UIButton *windowsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [windowsBtn setTitle:@"windows" forState:UIControlStateNormal];
        [windowsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [windowsBtn setBackgroundColor:[UIColor whiteColor]];
        windowsBtn.frame = CGRectMake(SCREENW - 40 - 200 - 20 -5 + 20+20, kNavBarAndStatusBarHeight+10+20+10, 200+20+5, 40);
        [windowsBtn addTarget:self action:@selector(windowsClick) forControlEvents:UIControlEventTouchUpInside];
        [self.pickViewBtn addSubview:windowsBtn];
        UIButton *linuxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [linuxBtn setTitle:@"linux" forState:UIControlStateNormal];
        [linuxBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [linuxBtn setBackgroundColor:[UIColor whiteColor]];
        linuxBtn.frame = CGRectMake(SCREENW - 40 - 200 - 20 -5 + 20+20, kNavBarAndStatusBarHeight+10+60+10, 200+20+5, 40);
        [linuxBtn addTarget:self action:@selector(linuxClick) forControlEvents:UIControlEventTouchUpInside];
        [self.pickViewBtn addSubview:linuxBtn];
    }else{
        self.pickViewBtn.hidden = NO;
//        [self.pickView selectRow:0 inComponent:0 animated:NO];
//        self.lastSelectRow = 0;
    }
}

- (void)windowsClick{
    self.selectLB.text = @"我的windows认证应用";
    self.pickViewBtn.hidden = YES;
    self.selectRow = 0;
}

- (void)linuxClick{
    self.selectLB.text = @"我的linux认证应用";
    self.pickViewBtn.hidden = YES;
    self.selectRow = 1;
}

- (void)alertViewClick:(UIButton *)btn{
    self.pickViewBtn.hidden = YES;
//    self.selectRow = self.lastSelectRow;
//    if (self.selectRow == 0) {
//        self.selectLB.text = @"我的windows认证应用";
//    }else{
//        self.selectLB.text = @"我的linux认证应用";
//    }
}

- (void)okBtnClick:(UIButton *)btn{
    self.pickViewBtn.hidden = YES;
    self.selectRow = self.lastSelectRow;
    if (self.selectRow == 0) {
        self.selectLB.text = @"我的windows认证应用";
    }else{
        self.selectLB.text = @"我的linux认证应用";
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (row == 0) {
        return @"windows";
    }else{
        return @"linux";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    YCLog(@"选择的是第%d组，第%d行",component,row);
    self.lastSelectRow = row ;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}

#pragma mark - 监听输入框
- (void)textViewDidChange:(UITextView *)textView{
    if (!self.descTV.text.length) {
        self.placeHolderLabel.alpha = 1;
    }else{
        self.placeHolderLabel.alpha = 0;
    }
    if (textView.text.length>20) {
        textView.text = [textView.text substringToIndex:20];
    }
}

//- (void)textViewDidBeginEditing:(UITextView *)textView{
//    if (self.lastEditView == textView) {
//        [textView endEditing:YES];
//    }
//    self.lastEditView = textView;
//}
//
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    return YES;
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)userTFEditing:(UITextField *)userTF{
    if (userTF.text.length>20) {
        userTF.text = [userTF.text substringToIndex:20];
    }
}

- (void)ipTFEditing:(UITextField *)ipTF{
    if (ipTF.text.length>20) {
        ipTF.text = [ipTF.text substringToIndex:20];
    }
}

- (void)submitBnClick:(UIButton *)btn{
    if (self.userTF.text.length==0) {
        [self showHudWithText:@"请输入账号名"];
        [self hideHudDelay:2.0];
        return;
    }
    if (self.ipTF.text.trim.length==0) {
        [self showHudWithText:@"请输入ip地址"];
        [self hideHudDelay:2.0];
        return;
    }
    if (![self.userTF.text isLinuxUser]) {
        [self showHudWithText:@"账户名格式错误"];
        [self hideHudDelay:2.0];
        return;
    }
    if (![self.ipTF.text.trim isIP]) {
        [self showHudWithText:@"ip格式错误"];
        [self hideHudDelay:2.0];
        return;
    }
    [self addSubmit];
}

- (void)addSubmit{
    __weak typeof(self) weakSelf = self;
    NSString *username = [NSString stringWithFormat:@"%@|%@",self.userTF.text.trim,self.ipTF.text.trim];
    NSString *desc;
    if (self.descTV.text.length==0) {
        desc = @"";
    }else{
        desc = [self base64EncodeString:self.descTV.text];
    }
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *apptype;
    if (self.selectRow == 0) {
       apptype = @"1";
    }else if(self.selectRow == 1){
        apptype = @"2";
    }
    NSArray *ctx = @[@"userName",username,@"appType",apptype,@"desc",[NSString stringWithFormat:@"%s",[desc UTF8String]]];
    NSString *sign = [NSString stringWithFormat:@"%@%@%s",username,apptype,[desc UTF8String]];
    NSString *params = [xindunsdk encryptByUkey:userid ctx:ctx signdata:sign isDeviceType:NO];
    NSDictionary *paramsDic = @{@"params" : params};
    [self showHudWithText:@"正在提交"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/device/apply"] withParts:paramsDic onResultWithMessage:^(int errorno, id responseBody,NSString *message) {
        [weakSelf hideHudDelay:0.0];
        if (errorno==0) {
            [weakSelf showHudWithText:@"绑定成功"];
            [weakSelf hideHudDelay:2.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf closeView];
            });
        }else if(errorno==-5004){
            [weakSelf showHudWithText:@"网络错误"];
            [weakSelf hideHudDelay:2.0];
        }else if (9019 == errorno){
            [weakSelf deal9019Error];
        }else if (9021 == errorno){
            [weakSelf deal9021ErrorWithBlock:nil];
        }else if (9022 == errorno){
            [weakSelf deal9022ErrorWithBlock:nil];
        }else if (9023 == errorno){
            [weakSelf deal9023ErrorWithBlock:nil];
        }else if (9025 == errorno){
            [weakSelf deal9025ErrorWithBlock:nil];
        }else if (9026 == errorno){
            [weakSelf deal9026ErrorWithBlock:nil];
        }else if(9017 == errorno){
            [weakSelf showHudWithText:message];
            [weakSelf hideHudDelay:2.0];
        }else{
            [weakSelf showHudWithText:[NSString stringWithFormat:@"%@",message]];
            [weakSelf hideHudDelay:2.0];
        }
    }];
}

- (void)closeView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)base64EncodeString:(NSString *)string{
    //1、先转换成二进制数据
    NSData *data =[string dataUsingEncoding:NSUTF8StringEncoding];
    //2、对二进制数据进行base64编码，完成后返回字符串
    return [data base64EncodedStringWithOptions:0];
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
