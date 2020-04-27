//
//  TRUMailManagerViewController.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2020/4/23.
//  Copyright © 2020 zyc. All rights reserved.
//

#import "TRUMailManagerViewController.h"
#import "TRUMailManagerCell.h"
@interface TRUMailManagerViewController ()<UITableViewDelegate,UITableViewDataSource,TRUMailManagerCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
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
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataArray.count;
    return 50;
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
    cell.cellDic = [NSDictionary dictionary];
    return cell;
}

- (void)cellLogoutClickWith:(NSDictionary *)dic{
    
}

@end
