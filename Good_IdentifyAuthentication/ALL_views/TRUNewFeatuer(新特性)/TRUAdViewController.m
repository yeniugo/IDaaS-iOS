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
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.backgroundColor = [UIColor clearColor];
    imageview.image = [UIImage imageNamed:@"welcomeicon1.png"];
    NSString *str = [TRUCompanyAPI getCompany].start_up_img_url;
    
    UILabel *showLable = [[UILabel alloc] init];
    showLable.text = @"移动安全认证";
    showLable.textColor = [UIColor whiteColor];
    [self.view addSubview:showLable];
    [self.view addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(30);
        make.right.equalTo(self.view).with.offset(-30);
        make.height.mas_equalTo(imageview.mas_width);
        make.centerY.mas_equalTo(self.view.centerY).with.offset(-100);
    }];
    [showLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(imageview.mas_bottom);
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
