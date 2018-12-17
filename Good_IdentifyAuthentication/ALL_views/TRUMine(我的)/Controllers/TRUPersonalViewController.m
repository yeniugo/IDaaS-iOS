//
//  TruPersonalViewController.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/30.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUPersonalViewController.h"
#import "TRUPersonalBigCell.h"
#import "TRUPersonalSmaillCell.h"
#import "TRUUserAPI.h"
#import "xindunsdk.h"
#import "TRUhttpManager.h"
@interface TRUPersonalViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *imageArray;//图标
@property (nonatomic,strong) NSArray *titleArray;//标题
@property (nonatomic,strong) NSArray *commitArray;//跳转控制器,字符串
@end

@implementation TRUPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    self.tableView.frame = CGRectMake(0, kNavBarAndStatusBarHeight, SCREENW, SCREENH-kTabBarHeight-kNavBarAndStatusBarHeight);
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"TRUPersonalBigCell" bundle:nil] forCellReuseIdentifier:@"TRUPersonalBigCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TRUPersonalSmaillCell" bundle:nil] forCellReuseIdentifier:@"TRUPersonalSmaillCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.imageArray = @[@[@"PersonalSafe"],@[@"PersonalAboutUS",@"PersonalFeedback"]];
    self.titleArray = @[@[@"APP安全验证"],@[@"关于我们",@"问题反馈"]];
    self.commitArray = @[@[@"TRUPersonalDetailsViewController"],@[@"TRUAPPLogIdentifyController"],@[@"TRUAboutUsViewController",@"TRUFeedbackViewController"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 86;
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    YCLog(@"heightForHeaderInSection");
    if (section==0) {
        return 0.01;
    }else{
        return 10;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    YCLog(@"heightForFooterInSection");
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    YCLog(@"cell.subviews.count = %d",cell.subviews.count);
//    cell.separatorInset = UIEdgeInsetsMake(0, SCREENW , 0, 0);
//    if (indexPath.section) {
//        NSArray *tempArray = self.titleArray[indexPath.section-1];
//        if (indexPath.row==tempArray.count-1) {
//            cell.separatorInset = UIEdgeInsetsMake(0, SCREENW , 0, 0);
//        }
//    }
//    if (cell.subviews.count>1) {
//        for (int i = 1;i<cell.subviews.count;i++) {
//            [cell.subviews[i] removeFromSuperview];
//        }
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YCLog(@"section = %d",section);
    
    return [self.commitArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.commitArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *bigCellIdentifier=@"TRUPersonalBigCell";
    static NSString *smallCellIdentifier=@"TRUPersonalSmaillCell";
    UITableViewCell *cell;
//    cell = [[UITableViewCell alloc] init];
//    return cell;
    if (indexPath.section==0) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:bigCellIdentifier forIndexPath:indexPath];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell = [self.tableView dequeueReusableCellWithIdentifier:smallCellIdentifier forIndexPath:indexPath];

    }
    if(!cell){
        if (indexPath.section==0) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:bigCellIdentifier];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:smallCellIdentifier];
        }
    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        TRUPersonalSmaillCell *smallCell = cell;
        NSString *imageName = self.imageArray[indexPath.section-1][indexPath.row];
        YCLog(@"imageName = %@",imageName);
        smallCell.icon.image = [UIImage imageNamed:imageName];
        NSString *titleStr = self.titleArray[indexPath.section-1][indexPath.row];
        YCLog(@"titleStr = %@",titleStr);
        smallCell.message.text = titleStr;
        cell.accessoryType = UITableViewCellAccessoryNone;
//        if (indexPath.row == [(NSArray *)(self.titleArray[indexPath.section-1]) count]-1) {
//            smallCell.isShowLine = NO;
//        }else{
//            smallCell.isShowLine = YES;
//        }
        return smallCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *classStr = self.commitArray[indexPath.section][indexPath.row];
    UIViewController *pushVC = [[NSClassFromString(classStr) alloc] init];
//    if ([classStr isEqual:@"TRUFaceSettingViewController"]||[classStr isEqualToString:@"TRUVoiceSettingViewController"]) {
//        TRUBaseNavigationController *nav = self.navigationController;
//        nav.backBlock = ^{
//            [weakSelf syncUserInfo];
//        };
//    }
    [self.navigationController pushViewController:pushVC animated:YES];
}

- (void)syncUserInfo{
    [self showHudWithText:@"正在同步用户信息..."];
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    //同步用户信息
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getuserinfo"] withParts:dictt onResult:^(int errorno, id responseBody) {
        NSDictionary *dicc = nil;
        [weakSelf hideHudDelay:0.0];
        if (errorno == 0 && responseBody) {
            dicc = [xindunsdk decodeServerResponse:responseBody];
            if ([dicc[@"code"] intValue] == 0) {
                dicc = dicc[@"resp"];
                //用户信息同步成功
                TRUUserModel *model = [TRUUserModel modelWithDic:dicc];
                model.userId = userid;
                [TRUUserAPI saveUser:model];
            }else if (9019 == errorno){
                [weakSelf deal9019Error];
            }
        }
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
