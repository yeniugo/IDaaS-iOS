//
//  TRUAdViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2018/1/25.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUAdViewController.h"
#import "TRUCompanyAPI.h"
#import <YYWebImage.h>
#import <Masonry.h>
@interface TRUAdViewController ()

@end

@implementation TRUAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBar.hidden = YES;
    self.view.backgroundColor = DefaultGreenColor;
//    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.backgroundColor = [UIColor clearColor];
    imageview.image = [UIImage imageNamed:@"welcome1icon.png"];
    NSString *str = [TRUCompanyAPI getCompany].start_up_img_url;
    
    UILabel *showLable = [[UILabel alloc] init];
    showLable.text = @"银  联  身  份  验  证  器";
    showLable.textColor = [UIColor whiteColor];
    
    UIImageView *bottomView = [[UIImageView alloc] init];
    bottomView.backgroundColor = [UIColor clearColor];
    bottomView.image = [UIImage imageNamed:@"welcome1.png"];
    
    [self.view addSubview:imageview];
    [self.view addSubview:showLable];
    [self.view addSubview:bottomView];
    
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.mas_equalTo(self.view).multipliedBy(3/5.0);
        make.width.mas_equalTo(self.view).multipliedBy(210.0/375.0);
//        make.height.mas_equalTo(imageview.width).multipliedBy(1);
//        make.width.equalTo(@(100));
        make.height.equalTo(imageview.mas_width);
    }];
    [showLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(imageview.mas_bottom).offset(50);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
//        make.height.equalTo(@(100));
        make.height.mas_equalTo(bottomView.mas_width).multipliedBy(865/1225.0);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (@available(iOS 13.0, *)) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    //        return UIStatusBarStyleDarkContent;
        } else {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //        return UIStatusBarStyleDefault;
        }
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
