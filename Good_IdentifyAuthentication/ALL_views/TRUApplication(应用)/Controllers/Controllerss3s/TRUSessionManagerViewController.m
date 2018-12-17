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
#import "TRUAuthModel.h"
#import <YYWebImage/UIImageView+YYWebImage.h>

#import "YCAlertView.h"


@interface TRUSessionManagerViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) UITableView *mainTable;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *stateArray;

@end

@implementation TRUSessionManagerViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录控制";
    
    
    UITableView *mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, SCREENW, SCREENH - 104) style:UITableViewStylePlain];
    mainTable.tableFooterView = [UIView new];
    mainTable.tableHeaderView = [UIView new];
    mainTable.dataSource = self;
    mainTable.delegate = self;
    [self.view addSubview:self.mainTable = mainTable];
    mainTable.backgroundColor = RGBCOLOR(247, 249, 250);
    [self initDataSource];
    
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
    NSString *user = [TRUUserAPI shareInstanceUserID];
    __weak typeof(self) weakSelf = self;
    
    YCAlertView *alertview = [[YCAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 160) withTitle:nil alertMessage:msg confrimBolck:^{
        [weakSelf showActivityWithText:@""];
        [xindunsdk requestCIMSSessionLogout:user appid:appid sid:model.sessionid onResult:^(int error){
            if (error == 0) {
                [weakSelf.dataSource removeObject:model];
                [weakSelf.mainTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                [weakSelf hideHudDelay:0];
                [weakSelf.mainTable reloadData];
            }else if (error == 5004){
                [weakSelf showHudWithText:@"网络错误，请稍后重试"];
                [weakSelf hideHudDelay:2.0];
            }else{
                [weakSelf showHudWithText:[NSString stringWithFormat:@"其他错误（%d）", error]];
                [weakSelf hideHudDelay:2.0];
            }
        }];
    } cancelBlock:^{
        
    }];
    [alertview show];

}

#pragma mark 获取门户登录信息
- (void)loadSSOLoginInfo{
    
    [self showActivityWithText:@""];
     NSString *user = [TRUUserAPI shareInstanceUserID];
    
    [xindunsdk getCIMSSessionList:user appid:@"10765be5a8ef4e1abcb8cdb0ed4e11c7" onResult:^(int error, id response) {
         if (error == 0) {
             [self.dataSource removeAllObjects];
             [self.stateArray removeAllObjects];
             NSLog(@"---->%@",response);
             for (NSDictionary *dic in response) {
                 TRUSessionManagerModel *model = [TRUSessionManagerModel modelWithDic:dic];
                 [self.dataSource addObject:model];
             
             }
             if (self.dataSource.count == 0) {
                 TRUSessionManagerModel *model = [[TRUSessionManagerModel alloc] init];
                 model.sessionid = @"SSOID";
                 [self.dataSource addObject:model];
             }
             [self.mainTable reloadData];
             [self hideHudDelay:0];
         
         }else if (error == 5004){
             [self showHudWithText:@""];
             [self hideHudDelay:2.0];
         }else{
             [self showHudWithText:[NSString stringWithFormat:@"其他错误（%d）", error]];
             [self hideHudDelay:2.0];
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
