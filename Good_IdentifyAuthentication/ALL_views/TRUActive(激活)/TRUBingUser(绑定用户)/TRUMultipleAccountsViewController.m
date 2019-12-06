//
//  TRUMultipleAccountsViewController.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/12/18.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUMultipleAccountsViewController.h"
#import "TRUMultipleAccountsCell.h"
#import "TRUUserAPI.h"
#import "TRUSelectModel.h"
#import "xindunsdk.h"
#import "TRUhttpManager.h"
#import "TRUAuthSacnViewController.h"
@interface TRUMultipleAccountsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UIButton *okBtn;
@property (strong,nonatomic) NSIndexPath *lastIndexPath;
@property (strong,nonatomic) NSMutableArray *selectArray;
@end

@implementation TRUMultipleAccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
        if (![self.navigationController.viewControllers[i] isKindOfClass:[TRUAuthSacnViewController class]]) {
            [tempArray addObject:self.navigationController.viewControllers[i]];
        }
    }
    self.navigationController.viewControllers = tempArray;
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBarHidden = NO;
    self.navigationBar.hidden = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"TRUMultipleAccountsCell" bundle:nil] forCellReuseIdentifier:@"TRUMultipleAccountsCell"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"TRUPersonalSmaillCell" bundle:nil] forCellReuseIdentifier:@"TRUPersonalSmaillCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:DefaultGreenColor];
    [button setTintColor:DefaultColor];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:button];
    button.frame = CGRectMake(26, SCREENH - kNavBarAndStatusBarHeight, SCREENW-52, 40);
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.okBtn = button;
//    self.selected = NO;
    if (self.selected) {
        self.title = @"选择身份账号";
        TRUUserModel *user = [TRUUserAPI getUser];
        self.multipleAccountsArray = [NSMutableArray array];
//        [self.multipleAccountsArray addObject:user];
        if (user.accounts) {
            [self.multipleAccountsArray addObjectsFromArray:user.accounts];
        }
        self.okBtn.hidden = NO;
        self.tableView.frame = CGRectMake(0, kNavBarAndStatusBarHeight, SCREENW, SCREENH-kTabBarHeight-kNavBarAndStatusBarHeight-20);
        self.selectArray = [NSMutableArray array];
        for (int i = 0; i < self.multipleAccountsArray.count; i++) {
            TRUSelectModel *model = [[TRUSelectModel alloc] init];
            model.selecte = NO;
            [self.selectArray addObject:model];
        }
    }else{
        self.title = @"其他身份账号";
        TRUUserModel *user = [TRUUserAPI getUser];
        self.multipleAccountsArray = [NSMutableArray array];
//        [self.multipleAccountsArray addObjectsFromArray:user.accounts];
        self.okBtn.hidden = YES;
        self.tableView.frame = CGRectMake(0, kNavBarAndStatusBarHeight, SCREENW, SCREENH-kNavBarAndStatusBarHeight);
        self.selectArray = [NSMutableArray array];
        for (int i = 0; i < user.accounts.count; i++) {
            NSString *userid = [TRUUserAPI getUser].userId;
            TRUSubUserModel *subUser = user.accounts[i];
            if (![subUser.userId isEqualToString:userid]) {
                [self.multipleAccountsArray addObject:user.accounts[i]];
                TRUSelectModel *model = [[TRUSelectModel alloc] init];
                model.selecte = NO;
                [self.selectArray addObject:model];
            }
            
        }
    }
    if (self.selected) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        self.lastIndexPath = indexPath;
//        [self.selectArray setObject:@(1) atIndexedSubscript:0];
        TRUSelectModel *model = self.selectArray[0];
        model.selecte = YES;
//        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
//    [self.tableView reloadData];
    [self syncUserInfo];
}

- (void)syncUserInfo{
    //    [self showHudWithText:@"正在同步用户信息..."];
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    //同步用户信息
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getuserinfo"] withParts:dictt onResult:^(int errorno, id responseBody) {
        NSDictionary *dicc = nil;
        //        [weakSelf hideHudDelay:0.0];
        if (errorno == 0 && responseBody) {
            dicc = [xindunsdk decodeServerResponse:responseBody];
            if ([dicc[@"code"] intValue] == 0) {
                dicc = dicc[@"resp"];
                //用户信息同步成功
                TRUUserModel *model = [TRUUserModel yy_modelWithDictionary:dicc];
                model.userId = userid;
                [TRUUserAPI saveUser:model];
                [self refreshUI];
            }else if (9019 == errorno){
                [weakSelf deal9019Error];
            }
        }
    }];
    
}

- (void)refreshUI{
    if (self.selected) {
        self.title = @"选择身份账号";
        TRUUserModel *user = [TRUUserAPI getUser];
        self.multipleAccountsArray = [NSMutableArray array];
        //        [self.multipleAccountsArray addObject:user];
        if (user.accounts) {
            [self.multipleAccountsArray addObjectsFromArray:user.accounts];
        }
        self.okBtn.hidden = NO;
        self.tableView.frame = CGRectMake(0, kNavBarAndStatusBarHeight, SCREENW, SCREENH-kTabBarHeight-kNavBarAndStatusBarHeight-20);
        self.selectArray = [NSMutableArray array];
        for (int i = 0; i < self.multipleAccountsArray.count; i++) {
            TRUSelectModel *model = [[TRUSelectModel alloc] init];
            model.selecte = NO;
            [self.selectArray addObject:model];
        }
    }else{
        self.title = @"其他身份账号";
        TRUUserModel *user = [TRUUserAPI getUser];
        self.multipleAccountsArray = [NSMutableArray array];
        //        [self.multipleAccountsArray addObjectsFromArray:user.accounts];
        self.okBtn.hidden = YES;
        self.tableView.frame = CGRectMake(0, kNavBarAndStatusBarHeight, SCREENW, SCREENH-kNavBarAndStatusBarHeight);
        self.selectArray = [NSMutableArray array];
        for (int i = 0; i < user.accounts.count; i++) {
            NSString *userid = [TRUUserAPI getUser].userId;
            TRUSubUserModel *subUser = user.accounts[i];
            if (![subUser.userId isEqualToString:userid]) {
                [self.multipleAccountsArray addObject:user.accounts[i]];
                TRUSelectModel *model = [[TRUSelectModel alloc] init];
                model.selecte = NO;
                [self.selectArray addObject:model];
            }
        }
    }
    if (self.selected) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        self.lastIndexPath = indexPath;
        //        [self.selectArray setObject:@(1) atIndexedSubscript:0];
        TRUSelectModel *model = self.selectArray[0];
        model.selecte = YES;
        //        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    TRUUserModel *user = [TRUUserAPI getUser];
//    self.multipleAccountsArray = [NSMutableArray array];
//    [self.multipleAccountsArray addObject:user];
//    if (user.accounts) {
//        [self.multipleAccountsArray addObjectsFromArray:user.accounts];
//    }
}

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    
}

- (void)buttonClick:(UIButton *)btn{
    if (self.backBlock) {
        NSString *userId;
        if (self.lastIndexPath.row==0) {
            TRUUserModel *user = self.multipleAccountsArray[self.lastIndexPath.row];
//            dic[@"userId"] = user.userId;
            userId = user.userId;
        }else{
            TRUSubUserModel *user = self.multipleAccountsArray[self.lastIndexPath.row];
//            dic[@"userId"] = user.userId;
            userId = user.userId;
        }
        __weak typeof(self) weakSelf = self;
//        [self dismissViewControllerAnimated:YES completion:^{
//            weakSelf.backBlock(userId);
//        }];
        
        weakSelf.backBlock(userId);
        [self.navigationController popViewControllerAnimated:NO];
//        [HAMLogOutputWindow printLog:@"popViewControllerAnimated"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.multipleAccountsArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *multipleAccountsCellIndentifier=@"TRUMultipleAccountsCell";
    
    UITableViewCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:multipleAccountsCellIndentifier];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:multipleAccountsCellIndentifier];
    }
    TRUMultipleAccountsCell *mutCell = cell;
    mutCell.cellModel = self.multipleAccountsArray[indexPath.row];
    mutCell.cellNeedSelect = self.selected;
//    YCLog(@"self.selectArray[indexPath.row] = %d,%@,indexPath.row = %d",self.selectArray[indexPath.row],self.selectArray,indexPath.row);
    TRUSelectModel *model = self.selectArray[indexPath.row];
    mutCell.cellSetSelectImage = model.selecte;
    return mutCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([indexPath isEqual:self.lastIndexPath]) {
        return;
    }
    NSIndexPath *tempIndexPath = self.lastIndexPath;
    // 改变上一次的
    if (tempIndexPath && tempIndexPath != indexPath) {
//        [self.selectArray setObject:@(0) atIndexedSubscript:tempIndexPath.row];
        TRUSelectModel *model = self.selectArray[tempIndexPath.row];
        model.selecte = NO;
        [self.tableView reloadRowsAtIndexPaths:@[tempIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
//    [self.selectArray setObject:@(1) atIndexedSubscript:indexPath.row];
    TRUSelectModel *model = self.selectArray[indexPath.row];
    model.selecte = YES;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    self.lastIndexPath = indexPath;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)didReceiveMemoryWarning{
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
