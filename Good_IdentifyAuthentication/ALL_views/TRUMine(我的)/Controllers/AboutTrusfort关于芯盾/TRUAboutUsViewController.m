//
//  TRUAboutUsViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/29.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUAboutUsViewController.h"
#import "TRUHomeSizeLabel.h"
#import "TRUAboutUSCell.h"


@interface TRUAboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *txtArr;
@property (nonatomic, strong) NSArray *imgsArr;
@end

@implementation TRUAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"版本信息";
    [self customUI];
    [self requestData];
}

-(void)requestData{
    if (!_titleArr) {
        _titleArr = @[@"软件名称",@"版本号"];
    }
    if (!_imgsArr) {
        _imgsArr = @[@"softname",@"version"];
    }
    NSDictionary *dic = [[NSBundle mainBundle]infoDictionary];
    
    NSString *version =  dic[@"CFBundleShortVersionString"];
    //NSString *bundleVersion = dic[@"CFBundleVersion"];
    NSString *vstr = [NSString stringWithFormat:@"V%@",version];
    if (!_txtArr) {
        _txtArr = @[@"厦门国际银行OTP",vstr];
    }
    [_myTableView reloadData];
}

-(void)customUI{
    //图标
    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENW/2.f - 50, 64+26, 100, 100)];
    [self.view addSubview:iconImgView];
    iconImgView.image = [UIImage imageNamed:@"aboutImage"];
    
    //介绍
    //NSString *wordStr = @"北京芯盾时代科技有限公司总部位于北京，专注于移动互联网身份保护及身份认证领域，以构建安全、便利、智慧的移动互联网应用环境为己任！";
    //TRUHomeSizeLabel *aboutUsLabel = [[TRUHomeSizeLabel alloc] initWithFrame:CGRectMake(15, 220, SCREENW - 30, 90) withText:wordStr font:[UIFont systemFontOfSize:14] lineheight:10 backGroundColor:ViewDefaultBgColor wordColor:[UIColor grayColor]];
    //[self.view addSubview:aboutUsLabel];
    //icon下面问题
    NSString *titleStr = @"厦门国际银行股份有限公司";
    //TRUHomeSizeLabel *titleLable = [[TRUHomeSizeLabel alloc] initWithFrame:CGRectMake(0, 220, SCREENW, 20) withText:titleStr font:[UIFont systemFontOfSize:14] lineheight:10 backGroundColor:[UIColor clearColor] wordColor:[UIColor blackColor]];
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 220, SCREENW - 30, 90)];
    titleLable.text = titleStr;
    titleLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLable];
    
    
    //infoview
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 330, SCREENW - 30, 110) style:UITableViewStylePlain];
    [self.view addSubview:_myTableView];
    _myTableView.backgroundColor = [UIColor whiteColor];
    [_myTableView registerNib:[UINib nibWithNibName:@"TRUAboutUSCell" bundle:nil] forCellReuseIdentifier:@"TRUAboutUSCell"];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.tableFooterView = [UIView new];
    _myTableView.scrollEnabled = NO;
    _myTableView.layer.masksToBounds = YES;
    _myTableView.layer.cornerRadius = 3.f;
    _myTableView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _myTableView.layer.borderWidth = 1.f;
    
    if (kDevice_Is_iPhoneX) {
        iconImgView.frame = CGRectMake(SCREENW/2.f - 50, 64+56, 100, 100);
        titleLable.frame = CGRectMake(15, 250, SCREENW - 30, 20);
        _myTableView.y = 360;
    }

}
#pragma mark -UITableViewDelegate,UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TRUAboutUSCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRUAboutUSCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[TRUAboutUSCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TRUAboutUSCell"];
    }
    cell.txtLabel.text = _txtArr[indexPath.row];
    cell.titleLabel.text = _titleArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imgsArr[indexPath.row]]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
