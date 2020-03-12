//
//  TRUDevicesManagerController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/29.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUDevicesManagerController.h"
#import "TRUDevicesManagerCell.h"
#import "TRUDeviceModel.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import "TRUFingerGesUtil.h"
#import "TRUhttpManager.h"
#import "TRUTokenUtil.h"
#import "AppDelegate.h"
@interface TRUDevicesManagerController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *deviceList;
@end

@implementation TRUDevicesManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备管理";
    [self customUI];
    [self loadDeviceList];
}
#pragma mark 网络请求
- (void)loadDeviceList{
    if (!_deviceList) {
        _deviceList = [NSMutableArray new];
    }
    [self showHudWithText:@"获取设备列表..."];
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    [self.deviceList removeAllObjects];
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:YES];
    NSDictionary *paramsDic = @{@"params" : paras};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/device/getlist"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        [weakSelf hideHudDelay:0.0];
        NSDictionary *dic = nil;
        if (errorno == 0 && ![responseBody isKindOfClass:[NSNull class]]) {
            dic = [xindunsdk decodeServerResponse:responseBody];
            if ([dic[@"code"] intValue] == 0) {
                dic = dic[@"resp"];
                id deviceinfos = [dic objectForKey:@"deviceinfos"];
                if ([deviceinfos isKindOfClass:[NSArray class]]) {
                    NSArray *arr = (NSArray *)deviceinfos;
                    for (id dicres in arr) {
                        if ([dicres isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *dic = (NSDictionary *)dicres;
                            TRUDeviceModel *model = [TRUDeviceModel modelWithDic:dic];
                            if ([model.ifself isEqualToString:@"1"]) {
                                [weakSelf.deviceList insertObject:model atIndex:0];
                            }else{
                                [weakSelf.deviceList addObject:model];
                            }
                        }
                    }
                    [weakSelf.myTableView reloadData];
                }
            }
        }else if(-5004 == errorno){
            NSString *err = @"网络问题，请稍后重试";
            [weakSelf showHudWithText:err];
            [weakSelf hideHudDelay:2.0];
        }else if (9008 == errorno){
            [weakSelf deal9008Error];
        }else if (9019 == errorno){
            [weakSelf deal9019Error];
        }else{
            NSString *err = [NSString stringWithFormat:@"获取设备列表失败（%d）",errorno];
            [weakSelf showHudWithText:err];
            [weakSelf hideHudDelay:2.0];
        }
    }];

}
- (void)configPuchSetting:(UIButton *)sw model:(TRUDeviceModel *)model{
    __weak typeof(self) weakSelf = self;
    
    NSString *userid = [TRUUserAPI getUser].userId;
    NSArray *opens = @[];
    NSArray *close = @[];
    if (!sw.selected) {
        opens = @[model.uuid];
    }else{
        close = @[model.uuid];
    }
    NSString *msg = @"";
    NSString *title = @"";
    if (!sw.selected) {
        title = @"是否开启";
        msg = @"是否确认开启APP一键推送功能？";
    }else{
        title = @"是否关闭";
        msg = @"是否确认关闭APP一键推送功能？";
    }
    [self showConfrimCancelDialogViewWithTitle:title msg:msg confrimTitle:@"确认" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
        [weakSelf closeOrOpen:opens andcloseDevices:close];
        
    } cancelBlock:^{
//        sw.selected = !sw.selected;
    }];
    
}

-(void)closeOrOpen:(NSArray *)openDevices andcloseDevices:(NSArray *)closeDevices{
    [self showHudWithText:@"更新推送设置..."];
    NSString *userid = [TRUUserAPI getUser].userId;
    if (userid) {
        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        NSString *opendevs = nil;
        NSString *closedevs = nil;
        if (!openDevices || openDevices.count == 0) {
            opendevs = @"";
        }else{
            opendevs = [openDevices componentsJoinedByString:@","];
        }
        if (!closeDevices || closeDevices.count == 0) {
            closedevs = @"";
        }else{
            closedevs = [closeDevices componentsJoinedByString:@","];
        }
        __weak typeof(self) weakSelf = self;
        NSString *sign = [NSString stringWithFormat:@"%@%@",opendevs,closedevs];
        NSArray *ctx = @[@"open_uuids",opendevs,@"close_uuids",closedevs];
        NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctx signdata:sign isDeviceType:NO];
        NSDictionary *paramsDic = @{@"params" : paras};
        [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/device/pushconfig"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
            [weakSelf hideHudDelay:0.0];
            if (errorno == 0) {
                [weakSelf loadDeviceList];
            }else if (9019 == errorno){
                [weakSelf deal9019Error];
            }else{
                NSString *err = [NSString stringWithFormat:@"更新推送设置失败（%d）",errorno];
                [weakSelf showHudWithText:err];
                [weakSelf hideHudDelay:2.0];
            }
        }];
    }
}

-(void)customUI{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, SCREENW, SCREENH - 64) style:UITableViewStylePlain];
    [self.view addSubview:_myTableView];
    _myTableView.backgroundColor = ViewDefaultBgColor;
    
    [_myTableView registerNib:[UINib nibWithNibName:@"TRUDevicesManagerCell" bundle:nil] forCellReuseIdentifier:@"TRUDevicesManagerCell"];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.tableFooterView = [UIView new];
    if (kDevice_Is_iPhoneX) {
        _myTableView.frame =CGRectMake(0, 90, SCREENW, SCREENH - 90);
    }else{
        _myTableView.frame =CGRectMake(0, 65, SCREENW, SCREENH - 65);
    }
}
#pragma mark -UITableViewDelegate,UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _deviceList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TRUDevicesManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRUDevicesManagerCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[TRUDevicesManagerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TRUDevicesManagerCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TRUDeviceModel *model = self.deviceList[indexPath.row];
    cell.deviceModel = model;
    __weak typeof(self) weakSelf = self;
    [cell setConfigPushBlock:^(UIButton* btn) {
        [weakSelf configPuchSetting:btn model:model];
    }];
    
    if (indexPath.section == 0) {
        
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    TRUDeviceModel *model = self.deviceList[indexPath.row];
    NSString *userid = [TRUUserAPI getUser].userId;
    __weak typeof(self) weakSelf = self;
    NSString *msg = [NSString stringWithFormat:@"此操作将会删除您%@设备内全部账户信息，确定要删除？", model.devname];
    if ([model.ifself isEqualToString:@"1"]) {
        [self showConfrimCancelDialogViewWithTitle:@"" msg:msg confrimTitle:@"删除" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
            [weakSelf showHudWithText:@"正在解除绑定..."];
            [self deleteDeviceUserid:userid andUuid:model.uuid isben:YES];
            
            
        } cancelBlock:^{
            [tableView setEditing:NO animated:YES];
        }];
    }else{
        [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:msg confrimTitle:@"删除" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
            [weakSelf showHudWithText:@"正在解除绑定..."];
            //删除设备
            [self deleteDeviceUserid:userid andUuid:model.uuid isben:NO];
        } cancelBlock:^{
            [tableView setEditing:NO animated:YES];
        }];
    }
    
    
}

-(void)deleteDeviceUserid:(NSString *)userid andUuid:(NSString *)uuid isben:(BOOL)isBen{
    
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSArray *deleteDevices = @[uuid];
    NSString *deldevs = nil;
    if (!deleteDevices || deleteDevices.count == 0) {
        deldevs = @"";
    }else{
        deldevs = [deleteDevices componentsJoinedByString:@","];
    }
    __weak typeof(self) weakSelf = self;
    NSArray *ctx = @[@"del_uuids",deldevs,@"confirm",@"localapp"];
    NSString *sign = [NSString stringWithFormat:@"%@%@",deldevs,@"localapp"];
    NSString *params = [xindunsdk encryptByUkey:userid ctx:ctx signdata:sign isDeviceType:NO];
    NSDictionary *paramsDic = @{@"params" : params};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/device/delete"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        [weakSelf hideHudDelay:0.0];
        if (errorno == 0) {
            if (isBen) {
                [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
                [TRUUserAPI deleteUser];
                //清除APP解锁方式
                [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
                [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
                [TRUTokenUtil cleanLocalToken];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                id delegate = [UIApplication sharedApplication].delegate;
                if ([delegate respondsToSelector:@selector(changeAvtiveRootVC)]) {
                    [delegate performSelector:@selector(changeAvtiveRootVC) withObject:nil];
                    AppDelegate *delegate1 = [UIApplication sharedApplication].delegate;
                    if (delegate1.thirdAwakeTokenStatus==2) {
                        delegate1.thirdAwakeTokenStatus=1;
                    }
                }
#pragma clang diagnostic pop
            }else{
                [weakSelf loadDeviceList];
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefresh3DataNotification object:nil];
            }
        }else if (-5004 == errorno){
            [weakSelf showHudWithText:@"网络错误，请稍后重试"];
            [weakSelf hideHudDelay:2.0];
        }else if (9019 == errorno){
            [weakSelf deal9019Error];
        }else{
            NSString *err = [NSString stringWithFormat:@"删除失败（%d）",errorno];
            [weakSelf showHudWithText:err];
            [weakSelf hideHudDelay:2.0];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
