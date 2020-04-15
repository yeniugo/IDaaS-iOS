//
//  TRUMineViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/25.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUMineViewController.h"
#import "TRUMineUserInfoView.h"
#import "TRUMineMenuView.h"
#import "TRUMineCell.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import "TRUFingerGesUtil.h"
//跳转页面
#import "TRUAPPLogIdentifyController.h"
#import "TRUDevicesManagerController.h"
#import "TRUAboutUsViewController.h"
#import "TRUFeedbackViewController.h"
#import "TRUModifyInfoViewController.h"
#import "TRUAddPhoneViewController.h"
#import "TRUhttpManager.h"

@interface TRUMineViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)TRUMineUserInfoView *userinfoview;
@property (nonatomic, strong)UICollectionView *myCollectionView;
@property (nonatomic, strong)UIScrollView *myScrollView;
@property (nonatomic, strong)NSArray *imgsArr;
@property (nonatomic, strong)NSArray *titlesArr;



@end

@implementation TRUMineViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_imgsArr) {
        _imgsArr = @[@"apploginicon",@"deviceicon",@"abouticon",@"relieve"];
    }
    if (!_titlesArr) {
        _titlesArr = @[@"APP登录验证",@"设备管理",@"版本信息",@"解除绑定"];
    }
    [self customUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userinfoChange) name:@"changephonesuccess" object:nil];
}

-(void)userinfoChange{
    [_userinfoview setModel];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //同步一次用户信息
    NSString *currentUserId = [TRUUserAPI getUser].userId;
    
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *paras = [xindunsdk encryptByUkey:currentUserId ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getuserinfo"] withParts:dictt onResult:^(int errorno, id responseBody) {
        NSDictionary *dicc = nil;
        if (errorno == 0 && responseBody) {
            dicc = [xindunsdk decodeServerResponse:responseBody];
            if ([dicc[@"code"] intValue] == 0) {
                dicc = dicc[@"resp"];
                //用户信息同步成功
                TRUUserModel *model = [TRUUserModel modelWithDic:dicc];
                model.userId = currentUserId;
                [TRUUserAPI saveUser:model];
                //更新用户信息
                [_userinfoview setModel];
            }
        }
    }];
    
    self.scanBtn.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.scanBtn.hidden = YES;
}

-(void)customUI{

    
    //获取当前UIWindow 并添加一个视图
    UIApplication *ap = [UIApplication sharedApplication];
    [ap.keyWindow addSubview:self.scanBtn];
    
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 65, SCREENW, SCREENH - 118)];
    [self.view addSubview:_myScrollView];
    _myScrollView.showsVerticalScrollIndicator = NO;
    _myScrollView.showsHorizontalScrollIndicator = NO;
    _myScrollView.contentSize = CGSizeMake(0, SCREENH -60);

    //个人信息
    _userinfoview = [[TRUMineUserInfoView alloc] initWithFrame:CGRectMake(15, 80, SCREENW - 30, 190)];
    //菜单
    __weak typeof(self) weakself = self;
    _userinfoview.changePhoneBlock=^(){
        //换解绑手机
        if ([TRUUserAPI getUser].phone == nil || [TRUUserAPI getUser].phone.length == 0) {
            TRUAddPhoneViewController *addPhoneVC = [[TRUAddPhoneViewController alloc] init];
            [weakself.navigationController pushViewController:addPhoneVC animated:YES];
        }else{
            TRUModifyInfoViewController *vc = [[TRUModifyInfoViewController alloc] init];
            [weakself.navigationController pushViewController:vc animated:YES];
        }
    };
    //
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 290, SCREENW, SCREENW/4.f * 2 - 0.5f) collectionViewLayout:flowlayout];
    _myCollectionView.showsHorizontalScrollIndicator = NO;
    _myCollectionView.showsVerticalScrollIndicator = NO;
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    
    _myCollectionView.backgroundColor = RGBCOLOR(221, 223, 224);
    [_myCollectionView registerNib:[UINib nibWithNibName:@"TRUMineCell" bundle:nil] forCellWithReuseIdentifier:@"TRUMineCell"];
    _myCollectionView.scrollEnabled = NO;
    
    //适配4s，5，5s小屏幕
    if (SCREENW == 320){
        _myCollectionView.frame = CGRectMake(0, 230, SCREENW, SCREENW/4.f * 2 - 0.5f);
        _userinfoview.frame = CGRectMake(15, 20, SCREENW - 30, 190);
        [_myScrollView addSubview:_userinfoview];
        [_myScrollView addSubview:_myCollectionView];
    }else if (kDevice_Is_iPhoneX){
        _userinfoview.frame = CGRectMake(15, 130, SCREENW - 30, 190);
        _myCollectionView.frame = CGRectMake(0, 350, SCREENW, SCREENW/4.f * 2 - 0.5f);
        [self.view addSubview:_userinfoview];
        [self.view addSubview:_myCollectionView];
    }else{
        [self.view addSubview:_userinfoview];
        [self.view addSubview:_myCollectionView];
    }
}

#pragma mark - UICollectionViewDataSource+UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _titlesArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TRUMineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TRUMineCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.iconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imgsArr[indexPath.row]]];
    cell.titleLB.text = [NSString stringWithFormat:@"%@",_titlesArr[indexPath.row]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0://APP登陆验证
        {
            TRUAPPLogIdentifyController *logIdentifyVC = [[TRUAPPLogIdentifyController alloc] init];
            [self.navigationController pushViewController:logIdentifyVC animated:YES];
        }
            break;
        case 1://设备管理
        {
            TRUDevicesManagerController *managerVC = [[TRUDevicesManagerController alloc] init];
            [self.navigationController pushViewController:managerVC animated:YES];
        }
            break;
        case 2://关于芯盾
        {
            TRUAboutUsViewController *aboutUsVC = [[TRUAboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }
            break;
        case 3://解除绑定
        {
            NSString *userid = [TRUUserAPI getUser].userId;
            __weak typeof(self) weakself = self;
            [self showConfrimCancelDialogViewWithTitle:@"" msg:@"此操作将会删除您手机内全部账户信息，确定要解除绑定？" confrimTitle:@"解除绑定" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
                [weakself showHudWithText:@"正在解除绑定..."];
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
                    [weakself hideHudDelay:0.0];
                    if (errorno == 0) {
                        [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
                        [TRUUserAPI deleteUser];
                        //清除APP解锁方式
                        [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
                        [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                        id delegate = [UIApplication sharedApplication].delegate;
                        if ([delegate respondsToSelector:@selector(changRestDataVC)]) {
                            [delegate performSelector:@selector(changRestDataVC) withObject:nil];
                        }
#pragma clang diagnostic pop
                    }else if (-5004 == errorno){
                        [weakself showHudWithText:@"网络错误，请稍后重试"];
                        [weakself hideHudDelay:2.0];
                    }else if (9008 == errorno){
                        [weakself deal9008Error];
                    }else if (9019 == errorno){
                        [weakself deal9019Error];
                    }else{
                        NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
                        [weakself showHudWithText:err];
                        [weakself hideHudDelay:2.0];
                    }
                }];
                
                
            } cancelBlock:^{
                
            }];
        }
            break;
        default:
            break;
    }
}


//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}
//定义每个UICollectionViewCell 的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENW/2.f-2, SCREENW/4.f-2);
}
//列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1/MAXFLOAT;
}

//行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
