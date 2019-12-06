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
    self.title = @"关于芯盾";
    [self customUI];
    [self requestData];
}

-(void)requestData{
    if (!_titleArr) {
        _titleArr = @[@"软件名称",@"软件版本",@"联系电话",@"官网地址"];
    }
    if (!_imgsArr) {
        _imgsArr = @[@"aboutTrusapp",@"aboutTrusversion",@"aboutTrusphone",@"aboutTrusnet"];
    }
    NSDictionary *dic = [[NSBundle mainBundle]infoDictionary];
    
    NSString *version =  dic[@"CFBundleShortVersionString"];
    NSString *bundleVersion = dic[@"CFBundleVersion"];
    NSString *vstr = [NSString stringWithFormat:@"V%@(%@)",version,bundleVersion];
    if (!_txtArr) {
        _txtArr = @[@"善认·一站式移动身份管理(IDaaS)",vstr,@"010-58818526   4008180110",@"http://www.trusfort.com/"];
    }
    [_myTableView reloadData];
}

-(void)customUI{
    //图标
    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENW/2.f - 50, 64+26, 100, 100)];
    [self.view addSubview:iconImgView];
    iconImgView.image = [UIImage imageNamed:@"aboutTrusbg"];
    
    //介绍
    NSString *wordStr = @"北京芯盾时代科技有限公司总部位于北京，专注于移动互联网身份保护及身份认证领域，以构建安全、便利、智慧的移动互联网应用环境为己任！";
    TRUHomeSizeLabel *aboutUsLabel = [[TRUHomeSizeLabel alloc] initWithFrame:CGRectMake(15, 220, SCREENW - 30, 90) withText:wordStr font:[UIFont systemFontOfSize:14] lineheight:10 backGroundColor:ViewDefaultBgColor wordColor:[UIColor grayColor]];
    [self.view addSubview:aboutUsLabel];
    
    
    //infoview
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 330, SCREENW - 30, 200) style:UITableViewStylePlain];
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
        aboutUsLabel.frame = CGRectMake(15, 250, SCREENW - 30, 90);
        _myTableView.y = 360;
    }

}
#pragma mark -UITableViewDelegate,UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
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
