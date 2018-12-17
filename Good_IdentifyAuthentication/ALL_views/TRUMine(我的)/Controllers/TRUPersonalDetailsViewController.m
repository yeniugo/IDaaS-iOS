//
//  PersonalDetailsViewController.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/31.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUPersonalDetailsViewController.h"
#import "TRUPersonalDetailsModel.h"
#import "TRUPersonalDetailsCell.h"
#import "TRUUserAPI.h"
#import "xindunsdk.h"
#import "TRUhttpManager.h"
#import "TRUFingerGesUtil.h"
#import "TRUAddPhoneViewController.h"
#import "TRUModifyInfoViewController.h"
@interface TRUPersonalDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSourceArray;
@end

@implementation TRUPersonalDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self setDataSources];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    self.tableView.frame = CGRectMake(0, kNavBarAndStatusBarHeight, SCREENW, SCREENH-kNavBarAndStatusBarHeight);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"TRUPersonalDetailsCell" bundle:nil] forCellReuseIdentifier:@"TRUPersonalDetailsCell"];
    [self.view addSubview:self.tableView];
}

- (void)setDataSources{
    TRUPersonalDetailsModel *name = [[TRUPersonalDetailsModel alloc] init];
    name.titleStr = @"姓名";
    name.detailsStr = [TRUUserAPI getUser].realname;
    name.type = 0;
    TRUPersonalDetailsModel *department = [[TRUPersonalDetailsModel alloc] init];
    department.titleStr = @"部门";
    department.detailsStr = [TRUUserAPI getUser].department;
    department.type = 0;
    TRUPersonalDetailsModel *email = [[TRUPersonalDetailsModel alloc] init];
    email.titleStr = @"邮箱";
    email.detailsStr = [TRUUserAPI getUser].email;
    email.type = 0;
    TRUPersonalDetailsModel *userName = [[TRUPersonalDetailsModel alloc] init];
    userName.titleStr = @"用户名";
    userName.detailsStr = [TRUUserAPI getUser].employeenum;
    userName.type = 0;
    TRUPersonalDetailsModel *phone = [[TRUPersonalDetailsModel alloc] init];
    phone.titleStr = @"手机号";
    phone.detailsStr = [TRUUserAPI getUser].phone;
    phone.selectStr = @"editCellPhone";
    phone.type = 0;
    TRUPersonalDetailsModel *unbind = [[TRUPersonalDetailsModel alloc] init];
    unbind.centerStr = @"解除绑定";
    unbind.selectStr = @"unbind";
    unbind.type = 2;
    self.dataSourceArray = @[@[name,department,email,userName],@[phone],@[unbind]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0.01;
            break;
        case 1:
            return 10;
            break;
        case 2:
            return 40;
        default:
            return 0;
            break;
    }
    return 0;
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
    return 0;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *personaldetailIndentifier=@"TRUPersonalDetailsCell";
    
    UITableViewCell *cell;
//    if (indexPath.section==0) {
//        cell = [self.tableView dequeueReusableCellWithIdentifier:bigCellIdentifier];
//        return cell;
//    }else{
//        cell = [self.tableView dequeueReusableCellWithIdentifier:smallCellIdentifier];
//        return cell;
//    }
    cell = [self.tableView dequeueReusableCellWithIdentifier:personaldetailIndentifier];
    
    if(!cell){
        
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personaldetailIndentifier];
    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    TRUPersonalDetailsCell *smallCell = cell;
    //YCLog(@"smallCell.cellDate = %@",self.dataSourceArray[indexPath.section][indexPath.row]);
//    YCLog(@"cell = %@",smallCell);
    TRUPersonalDetailsModel *celldata = self.dataSourceArray[indexPath.section][indexPath.row];
    smallCell.cellDate = celldata;
//    YCLog(@"smallCell = %@,celldata = %@,smallCell.cellDate = %@",smallCell,celldata,smallCell.cellDate);
    smallCell.rootVC = self;
    return smallCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section==1) {
//        if ([TRUUserAPI getUser].phone == nil || [TRUUserAPI getUser].phone.length == 0) {
//            TRUAddPhoneViewController *addPhoneVC = [[TRUAddPhoneViewController alloc] init];
//            [self.navigationController pushViewController:addPhoneVC animated:YES];
//        }else{
//            TRUModifyInfoViewController *vc = [[TRUModifyInfoViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
    }else if (indexPath.section==2) {
        NSString *userid = [TRUUserAPI getUser].userId;
        __weak typeof(self) weakSelf = self;
        [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"此操作将会删除您手机内的账户信息，确定要解除绑定？" confrimTitle:@"解除绑定" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
            [weakSelf showHudWithText:@"正在解除绑定..."];
            NSString *uuid = [xindunsdk getCIMSUUID:userid];
            
            NSArray *deleteDevices = @[uuid];
            NSString *deldevs = nil;
            if (!deleteDevices || deleteDevices.count == 0) {
                deldevs = @"";
            }else{
                deldevs = [deleteDevices componentsJoinedByString:@","];
            }
            NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
            NSArray *ctx = @[@"del_uuids",deldevs];
            NSString *sign = [NSString stringWithFormat:@"%@",deldevs];
            NSString *params = [xindunsdk encryptByUkey:userid ctx:ctx signdata:sign isDeviceType:NO];
            NSDictionary *paramsDic = @{@"params" : params};
            [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/device/delete"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
                [weakSelf hideHudDelay:0.0];
                if (errorno == 0) {
                    [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
                    [TRUUserAPI deleteUser];
                    //清除APP解锁方式
                    [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
                    [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                    id delegate = [UIApplication sharedApplication].delegate;
                    if ([delegate respondsToSelector:@selector(changeAvtiveRootVC)]) {
                        [delegate performSelector:@selector(changeAvtiveRootVC) withObject:nil];
                    }
#pragma clang diagnostic pop
                }else if (-5004 == errorno){
                    [weakSelf showHudWithText:@"网络错误，请稍后重试"];
                    [weakSelf hideHudDelay:2.0];
                }else if (9008 == errorno){
                    [weakSelf deal9008Error];
                }else if (9019 == errorno){
                    [weakSelf deal9019Error];
                }else{
                    NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
                    [weakSelf showHudWithText:err];
                    [weakSelf hideHudDelay:2.0];
                }
            }];
            
        } cancelBlock:^{
            
        }];
    }
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
