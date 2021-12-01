//
//  TRUBingViewController.m
//  Good_IdentifyAuthentication
//
//  Created by 胡凯 on 2021/11/30.
//  Copyright © 2021 zyc. All rights reserved.
//

#import "TRUBingViewController.h"
#import "masonry.h"
@interface TRUBingViewController ()

@end

@implementation TRUBingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *nameLB = [[UILabel alloc] init];
    nameLB.text = @"请填写个人信息";
    nameLB.textColor = RGBCOLOR(51, 51, 51);
    nameLB.font = [UIFont systemFontOfSize:14.5];
    [self.view addSubview:nameLB];
    
    UIView *nameView = [[UIView alloc] init];
    [self.view addSubview:nameView];
    UITextField *nameTF = [[UITextField alloc] init];
    [nameView addSubview:nameTF];
    nameTF.placeholder = @"请输入姓名";
    
    
    UITextField *idcardTF = [[UITextField alloc] init];
    idcardTF.placeholder = @"请输入证件号码";
    
    
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
