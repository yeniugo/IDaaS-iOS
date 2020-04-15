//
//  TRURegisterController.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/8/23.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRURegisterController.h"
#import "NSString+Regular.h"
#import "xindunsdk.h"
#import "TRURegisterSuccess.h"
#import "IQKeyboardManager.h"
#import "TRUhttpManager.h"

@interface TRURegisterController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *rePassword;

//注册
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@end

@implementation TRURegisterController

//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
//    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if(IS_IPHONE_4_OR_LESS){
//        self = [super initWithNibName:@"TRURegister4sController" bundle:[NSBundle mainBundle]];
//    }else{
//        self = [super initWithNibName:@"TRURegisterController" bundle:[NSBundle mainBundle]];
//    }
//    return self;
//}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.title = @"注册";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (IBAction)passwordShowBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(sender.selected){
        self.password.secureTextEntry = NO;
    }else{
        self.password.secureTextEntry = YES;
    }
    
}
- (IBAction)rePasswordShowBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(sender.selected){
        self.rePassword.secureTextEntry = NO;
    }else{
        self.rePassword.secureTextEntry = YES;
    }
    
}

- (IBAction)btnRegisteDown:(id)sender {
    if(self.name.text.length==0){
        [self showHudWithText:@"请输入姓名"];
        [self hideHudDelay:1.5f];
        return;
    }
    if(self.email.text.length==0){
        [self showHudWithText:@"请输入邮箱"];
        [self hideHudDelay:1.5f];
        return;
    }
    if(self.password.text.length==0){
        [self showHudWithText:@"请输入密码"];
        [self hideHudDelay:1.5f];
        return;
    }
    if (![self.password.text isEqualToString: self.rePassword.text]) {
        [self showHudWithText:@"两次密码不一致"];
        [self hideHudDelay:1.5f];
        return;
    }
    __weak typeof(self) weakself = self;
    NSString *str = [NSString stringWithFormat:@"{\"email\":\"%@\",\"name\":\"%@\",\"password\":\"%@\"}",self.email.text,self.name.text,self.password.text];
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *para = [xindunsdk getParamsWithencryptText:str user:self.email.text];
    NSDictionary *paramsDic = @{@"params" : para};
    [TRUhttpManager sendCIMSRequestWithUrlRegiste:[baseUrl stringByAppendingString:@"/mapi/01/user/reg"] withParts:paramsDic onResult:^(int error, id responseBody) {
        [weakself hideHudDelay:0.0];
        if(0==error){
            TRURegisterSuccess *vc = [TRURegisterSuccess alloc];
            [weakself.navigationController pushViewController:vc animated:YES];
        }else if(-5004 == error){
            [weakself showHudWithText:@"网络错误，请稍后重试"];
            [weakself hideHudDelay:2.0];
        }else if(9001 == error){
            [weakself showHudWithText:@"激活码不正确，请确认后重新输入"];
            [weakself hideHudDelay:2.0];
        }else if (9019 == error){
            [weakself deal9019Error];
        }else if (9011 == error){
            NSString *msg = responseBody[@"msg"];
            if([msg length]){
                [weakself showHudWithText:msg];
                [weakself hideHudDelay:2.0];

            }
        }else{
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",error];
            [weakself showHudWithText:err];
            [weakself hideHudDelay:2.0];
        }
    }];
//    [xindunsdk requestXMCIMSRegisterWithemail:self.email.text name:self.name.text password:self.password.text onResult:^(int error, id response) {
//        if(0==error){
//            [self hideHudDelay:0.0];
//            TRURegisterSuccess *vc = [TRURegisterSuccess alloc];
//            [self.navigationController pushViewController:vc animated:YES];
//        }else if(-5004 == error){
//            [self showHudWithText:@"网络错误，请稍后重试"];
//            [self hideHudDelay:2.0];
//        }else if(9001 == error){
//            [self showHudWithText:@"激活码不正确，请确认后重新输入"];
//            [self hideHudDelay:2.0];
//        }else if (9019 == error){
//            [self deal9019Error];
//        }else if (9011 == error){
//
//            NSString *msg = response[@"msg"];
//            if([msg length]){
//                [self showHudWithText:msg];
//                [self hideHudDelay:2.0];
//
//            }
//        }else{
//            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",error];
//            [self showHudWithText:err];
//            [self hideHudDelay:2.0];
//        }
//    }];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
