//
//  TRUAPPLogIdentifyController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/29.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUAPPLogIdentifyController.h"
#import "TRULogIdentifyCell.h"
#import "TRUFingerGesUtil.h"
#import "TRUGestureSettingViewController.h"
#import "TRUVerifyFingerprintViewController.h"
#import "TRUGestureVerifyViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "TRUGestureModify1ViewController.h"
#import "TRUVerifyFaceViewController.h"
//#import "TRUGestureVerify2ViewController.h"

@interface TRUAPPLogIdentifyController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *txtArr;
@end

@implementation TRUAPPLogIdentifyController
{
    BOOL isOnGesture;
    BOOL isOnFingerprint;
    BOOL isOnFaceID;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([TRUFingerGesUtil getLoginAuthFingerType]==TRULoginAuthFingerTypeNone&&[TRUFingerGesUtil getLoginAuthGesType]==TRULoginAuthGesTypeNone&&self.navigationController.viewControllers.count==1){
        self.isFirstRegist = YES;
    }
    [self requestData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
}

-(void)requestData{
    isOnGesture = isOnFaceID = isOnFingerprint = NO;
    //同步用户验证方式
    if (!_txtArr) {
        _txtArr = [NSMutableArray array];
    }
    [_txtArr removeAllObjects];
    NSArray *array;
    //首先判断用户是不是iPhone X且支持Face ID验证
    if ([self checkFaceIDAvailable]) {
        array = @[@"手势验证",@"FaceID验证"];
    }else{
        if ([self checkFingerAvailable]) {
            array = @[@"手势验证",@"指纹验证"];
        }else{
            array = @[@"手势验证"];
        }
    }
    
    [_txtArr addObject:array];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    //手势
    if ([TRUFingerGesUtil getLoginAuthGesType] == TRULoginAuthGesTypeture) {
        isOnGesture = YES;
        [arr addObject:@"手势修改"];
    }
    //指纹
    if ([TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeFinger) {
        isOnFingerprint = YES;
    }
    //人脸
    if ([TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeFace) {
        isOnFaceID = YES;
    }
    
    [_txtArr addObject:arr];
    [_myTableView reloadData];
}

-(void)customUI{
    
    self.title = @"APP登录验证";
    
    //图标
    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENW/2.f - 65, 64+26, 130, 120)];
    [self.view addSubview:iconImgView];
    iconImgView.image = [UIImage imageNamed:@"identifyIcon"];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 240, SCREENW, 50*4 +30) style:UITableViewStylePlain];
    [self.view addSubview:_myTableView];
    _myTableView.backgroundColor = [UIColor whiteColor];
    [_myTableView registerNib:[UINib nibWithNibName:@"TRULogIdentifyCell" bundle:nil] forCellReuseIdentifier:@"TRULogIdentifyCell"];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.tableFooterView = [UIView new];
    _myTableView.scrollEnabled = NO;
    _myTableView.backgroundColor = RGBCOLOR(247, 249, 250);
    
    if (kDevice_Is_iPhoneX) {
        iconImgView.frame = CGRectMake(SCREENW/2.f - 65, 64+50, 130, 120);
        _myTableView.frame = CGRectMake(0, 270, SCREENW, 50*4 +30);
    }else{
        iconImgView.frame = CGRectMake(SCREENW/2.f - 65, 64+26, 130, 120);
        _myTableView.frame = CGRectMake(0, 240, SCREENW, 50*4 +30);
    }
}
#pragma mark -UITableViewDelegate,UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2.f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = _txtArr[section];
    return [arr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TRULogIdentifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRULogIdentifyCell" forIndexPath:indexPath];
    cell.backgroundColor = RGBCOLOR(247, 249, 250);
    if (cell == nil) {
        cell = [[TRULogIdentifyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TRULogIdentifyCell"];
    }
    
    if (indexPath.section == 0) {
        cell.ArrowIcon.hidden = YES;
    }else{
        cell.isOnButton.hidden = YES;
    }
    
    if (indexPath.section == 0) {
        if (isOnGesture && indexPath.row == 0) {
            cell.isOnButton.selected = YES;
        }else if(isOnFingerprint && indexPath.row == 1){
            cell.isOnButton.selected = YES;
        }else if(isOnFaceID && indexPath.row == 1){
            cell.isOnButton.selected = YES;
        }else{
            cell.isOnButton.selected = NO;
        }
    }
    
    
    cell.txtLabel.text = _txtArr[indexPath.section][indexPath.row];
    NSString *str = _txtArr[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    __weak typeof(self) weakself = self;
    [cell setIsOnBlock:^(UIButton* btn){
        if (indexPath.row == 0) {//手势
            [weakself openCloseGesVerify:btn];
        }else{//指纹
            if ([str isEqualToString:@"FaceID验证"]) {
                [weakself openCloseFaceVefiry:btn];
            }else{
                [weakself openCloseFingerVefiry:btn];
            }
        }
    }];
    
    return cell;
}
#pragma mark 开启/关闭 手势/指纹验证
- (void)openCloseGesVerify:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.isSelected) {
        
        TRUGestureSettingViewController *gesVC = [[TRUGestureSettingViewController alloc] init];
        gesVC.isFirstRegist = self.isFirstRegist;
        gesVC.backBlocked =^(){
            [self requestData];
        };
        [self.navigationController pushViewController:gesVC animated:YES];
    }else{
        if (isOnGesture) {
            [self showConfrimCancelDialogViewWithTitle:@"" msg:@"您要关闭手势验证吗？" confrimTitle:@"确定" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
                [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
                [self requestData];
                //                TRUGestureVerify2ViewController *gesVC = [[TRUGestureVerify2ViewController alloc] init];
                //                gesVC.closeGesAuth = YES;
                //                [self.navigationController pushViewController:gesVC animated:YES];
                if([TRUFingerGesUtil getLoginAuthFingerType]==TRULoginAuthFingerTypeNone&&[TRUFingerGesUtil getLoginAuthGesType]==TRULoginAuthGesTypeNone&&self.navigationController.viewControllers.count>1){
                    id delegate = [UIApplication sharedApplication].delegate;
                    if ([delegate respondsToSelector:@selector(changeLoginRootVC)]) {
                        [delegate performSelector:@selector(changeLoginRootVC)];
                    }
                }
            } cancelBlock:^{
                btn.selected = !btn.selected;
            }];
        }
    }
}
- (void)openCloseFingerVefiry:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        
        TRUVerifyFingerprintViewController *fingerVC = [[TRUVerifyFingerprintViewController alloc] init];
        fingerVC.isFirstRegist = self.isFirstRegist;
        fingerVC.openFingerAuth = YES;
        [self.navigationController pushViewController:fingerVC animated:YES];
        fingerVC.backBlocked =^(BOOL ison){
            [self requestData];
        };
        
        //        if (isOnGesture) {//手势开启
        //            [self showConfrimCancelDialogViewWithTitle:@"" msg:@"开启指纹解锁将会关闭手势解锁" confrimTitle:@"确认" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
        //                [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
        //                TRUVerifyFingerprintViewController *fingerVC = [[TRUVerifyFingerprintViewController alloc] init];
        //                fingerVC.openFingerAuth = YES;
        //                [self.navigationController pushViewController:fingerVC animated:YES];
        //                fingerVC.backBlocked =^(BOOL ison){
        //                    [self requestData];
        //                };
        //            } cancelBlock:^{
        //                btn.selected = !btn.selected;
        //            }];
        //        }else{
        //            TRUVerifyFingerprintViewController *fingerVC = [[TRUVerifyFingerprintViewController alloc] init];
        //            fingerVC.openFingerAuth = YES;
        //            [self.navigationController pushViewController:fingerVC animated:YES];
        //            fingerVC.backBlocked =^(BOOL ison){
        //                [self requestData];
        //            };
        //        }
        
    }else{
        [self showConfrimCancelDialogViewWithTitle:@"" msg:@"您确定要关闭指纹登录验证" confrimTitle:@"确认" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
            YCLog(@"%d",[TRUFingerGesUtil getLoginAuthFingerType]);
            if([TRUFingerGesUtil getLoginAuthFingerType]==TRULoginAuthFingerTypeNone&&[TRUFingerGesUtil getLoginAuthGesType]==TRULoginAuthGesTypeNone&&self.navigationController.viewControllers.count>1){
                id delegate = [UIApplication sharedApplication].delegate;
                if ([delegate respondsToSelector:@selector(changeLoginRootVC)]) {
                    [delegate performSelector:@selector(changeLoginRootVC)];
                }
            }
        } cancelBlock:^{
            btn.selected = !btn.selected;
        }];
        
    }
}

- (void)openCloseFaceVefiry:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        
        TRUVerifyFaceViewController *faceVC = [[TRUVerifyFaceViewController alloc] init];
        faceVC.openFaceAuth = YES;
        faceVC.isFirstRegist = self.isFirstRegist;
        [self.navigationController pushViewController:faceVC animated:YES];
        faceVC.backBlocked =^(BOOL ison){
            [self requestData];
        };
        
        //        if (isOnFaceID) {//人脸开启
        //            [self showConfrimCancelDialogViewWithTitle:@"" msg:@"开启FaceID解锁将会关闭手势解锁" confrimTitle:@"确认" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
        //
        //                [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
        //                TRUVerifyFaceViewController *faceVC = [[TRUVerifyFaceViewController alloc] init];
        //                faceVC.openFaceAuth = YES;
        //                [self.navigationController pushViewController:faceVC animated:YES];
        //
        //            } cancelBlock:^{
        //                btn.selected = !btn.selected;
        //            }];
        //        }else{
        //            TRUVerifyFaceViewController *faceVC = [[TRUVerifyFaceViewController alloc] init];
        //            faceVC.openFaceAuth = YES;
        //            [self.navigationController pushViewController:faceVC animated:YES];
        //            faceVC.backBlocked =^(BOOL ison){
        //                [self requestData];
        //            };
        //        }
    }else{
        [self showConfrimCancelDialogViewWithTitle:@"" msg:@"您确定要关闭FaceID登录验证" confrimTitle:@"确认" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
        } cancelBlock:^{
            btn.selected = !btn.selected;
        }];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        NSArray *arr = _txtArr[1];
        if (arr.count > 0) {
            TRUGestureModify1ViewController *modify1VC = [[TRUGestureModify1ViewController alloc] init];
            [self.navigationController pushViewController:modify1VC animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 0;
    }else{
        return 30;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        UIView *iview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 30)];
        iview.backgroundColor = RGBCOLOR(247, 249, 250);
        return iview;
    }
}

- (BOOL)checkFingerAvailable{
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        return NO;
    }
    LAContext *ctx = [[LAContext alloc] init];
    
    if (![ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL]){
        return NO;
    }
    return YES;
}

- (BOOL)checkFaceIDAvailable{
    
    LAContext *ctx = [[LAContext alloc] init];
    if (@available(iOS 11.0, *)) {
        if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL]){
            if (ctx.biometryType == LABiometryTypeFaceID) {
                return YES;
            }else{
                return NO;
            }
        }else{
            return NO;
        }
        
    } else {
        YCLog(@"系统版本低于11.0");
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
