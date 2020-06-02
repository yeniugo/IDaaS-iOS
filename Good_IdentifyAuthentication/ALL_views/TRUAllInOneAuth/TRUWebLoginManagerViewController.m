//
//  TRUWebLoginManagerViewController.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2020/4/22.
//  Copyright © 2020 zyc. All rights reserved.
//

#import "TRUWebLoginManagerViewController.h"
#import "TRUWebLoginManagerCell.h"
#import "TRUWebLoginTopView.h"
#import "TRUUserAPI.h"
#import "xindunsdk.h"
#import "TRUhttpManager.h"
#import "NSDictionary+NULL.h"

#define SINGLE_LINE_WIDTH          (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET  ((1 / [UIScreen mainScreen].scale) / 2)

@interface TRUWebLoginManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) TRUWebLoginTopView *topView;
@property (nonatomic,strong) UIView *dataView;
@property (nonatomic,strong) UIView *noneDataView;
@property (nonatomic,copy) NSString *tgtId;
@property (nonatomic,assign) CGFloat tableviewheight;
@end

@implementation TRUWebLoginManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"WEB会话管理";
    self.navigationItem.leftBarButtonItem = nil;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"PushCancel"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self getWebLoginData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)rightBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getWebLoginData{
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    //同步用户信息
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/session/sessionDetail"] withParts:dictt onResult:^(int errorno, id responseBody) {
        if (errorno == 0 && responseBody ==nil) {
            weakSelf.noneDataView.hidden = NO;
//            self.dataView.hidden = YES;
        }else if(errorno == 0 && responseBody!=nil){
            weakSelf.dataView.hidden = NO;
            NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
            dic = [dic processDictionaryIsNSNull:dic];
            weakSelf.dataArray = dic[@"resp"][@"accessApp"];
            weakSelf.topView.viewDic = dic[@"resp"];
            weakSelf.tgtId = dic[@"resp"][@"tgtId"];
        }else if(errorno == 90022){
            weakSelf.noneDataView.hidden = NO;
        }else if (-5004 == errorno){
            weakSelf.noneDataView.hidden = NO;
            [weakSelf showHudWithText:@"网络错误，稍后请重试"];
            [weakSelf hideHudDelay:2.0];
        }else if (9008 == errorno){
            weakSelf.noneDataView.hidden = NO;
            [weakSelf deal9008Error];
        }else if (9019 == errorno){
            weakSelf.noneDataView.hidden = NO;
            [weakSelf deal9019Error];
        }else if (9025 == errorno){
            weakSelf.noneDataView.hidden = NO;
            [weakSelf showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"您的设备已被锁定，请联系管理员！" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
            } cancelBlock:^{
            }];
        }else{
            weakSelf.noneDataView.hidden = NO;
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
            //[NSString stringWithFormat:@"其他错误 %d", error];
            [weakSelf showHudWithText:err];
            [weakSelf hideHudDelay:2.0];
        }
    }];
}

+ (UIImage *)createImageWithFrame:(CGRect)frame{
    // 描述矩形
        CGRect rect = frame;
        
        // 开启位图上下文
        UIGraphicsBeginImageContext(rect.size);
        // 获取位图上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        // 使用color演示填充上下文
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        // 渲染上下文
        CGContextFillRect(context, rect);
        
        CGMutablePathRef path = CGPathCreateMutable();
    
        CGFloat pixelAdjustOffset = 0;
        if (((int)(1 * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
            pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
        }
        CGFloat xPos = 140 - pixelAdjustOffset;
        
        //2-1.设置起始点
        CGPathMoveToPoint(path, NULL, xPos, 70);
        //2-2.设置目标点
        CGPathAddLineToPoint(path, NULL, xPos, frame.size.height);
    //    CGPathAddLineToPoint(path, NULL, 50, 200);
        
        CGPathCloseSubpath(path);
        //3.将路径添加到上下文
        CGContextAddPath(context, path);
        
//        CGContextSetRGBFillColor(context,  0.898, 0.898, 0.898 ,1.0);
        
        CGContextSetRGBStrokeColor(context, 0.88, 0.88, 0.88,1.0);
        
    CGContextSetLineWidth(context, 1.0);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGPathRelease(path);
        // 从上下文中获取图片
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        // 结束上下文
        UIGraphicsEndImageContext();
        
        return image;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
//    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count*70>self.tableviewheight) {
        return 70;
    }else{
        if (indexPath.row + 1 == self.dataArray.count) {
            return self.tableviewheight + 2/[UIScreen mainScreen].scale - 70*(self.dataArray.count-1);
        }else{
            return 70;
        }
    }
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *TRUWebLoginManagerCellIndentifier=@"TRUWebLoginManagerCell";
    
    TRUWebLoginManagerCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:TRUWebLoginManagerCellIndentifier];
    if(!cell){
        cell=[[TRUWebLoginManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TRUWebLoginManagerCellIndentifier];
    }
    cell.cellDic = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.isFirst = YES;
    }
    return cell;
}

- (void)logout{
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    //同步用户信息
    NSString *sign = [NSString stringWithFormat:@"%@",self.tgtId];
    NSArray *ctxx = @[@"sid",self.tgtId];
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/session/teminateSession"] withParts:dictt onResult:^(int errorno, id responseBody) {
        if (errorno == 0) {
            [weakSelf showHudWithText:@"成功登出"];
            [weakSelf hideHudDelay:2.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }else if (9008 == errorno){
            [weakSelf deal9008Error];
        }else if (9019 == errorno){
//                [weakSelf deal9019Error];
            [weakSelf dele9019ErrorWithBlock:^{
            }];
        }else if (-5004 == errorno){
            [weakSelf showHudWithText:@"网络错误 请稍后重试"];
            [weakSelf hideHudDelay:2.0];
            
        }else{
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
            [weakSelf showHudWithText:err];
            [weakSelf hideHudDelay:2.0];
        }
    }];
}


- (UIView *)dataView{
    if (_dataView==nil) {
        _dataView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _dataView.hidden = YES;
        [self.view addSubview:_dataView];
        
        CGFloat topHeight = 151.0*SCREENW/375.0;
        TRUWebLoginTopView *topView = [[TRUWebLoginTopView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, SCREENW, topHeight)];
        [_dataView addSubview:topView];
        self.topView = topView;
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight + topHeight + 10,SCREENW , 13.5 + 20)];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,10,60,13.5)];
        label.font = [UIFont systemFontOfSize:14.0];
        label.text = @"访问应用";
        [headerView addSubview:label];
        [_dataView addSubview:headerView];
        
        CGFloat tableviewheight = SCREENH - kNavBarAndStatusBarHeight - topHeight -10 - kTabBarHeight - 33.5 + 7;
        self.tableviewheight = tableviewheight;
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight + topHeight + 10 + 33.5, SCREENW, tableviewheight) style:UITableViewStylePlain];
        self.tableView.bounces = NO;
        [_dataView addSubview:self.tableView];
        [self.tableView registerClass:[TRUWebLoginManagerCell class] forCellReuseIdentifier:@"TRUWebLoginManagerCell"];
        //    [self.tableView registerNib:[UINib nibWithNibName:@"TRUPersonalSmaillCell" bundle:nil] forCellReuseIdentifier:@"TRUPersonalSmaillCell"];
        self.tableView.backgroundColor = [UIColor clearColor];
//        self.tableView.backgroundColor = [UIColor redColor];
//        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[TRUWebLoginManagerViewController createImageWithFrame:CGRectMake(0, 0, SCREENW, tableviewheight)]];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableFooterView = [UIView new];
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENH - kTabBarBottom - 49, SCREENW, kTabBarBottom + 49)];
        int temp =  SCREENH - kTabBarBottom - 40 + 1/[UIScreen mainScreen].scale;
        footerView.backgroundColor = [UIColor whiteColor];
//        UIButton *footerLB = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 40)];
        UIButton *footerLB = [UIButton buttonWithType:UIButtonTypeCustom];
        footerLB.frame = CGRectMake(0, 0, SCREENW, 49);
//        footerLB.textAlignment = NSTextAlignmentCenter;
//        footerLB.text = @"会话登出";
        [footerLB setTitle:@"会话登出" forState:UIControlStateNormal];
//        footerLB.textColor = RGBCOLOR(255, 46, 41);
        [footerLB setTitleColor:RGBCOLOR(255, 46, 41) forState:UIControlStateNormal];
//        footerLB.font = [UIFont systemFontOfSize:15.0];
        footerLB.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [footerLB addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:footerLB];
        UIView *footerLine = [[UIView alloc] initWithFrame:CGRectMake(0, -1/[UIScreen mainScreen].scale, SCREENW, 1/[UIScreen mainScreen].scale)];
        footerLine.backgroundColor = RGBCOLOR(229, 229, 229);
        [footerView addSubview:footerLine];
        [_dataView addSubview:footerView];
    }
    return _dataView;
}

- (UIView *)noneDataView{
    if (_noneDataView == nil) {
        _noneDataView = [[UIView alloc] initWithFrame:self.view.bounds];
        _noneDataView.hidden = YES;
        [self.view addSubview:_noneDataView];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake((SCREENW - 75)*0.5, kNavBarAndStatusBarHeight + 68, 75, 71.5);
        imageView.image = [UIImage imageNamed:@"noWebLoginIcon"];
        [_noneDataView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,kNavBarAndStatusBarHeight + 173, SCREENW, 15)];
        label.text = @"当前没有WEB会话";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = RGBCOLOR(102, 102, 102);
        label.font = [UIFont systemFontOfSize:14.0];
        [_noneDataView addSubview:label];
    }
    return _noneDataView;
}

@end
