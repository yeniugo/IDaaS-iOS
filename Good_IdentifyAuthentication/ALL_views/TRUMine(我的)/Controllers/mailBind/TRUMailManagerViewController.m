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
#import "NSDictionary+NULL.h"
@interface TRUMailManagerViewController ()<UITableViewDelegate,UITableViewDataSource,TRUMailManagerCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UIView *blankView;
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
    
    UIView *blankview = [[UIView alloc] init];
    blankview.backgroundColor = [UIColor whiteColor];
    UIImageView *addBlank = [[UIImageView alloc] init];
    [blankview addSubview:addBlank];
    addBlank.image = [UIImage imageNamed:@"portal_banner_blank"];
    [self.tableView addSubview:blankview];
    blankview.frame = CGRectMake(0, 0, SCREENW, SCREENW);
    addBlank.frame = CGRectMake(SCREENW*0.25, SCREENW*0.25, SCREENW*0.5, SCREENW*0.4);
    UILabel *showlabel = [[UILabel alloc] init];
    [blankview addSubview:showlabel];
    showlabel.textAlignment = NSTextAlignmentCenter;
    showlabel.text = @"暂无邮箱设备";
    showlabel.font = [UIFont systemFontOfSize:14];
    showlabel.textColor = RGBCOLOR(136, 136, 136);
    showlabel.frame = CGRectMake(0, SCREENW*0.75, SCREENW, 20);
    self.blankView = blankview;
    blankview.hidden = YES;
}

- (void)getData{
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *paramsDic = @{@"params" : paras};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/maildevice/list"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        if (errorno == 0) {
            if (responseBody) {
                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                dic = [dic processDictionaryIsNSNull:dic];
                if ([dic[@"code"] intValue] == 0) {
                    if (dic[@"resp"]) {
                        self.dataArray = dic[@"resp"];
                        [self.tableView reloadData];
                        if (self.dataArray.count) {
                            
                        }else{
                            self.blankView.hidden = NO;
//                            self.tableView.hidden = YES;
//                            self.dataArray = nil;
                        }
                    }else{
                        
                    }
                }
            }else{
                self.blankView.hidden = NO;
                self.tableView.hidden = YES;
            }
        }else if (-5004 == errorno){
            [weakSelf showHudWithText:@"网络错误，稍后请重试"];
            [weakSelf hideHudDelay:2.0];
        }else if (9008 == errorno){
            [weakSelf deal9008Error];
        }else if (9019 == errorno){
            [weakSelf deal9019Error];
        }else if (9025 == errorno){
            [weakSelf showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"您的设备已被锁定，请联系管理员！" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
            } cancelBlock:^{
            }];
        }else{
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
            //[NSString stringWithFormat:@"其他错误 %d", error];
            [weakSelf showHudWithText:err];
            [weakSelf hideHudDelay:2.0];
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
    __weak typeof(self) weakSelf = self;
    [self showConfrimCancelDialogAlertViewWithTitle:@"您确定要解绑此邮箱设备吗？" msg:nil confrimTitle:@"是" cancelTitle:@"否" confirmRight:YES confrimBolck:^{
        [weakSelf unBindMail:dic];
    } cancelBlock:^{
        
    }];
}

- (void)unBindMail:(NSDictionary *)dic{
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *sign = [NSString stringWithFormat:@"%ld",[dic[@"id"] longValue]];
    NSArray *ctxx = @[@"id",dic[@"id"]];
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *paramsDic = @{@"params" : paras};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/maildevice/unbind"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        if (errorno == 0) {
            [weakSelf showHudWithText:@"解绑成功"];
            [weakSelf hideHudDelay:2.0];
            [weakSelf getData];
        }else if (-5004 == errorno){
            [weakSelf showHudWithText:@"网络错误，稍后请重试"];
            [weakSelf hideHudDelay:2.0];
        }else if (9008 == errorno){
            [weakSelf deal9008Error];
        }else if (9019 == errorno){
            [weakSelf deal9019Error];
        }else if (9025 == errorno){
            [weakSelf showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"您的设备已被锁定，请联系管理员！" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
            } cancelBlock:^{
            }];
        }else{
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
            //[NSString stringWithFormat:@"其他错误 %d", error];
            [weakSelf showHudWithText:err];
            [weakSelf hideHudDelay:2.0];
        }
    }];
}

@end
