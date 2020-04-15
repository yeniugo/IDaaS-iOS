//
//  TRURegisterSuccess.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/8/23.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRURegisterSuccess.h"
#import "TRUBingUserController.h"
@interface TRURegisterSuccess ()

@end

@implementation TRURegisterSuccess

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //得到当前视图控制器中的所有控制器
    NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
    //把B从里面删除
    [array removeObjectAtIndex:1];
    //把删除后的控制器数组再次赋值
    [self.navigationController setViewControllers:[array copy] animated:YES];
    
}
- (IBAction)receiveBtnClick:(UIButton *)sender {
    //[self.navigationController popToRootViewControllerAnimated:YES];
    TRUBingUserController *bingVC = [[TRUBingUserController alloc] init];
    //bingVC.title = @"登录";
    bingVC.isRegister = YES;
    [self.navigationController pushViewController:bingVC animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.title = @"注册成功";
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
