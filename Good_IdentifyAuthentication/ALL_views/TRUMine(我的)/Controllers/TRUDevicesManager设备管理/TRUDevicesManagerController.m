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
    NSString *userid = [TRUUserAPI getUser].userId;
    [self.deviceList removeAllObjects];
    [xindunsdk getCIMSActivedDeviceListForUser:userid onResult:^(int error, id response) {
        [self hideHudDelay:0.0];
        if (error == 0) {
            
            id deviceinfos = [response objectForKey:@"deviceinfos"];
            if ([deviceinfos isKindOfClass:[NSArray class]]) {
                for (id dicres in deviceinfos) {
                    
                    if ([dicres isKindOfClass:[NSDictionary class]]) {
                       
                        NSDictionary *dic = (NSDictionary *)dicres;
                        TRUDeviceModel *model = [TRUDeviceModel modelWithDic:dic];
                        if ([model.ifself isEqualToString:@"1"]) {
                            [self.deviceList insertObject:model atIndex:0];
                        }else{
                            [self.deviceList addObject:model];
                        }
                        
                    }
                }
                [self.myTableView reloadData];
                
            }
            
        }else if(-5004 == error){
            NSString *err = @"网络问题，请稍后重试";
            [self showHudWithText:err];
            [self hideHudDelay:2.0];
        }else if (9008 == error){
            [self deal9008Error];
        }else if (9019 == error){
            [self deal9019Error];
        }else{
            NSString *err = [NSString stringWithFormat:@"获取设备列表失败（%d）",error];
            [self showHudWithText:err];
            [self hideHudDelay:2.0];
        }
        
        
    }];
}
- (void)configPuchSetting:(UIButton *)sw model:(TRUDeviceModel *)model{
    __weak typeof(self) weakself = self;
    
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
        [weakself showHudWithText:@"更新推送设置..."];
//        sw.enabled = NO;
        [xindunsdk requestCIMSDevicePushConfigForUser:userid openDevices:opens closeDevices:close onResult:^(int error) {
            [weakself hideHudDelay:0.0];
            if (error == 0) {
                
                [weakself loadDeviceList];
                
            }else if (9019 == error){
                [self deal9019Error];
            }else{
                NSString *err = [NSString stringWithFormat:@"更新推送设置失败（%d）",error];
                [weakself showHudWithText:err];
                [weakself hideHudDelay:2.0];
            }
            
//            sw.enabled = YES;
        }];
    } cancelBlock:^{
//        sw.selected = !sw.selected;
    }];
    
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
    TRUDeviceModel *model = self.deviceList[indexPath.row];
    cell.deviceModel = model;
    __weak typeof(self) weakself = self;
    [cell setConfigPushBlock:^(UIButton* btn) {
        [weakself configPuchSetting:btn model:model];
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
    __weak typeof(self) weakself = self;
    NSString *msg = [NSString stringWithFormat:@"此操作将会删除您%@设备内全部账户信息，确定要删除？", model.devname];
    if ([model.ifself isEqualToString:@"1"]) {
        [self showConfrimCancelDialogViewWithTitle:@"" msg:msg confrimTitle:@"删除" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
            [weakself showHudWithText:@"正在解除绑定..."];
            NSString *uuid = [xindunsdk getCIMSUUID:userid];
            [xindunsdk requestCIMSDeviceDeleteForUser:userid deleteDevices:@[uuid] onResult:^(int error) {
                [weakself hideHudDelay:0];
                if (error == 0) {

                    [xindunsdk getDeviceId];
                    [xindunsdk deactivateAllUsers];
                    [TRUUserAPI deleteUser];
                    //清除APP解锁方式
                    [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                    id delegate = [UIApplication sharedApplication].delegate;
                    if ([delegate respondsToSelector:@selector(changeAvtiveRootVC)]) {
                        [delegate performSelector:@selector(changeAvtiveRootVC) withObject:nil];
                    }
#pragma clang diagnostic pop
                }else if (- 5004 == error){
                    [weakself showHudWithText:@"网络错误，请稍后重试"];
                    [weakself hideHudDelay:2.0];
                }else if (9019 == error){
                    [self deal9019Error];
                }else{
                    NSString *err = [NSString stringWithFormat:@"其他错误（%d）",error];
                    [weakself showHudWithText:err];
                    [weakself hideHudDelay:2.0];
                }
            }];
            
            
        } cancelBlock:^{
            [tableView setEditing:NO animated:YES];
        }];
    }else{
        [weakself showConfrimCancelDialogViewWithTitle:@"" msg:msg confrimTitle:@"删除" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
            [xindunsdk requestCIMSDeviceDeleteForUser:userid deleteDevices:@[model.uuid] onResult:^(int error) {
                if (error == 0) {
                    [weakself loadDeviceList];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kRefresh3DataNotification object:nil];
                }else if (-5004 == error){
                    
                    [weakself showHudWithText:@"网络错误，请稍后重试"];
                    [weakself hideHudDelay:2.0];
                    
                }else if (9019 == error){
                    [self deal9019Error];
                }else{
                    NSString *err = [NSString stringWithFormat:@"删除失败（%d）",error];
                    [weakself showHudWithText:err];
                    [weakself hideHudDelay:2.0];
                }
            }];
        } cancelBlock:^{
            [tableView setEditing:NO animated:YES];
        }];
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
