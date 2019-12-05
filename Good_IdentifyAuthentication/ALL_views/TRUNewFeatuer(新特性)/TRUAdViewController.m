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

@interface TRUAdViewController ()

@end

@implementation TRUAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageview = [[UIImageView alloc] init];
    NSString *str = [TRUCompanyAPI getCompany].start_up_img_url;
    
    if (str.length>0) {
        [imageview yy_setImageWithURL:[NSURL URLWithString:str] placeholder:nil];
    }else{
        imageview.image = [UIImage imageNamed:@"applaunch"];
    }
    if (kDevice_Is_iPhoneX) {
        CGRect rect = [UIScreen mainScreen].bounds;
        CGFloat wid = rect.size.width;
        CGFloat hei = rect.size.height - 34;
        imageview.frame = CGRectMake(0, 0, wid, hei);
    }else{
        imageview.frame = [UIScreen mainScreen].bounds;
    }
    
    [self.view addSubview:imageview];
    
    NSDictionary *dic = [[NSBundle mainBundle]infoDictionary];
    NSString *version =  dic[@"CFBundleShortVersionString"];
    NSString *bundleVersion = dic[@"CFBundleVersion"];
    NSString *vstr = [NSString stringWithFormat:@"v%@",version];
    UILabel *versionLB = [[UILabel alloc] init];
    versionLB.text = vstr;
    versionLB.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:versionLB];
    CGFloat bottom;
    if (kDevice_Is_iPhoneX) {
        bottom = 34.0 + 34.0;
    }else{
        bottom = 34.0;
    }
    [versionLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-bottom);
    }];
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
