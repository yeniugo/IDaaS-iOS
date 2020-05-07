//
//  TRUMailManagerViewController.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2020/4/23.
//  Copyright © 2020 zyc. All rights reserved.
//

#import "TRUMailManagerViewController.h"
#import "TRUMailManagerCell.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import "TRUhttpManager.h"
@interface TRUMailManagerViewController ()<UITableViewDelegate,UITableViewDataSource,TRUMailManagerCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation TRUMailManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"邮箱设备";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight + 10, SCREENW, SCREENH - kNavBarAndStatusBarHeight - 10) style:UITableViewStylePlain];
//    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[TRUMailManagerCell class] forCellReuseIdentifier:@"TRUMailManagerCell"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = nil;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    [self getData];
}

- (void)getData{
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *paramsDic = @{@"params" : paras};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/maildevice/list"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        if (errorno == 0) {
            if (responseBody) {
                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                if ([dic[@"code"] intValue] == 0) {
                    if (dic[@"resp"]) {
                        self.dataArray = dic[@"resp"];
                        [self.tableView reloadData];
                    }else{
                        self.dataArray = nil;
                    }
                }
            }else{
                
            }
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
//    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *TRUMailManagerCellIndentifier=@"TRUMailManagerCell";
    
    TRUMailManagerCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:TRUMailManagerCellIndentifier];
    if(!cell){
        cell=[[TRUMailManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TRUMailManagerCellIndentifier];
    }
    cell.delegate = self;
    cell.cellDic = self.dataArray[indexPath.row];
    return cell;
}

- (void)cellLogoutClickWith:(NSDictionary *)dic{
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *sign = [NSString stringWithFormat:@"%ld",[dic[@"id"] longValue]];
    NSArray *ctxx = @[@"id",dic[@"id"]];
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *paramsDic = @{@"params" : paras};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/maildevice/unbind"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        if (errorno == 0) {
            [self showHudWithText:@"解绑成功"];
            [self hideHudDelay:2.0];
        }
    }];
}

@end
