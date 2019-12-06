//
//  TRUBuildingViewController.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/11/23.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUBuildingViewController.h"

@interface TRUBuildingViewController ()

@end

@implementation TRUBuildingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *showText = [[UILabel alloc] init];
    showText.text = @"正在建设中......";
    showText.frame = CGRectMake(0, SCREENH/2, SCREENW, 20);
    showText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:showText];
}

- (void)setNavTitel:(NSString *)navTitel{
    _navTitel = [navTitel copy];
    self.title = _navTitel;
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
