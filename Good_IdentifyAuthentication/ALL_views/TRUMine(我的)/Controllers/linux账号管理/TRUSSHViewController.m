//
//  TRUSSHViewController.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/6/12.
//  Copyright © 2019 zyc. All rights reserved.
//

#import "TRUSSHViewController.h"
#import "TRUSSHViewCell.h"
#import "TRUUserAPI.h"
#import "xindunsdk.h"
#import "TRUhttpManager.h"
#import "TRUSSHViewModel.h"
#import "TRUSSHAddViewController.h"
#import "MJRefresh.h"
@interface TRUSSHViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UIView *blankView;
@end

@implementation TRUSSHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"运维账号";
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,kNavBarAndStatusBarHeight , SCREENW, SCREENH - kNavBarAndStatusBarHeight) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TRUSSHViewCell" bundle:nil] forCellReuseIdentifier:@"TRUSSHViewCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshUI];
        [self.tableView.mj_header endRefreshing];
    }];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setImage:[UIImage imageNamed:@"SSHAddBtn"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addSSH:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
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
    showlabel.text = @"暂无账号";
    showlabel.font = [UIFont systemFontOfSize:14];
    showlabel.textColor = RGBCOLOR(136, 136, 136);
    showlabel.frame = CGRectMake(0, SCREENW*0.75, SCREENW, 20);
    self.blankView = blankview;
    blankview.hidden = YES;
}

- (void)refreshUI{
    [self getList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getList];
}

- (void)addSSH:(UIButton *)btn{
    TRUSSHAddViewController *vc = [[TRUSSHAddViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getList{
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
//    NSArray *ctx = @[@"userName",username,@"desc",desc];
//    NSString *sign = [NSString stringWithFormat:@"%@%@",username,desc];
    NSString *params = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *paramsDic = @{@"params" : params};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/device/list"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        if (errorno==0) {
            if (responseBody) {
                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                int code = [dic[@"code"] intValue];
                if (code==0) {
                    NSArray *dataArr = dic[@"resp"];
                    NSMutableArray *tempArray = [NSMutableArray array];
                    if (dataArr.count>0) {
                        self.blankView.hidden = YES;
                        for (int i = 0; i< dataArr.count; i++) {
                            NSDictionary *dic = dataArr[i];
                            TRUSSHViewModel *model = [TRUSSHViewModel yy_modelWithDictionary:dic];
                            if ([model.status intValue]!=3) {
                                [tempArray addObject:model];
                            }
                        }
                        self.dataArray = [NSArray arrayWithArray:tempArray];
                        [self.tableView reloadData];
                    }else{
                        self.blankView.hidden = NO;
                    }
                }
            }
        }else if(errorno==-5004){
            [weakSelf showHudWithText:@"网络错误"];
            [weakSelf hideHudDelay:2.0];
        }else if (9019 == errorno){
            [weakSelf deal9019Error];
        }else if (9021 == errorno){
            [weakSelf deal9021ErrorWithBlock:nil];
        }else if (9022 == errorno){
            [weakSelf deal9022ErrorWithBlock:nil];
        }else if (9023 == errorno){
            [weakSelf deal9023ErrorWithBlock:nil];
        }else if (9025 == errorno){
            [weakSelf deal9025ErrorWithBlock:nil];
        }else if (9026 == errorno){
            [weakSelf deal9026ErrorWithBlock:nil];
        }else{
            [weakSelf showHudWithText:[NSString stringWithFormat:@"%d错误",errorno]];
            [weakSelf hideHudDelay:2.0];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *SSHViewCelldentifier=@"TRUSSHViewCell";
    UITableViewCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:SSHViewCelldentifier forIndexPath:indexPath];
    if(!cell){
        cell=[[TRUSSHViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SSHViewCelldentifier];
    }
    TRUSSHViewCell *sshcell = cell;
    sshcell.cellModel = self.dataArray[indexPath.row];
    return sshcell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TO-DO:未通过和审批中不让滑
    TRUSSHViewModel *cellmodel = self.dataArray[indexPath.row];
    if ([cellmodel.status intValue] ==1) {
        return YES;
    }else{
        return NO;
    }
//    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"解绑账号" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        YCLog(@"点击了。。%d",indexPath.row);
        TRUSSHViewModel *cellmodel = weakSelf.dataArray[indexPath.row];
        [weakSelf deleteAccountWithID:cellmodel.keyid];
        // 收回左滑出现的按钮(退出编辑模式)
        tableView.editing = NO;
    }];
    action.backgroundColor = [UIColor redColor];
    return @[action];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)deleteAccountWithID:(NSString *)delID{
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSArray *ctx = @[@"id",delID];
    NSString *sign = [NSString stringWithFormat:@"%@",delID];
    NSString *params = [xindunsdk encryptByUkey:userid ctx:ctx signdata:sign isDeviceType:NO];
    NSDictionary *paramsDic = @{@"params" : params};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/device/del"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        if (errorno==0) {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataArray];
            for (TRUSSHViewModel *cellmodel in tempArray) {
                if ([cellmodel.keyid isEqualToString:delID]) {
                    [tempArray removeObject:cellmodel];
                    break;
                }
            }
            self.dataArray = [NSArray arrayWithArray:tempArray];
            [self.tableView reloadData];
        }else if(errorno==-5004){
            [weakSelf showHudWithText:@"网络错误"];
            [weakSelf hideHudDelay:2.0];
        }else{
            [weakSelf showHudWithText:[NSString stringWithFormat:@"%d错误",errorno]];
            [weakSelf hideHudDelay:2.0];
        }
    }];
}

@end
