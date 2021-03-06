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
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.backgroundColor = [UIColor clearColor];
    imageview.image = [UIImage imageNamed:@"welcomeicon.png"];
    NSString *str = [TRUCompanyAPI getCompany].start_up_img_url;
    
    UILabel *showLable = [[UILabel alloc] init];
    showLable.text = @"移动安全认证";
    showLable.textColor = [UIColor whiteColor];
    [self.view addSubview:showLable];
    [self.view addSubview:imageview];
    [showLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-125);
    }];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(80.5));
        make.width.equalTo(@(120.5));
        make.bottom.equalTo(showLable.mas_top).with.offset(-71.5);
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
