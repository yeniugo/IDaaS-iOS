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
//#import "Masonry/Masonry.h"
@interface TRUAdViewController ()

@end

@implementation TRUAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBar.hidden = YES;
    self.view.backgroundColor = DefaultGreenColor;
    UIImageView *backimage = [[UIImageView alloc] init];
    [self.view addSubview:backimage];
    backimage.image = [UIImage imageNamed:@"applauchaaa.png"];
    backimage.frame = self.view.bounds;
    
    UIView *centerView = [[UIView alloc] init];
    [self.view addSubview:centerView];
    
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.backgroundColor = [UIColor clearColor];
    imageview.image = [UIImage imageNamed:@"welcomeicon11.png"];
    NSString *str = [TRUCompanyAPI getCompany].start_up_img_url;
    
    UILabel *showLable = [[UILabel alloc] init];
    showLable.font = [UIFont systemFontOfSize:40];
    showLable.text = @"中煤IDA";
//    showLable.textColor = [UIColor whiteColor];
    [centerView addSubview:showLable];
    [centerView addSubview:imageview];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).multipliedBy(1.6);
        make.centerX.equalTo(self.view);
    }];
    [showLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageview.mas_right).offset(10);
        make.right.equalTo(centerView);
        make.top.equalTo(centerView.mas_top).offset(10);
        make.bottom.equalTo(centerView.mas_bottom).offset(-10);
    }];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView);
        make.height.equalTo(@(50));
        make.width.equalTo(@(50));
        make.centerY.equalTo(showLable);
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
