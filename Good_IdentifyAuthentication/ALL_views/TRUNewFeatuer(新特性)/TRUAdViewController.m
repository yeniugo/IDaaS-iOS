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
