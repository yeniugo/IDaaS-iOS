//
//  TRULoadingViewController.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/11/18.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRULoadingViewController.h"

@interface TRULoadingViewController ()
@property (nonatomic,strong) UIActivityIndicatorView *loadingView;
@property (nonatomic,strong) UILabel *showTxt;
@end

@implementation TRULoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loadingView = [[UIActivityIndicatorView alloc] init];
    self.loadingView.color = [UIColor blackColor];
    self.loadingView.startAnimating;
    CGFloat w = 30.0;
    CGFloat h = w;
    CGFloat x = [UIScreen mainScreen].bounds.size.width/2 - w/2;
    CGFloat y = [UIScreen mainScreen].bounds.size.height/2-h/2;
    self.loadingView.frame = CGRectMake(x, y, w, h);
    [self.view addSubview:self.loadingView];
    self.showTxt = [[UILabel alloc] init];
    CGFloat lbw = 300;
    CGFloat lbh = 20;
    CGFloat lbx = [UIScreen mainScreen].bounds.size.width/2 - lbw/2;
    CGFloat lby = [UIScreen mainScreen].bounds.size.height/2 + h/2 + 5;
    self.showTxt.text = @"正在加载中,请稍候，正在发起认证";
    self.showTxt.textAlignment = NSTextAlignmentCenter;
    self.showTxt.frame = CGRectMake(lbx, lby, lbw, lbh);
    [self.view addSubview:self.showTxt];
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
