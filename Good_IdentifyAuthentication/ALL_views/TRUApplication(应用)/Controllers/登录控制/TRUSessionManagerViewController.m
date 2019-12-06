//
//  TRUSessionManagerViewController.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/9/11.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUSessionManagerViewController.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import "TRUSessionManagerModel.h"
#import "TRUSessionManagerCell.h"
#import "TRUSessionManagerImageCell.h"
#import <YYWebImage/UIImageView+YYWebImage.h>

#import "YCAlertView.h"
#import "TRUhttpManager.h"

@interface TRUSessionManagerViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) UITableView *mainTable;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *stateArray;
//@property (strong, nonatomic) UIView *blankView;
@end

@implementation TRUSessionManagerViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录控制";
    
    
//    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 70, 30, 30)];
//    imgview.image = [UIImage imageNamed:@"ssoimg"];
//    [self.view addSubview:imgview];
//
//    UILabel *txtlabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 75, 100, 20)];
//    txtlabel.text = @"SSO";
//    txtlabel.font = [UIFont systemFontOfSize:18];
//    [self.view addSubview:txtlabel];
    
    UITableView *mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, SCREENW, SCREENH - kNavBarAndStatusBarHeight) style:UITableViewStylePlain];
    mainTable.tableFooterView = [UIView new];
    mainTable.tableHeaderView = [UIView new];
    mainTable.dataSource = self;
    mainTable.delegate = self;
    [self.view addSubview:self.mainTable = mainTable];
    mainTable.backgroundColor = RGBCOLOR(247, 249, 250);
    [self initDataSource];
    
    if (kDevice_Is_iPhoneX) {
//        mainTable.frame = CGRectMake(0, 130, SCREENW, SCREENH - 130);
//        imgview.frame = CGRectMake(15, 95, 30, 30);
//        txtlabel.frame = CGRectMake(50, 100, 100, 20);
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationBar.hidden = NO;
}

- (void)initDataSource{
    self.dataSource = [NSMutableArray array];
    [self loadSSOLoginInfo];
}



#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TRUSessionManagerModel *model = self.dataSource[indexPath.row];
    if (![model.sessionid isEqualToString:@"SSOID"]) {
        TRUSessionManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SessionCellID"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TRUSessionManagerCell" owner:nil options:nil] lastObject];
        }
        cell.sessionModel = model;
        __weak typeof(self) weakSelf = self;
        cell.logoutBtnClickBlock = ^{
            [weakSelf confirmLogout:model appid:@"10765be5a8ef4e1abcb8cdb0ed4e11c7"];
        };
        self.mainTable.separatorStyle = YES;
        return cell;
    }else{
        
        TRUSessionManagerImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SessionCellImgID"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TRUSessionManagerImageCell" owner:nil options:nil] lastObject];
        }
        self.mainTable.separatorStyle = NO;
        cell.backgroundColor = RGBCOLOR(247, 249, 250);
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TRUSessionManagerModel *model = self.dataSource[indexPath.row];
    if (![model.sessionid isEqualToString:@"SSOID"]) {
        return 65.f;
    }else{
        return 150.f;
    }
    
}

- (void)buttonPress:(UIButton *)sender//headButton点击
{
    //判断状态值
    if ([self.stateArray[sender.tag - 1] isEqualToString:@"1"]){
        //修改
        [self.stateArray replaceObjectAtIndex:sender.tag - 1 withObject:@"0"];
    }else{
        [self.stateArray replaceObjectAtIndex:sender.tag - 1 withObject:@"1"];
    }
    [self.mainTable reloadSections:[NSIndexSet indexSetWithIndex:sender.tag-1] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark 注销操作
- (void)confirmLogout:(TRUSessionManagerModel *)model appid:(NSString *)appid{
    //该操作会注销IP：211.100.57.197  中国，北京 Chrome的登录状态，请确认
    NSString *msg = [NSString stringWithFormat:@"该操作会注销IP：%@ %@ %@的登录状态，请确认。",model.ipAddr, model.region, model.browserExplorer];
    NSString *user = [TRUUserAPI getUser].userId;
    __weak typeof(self) weakSelf = self;
    
//    YCAlertView *alertview = [[YCAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 160) withTitle:nil alertMessage:msg confrimBolck:^{
//        [weakSelf showActivityWithText:@""];
//        [self requsetCIMSSessionLogout:user appid:appid sid:model.sessionid model:model];
//
//    } cancelBlock:^{
//
//    }];
//    [alertview show];
    [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:msg confrimTitle:@"确认" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
        [weakSelf showActivityWithText:@""];
        [self requsetCIMSSessionLogout:user appid:appid sid:model.sessionid model:model];
    } cancelBlock:^{
        
    }];

}

-(void)requsetCIMSSessionLogout:(NSString *)userid appid:(NSString *)appid sid:(NSString *)sid model:(TRUSessionManagerModel *)model{
    
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    __weak typeof(self) weakSelf = self;
    NSArray *ctx = @[@"appid",appid,@"sid",sid];
    NSString *sign = [NSString stringWithFormat:@"%@%@",appid,sid];
    NSString *params = [xindunsdk encryptByUkey:userid ctx:ctx signdata:sign isDeviceType:NO];
    NSDictionary *paramsDic = @{@"params" : params};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/session/logout"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        [weakSelf showActivityWithText:@""];
        if (errorno == 0) {
            [weakSelf.dataSource removeObject:model];
            if (weakSelf.dataSource.count==0) {
                TRUSessionManagerModel *model = [[TRUSessionManagerModel alloc] init];
                model.sessionid = @"SSOID";
                [weakSelf.dataSource addObject:model];
            }
            [weakSelf.mainTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakSelf hideHudDelay:0];
            [weakSelf.mainTable reloadData];
        }else if (errorno == 5004){
            [weakSelf showHudWithText:@"网络错误，请稍后重试"];
            [weakSelf hideHudDelay:2.0];
        }else{
            [weakSelf showHudWithText:[NSString stringWithFormat:@"其他错误（%d）", errorno]];
            [weakSelf hideHudDelay:2.0];
        }
    }];
    
}

#pragma mark 获取门户登录信息
- (void)loadSSOLoginInfo{
    
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [self showHudWithText:@""];
    NSString *user = [TRUUserAPI getUser].userId;
    NSString *sign = @"10765be5a8ef4e1abcb8cdb0ed4e11c7";
    NSArray *ctxx = @[@"appid",sign];
    NSString *para = [xindunsdk encryptByUkey:user ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *paramsDic = @{@"params" : para};
    __weak typeof(self) weakSelf = self;
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/session/sessionList"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        NSLog(@"-->%d-->%@",errorno,responseBody);
        [weakSelf hideHudDelay:0.0];
        if (errorno == 0) {
            if(responseBody){
                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                int code = [dic[@"code"] intValue];
                if (code == 0) {
                    NSArray *arr = dic[@"resp"];
                    [weakSelf.dataSource removeAllObjects];
                    [weakSelf.stateArray removeAllObjects];
                    
                    for (NSDictionary *dic in arr) {
                        TRUSessionManagerModel *model = [TRUSessionManagerModel modelWithDic:dic];
                        [weakSelf.dataSource addObject:model];
                        
                    }
                    if (weakSelf.dataSource.count == 0) {
                        TRUSessionManagerModel *model = [[TRUSessionManagerModel alloc] init];
                        model.sessionid = @"SSOID";
                        [weakSelf.dataSource addObject:model];
                    }
                    [weakSelf.mainTable reloadData];
                    [weakSelf hideHudDelay:0];
                }
            }else{
                TRUSessionManagerModel *model = [[TRUSessionManagerModel alloc] init];
                model.sessionid = @"SSOID";
                [weakSelf.dataSource addObject:model];
                [weakSelf.mainTable reloadData];
                [weakSelf hideHudDelay:0];
            }
        }else if (errorno == 5004){
            [weakSelf showHudWithText:@""];
            [weakSelf hideHudDelay:2.0];
        }else{
            [weakSelf showHudWithText:[NSString stringWithFormat:@"其他错误（%d）", errorno]];
            [weakSelf hideHudDelay:2.0];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
