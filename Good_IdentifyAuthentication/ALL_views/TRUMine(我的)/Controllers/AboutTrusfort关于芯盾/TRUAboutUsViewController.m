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
#import "TRUCompanyAPI.h"
#import <YYWebImage.h>
#import "xindunsdk.h"
#import "TRUCompanyModel.h"
#import "TRUhttpManager.h"

@interface TRUAboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *txtArr;
@property (nonatomic, strong) NSArray *imgsArr;
@property (nonatomic, strong)UIScrollView *myScrollView;
@end

@implementation TRUAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    
    [self requestSPinfo];
    [self customUI];
    
}

-(void)requestSPinfo{
    NSString *spcode = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL_SPCODE"];
    
    NSDictionary *dic = [[NSBundle mainBundle]infoDictionary];
    NSString *version =  dic[@"CFBundleShortVersionString"];
    NSString *bundleVersion = dic[@"CFBundleVersion"];
    NSString *vstr = [NSString stringWithFormat:@"V%@(%@)",version,bundleVersion];
    
    
        if (spcode.length>0) {
            __weak typeof(self) weakSelf = self;
            NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
            NSString *para = [xindunsdk encryptByUkey:spcode];
            NSDictionary *dict = @{@"params" : [NSString stringWithFormat:@"%@",para]};
            [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/getspinfo"] withParts:dict onResult:^(int errorno, id responseBody) {
                [weakSelf hideHudDelay:0.0];
                NSLog(@"--%d-->%@",errorno,responseBody);
                if (errorno == 0 && responseBody) {
                    NSDictionary *dictionary = [xindunsdk decodeServerResponse:responseBody];
                    NSLog(@"--->%@",dictionary);
                    if ([dictionary[@"code"] intValue] == 0) {
                        NSDictionary *dicc = dictionary[@"resp"];
                        TRUCompanyModel *companyModel = [TRUCompanyModel modelWithDic:dicc];
                        TRUCompanyModel *companyModel1 = [[TRUCompanyModel alloc] init];
                        companyModel1.cims_server_url = companyModel.cims_server_url;
                        companyModel1.activation_mode = companyModel.activation_mode;
                        companyModel.desc = dic[@"description"];
                        [TRUCompanyAPI saveCompany:companyModel1];
                        if (companyModel.telephone.length ==0 && companyModel.software_name.length ==0 && companyModel.website.length ==0) {
                            _titleArr = @[@"软件名称",@"软件版本",@"联系电话",@"官网地址"];
                            _imgsArr = @[@"aboutTrusapp",@"aboutTrusversion",@"aboutTrusphone",@"aboutTrusnet"];
                            _txtArr = @[@"善认·一站式移动身份管理",vstr,@"010-58818526/4008180110",@"http://www.trusfort.com/"];
                        }else{
                            if (companyModel.telephone.length>0) {
                                _titleArr = @[@"软件名称",@"软件版本",@"联系电话",@"官网地址"];
                                _imgsArr = @[@"aboutTrusapp",@"aboutTrusversion",@"aboutTrusphone",@"aboutTrusnet"];
                                _txtArr = @[companyModel.software_name,vstr,companyModel.telephone,companyModel.website];
                            }else{
                                _titleArr = @[@"软件名称",@"软件版本",@"官网地址"];
                                _imgsArr = @[@"aboutTrusapp",@"aboutTrusversion",@"aboutTrusnet"];
                                _txtArr = @[companyModel.software_name,vstr,companyModel.website];
                            }
                        }
                    }
                    [_myTableView reloadData];
                }
            }];

        }else{//默认
            _titleArr = @[@"软件名称",@"软件版本",@"联系电话",@"官网地址"];
            _imgsArr = @[@"aboutTrusapp",@"aboutTrusversion",@"aboutTrusphone",@"aboutTrusnet"];
            _txtArr = @[@"善认·一站式移动身份管理",vstr,@"010-58818526/4008180110",@"http://www.trusfort.com/"];
            [_myTableView reloadData];
        }
}

-(void)customUI{
    
    
    if (IS_IPHONE_5) {
        
        _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 65, SCREENW, SCREENH - 65)];
        [self.view addSubview:_myScrollView];
        _myScrollView.showsVerticalScrollIndicator = NO;
        _myScrollView.showsHorizontalScrollIndicator = NO;
        _myScrollView.contentSize = CGSizeMake(0, SCREENH+30);
        
        //图标
        UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENW/2.f - 50, 26, 100, 100)];
        [_myScrollView addSubview:iconImgView];
        NSString *imgurlstr = [TRUCompanyAPI getCompany].logo_url;
        [iconImgView yy_setImageWithURL:[NSURL URLWithString:imgurlstr] placeholder:[UIImage imageNamed:@"aboutTrusbg"]];
        
        //介绍
        NSString *wordStr = [TRUCompanyAPI getCompany].desc;
        if (wordStr.length == 0) {
            wordStr = @"北京芯盾时代科技有限公司总部位于北京，专注于移动互联网身份保护及身份认证领域，以构建安全、便利、智慧的移动互联网应用环境为己任！";
        }
        TRUHomeSizeLabel *aboutUsLabel = [[TRUHomeSizeLabel alloc] initWithFrame:CGRectMake(15, 150, SCREENW - 30, 90) withText:wordStr font:[UIFont systemFontOfSize:14] lineheight:10 backGroundColor:ViewDefaultBgColor wordColor:[UIColor grayColor]];
        [_myScrollView addSubview:aboutUsLabel];
        
        //infoview CGRectMake(15, 330, SCREENW - 30, 200)
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_myScrollView addSubview:_myTableView];
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
        [_myTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.right.equalTo(self.view).offset(-15);
            make.top.equalTo(aboutUsLabel.mas_bottom).offset(15);
            make.height.equalTo(@200);
        }];
        
    }else{
        //图标
        UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENW/2.f - 50, 64+26, 100, 100)];
        [self.view addSubview:iconImgView];
        NSString *imgurlstr = [TRUCompanyAPI getCompany].logo_url;
        [iconImgView yy_setImageWithURL:[NSURL URLWithString:imgurlstr] placeholder:[UIImage imageNamed:@"aboutTrusbg"]];
        
        //介绍
        NSString *wordStr = [TRUCompanyAPI getCompany].desc;
        if (wordStr.length == 0) {
            wordStr = @"北京芯盾时代科技有限公司总部位于北京，专注于移动互联网身份保护及身份认证领域，以构建安全、便利、智慧的移动互联网应用环境为己任！";
        }
        TRUHomeSizeLabel *aboutUsLabel = [[TRUHomeSizeLabel alloc] initWithFrame:CGRectMake(15, 220, SCREENW - 30, 90) withText:wordStr font:[UIFont systemFontOfSize:14] lineheight:10 backGroundColor:ViewDefaultBgColor wordColor:[UIColor grayColor]];
        [self.view addSubview:aboutUsLabel];
        
        //infoview CGRectMake(15, 330, SCREENW - 30, 200)
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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
        [_myTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.right.equalTo(self.view).offset(-15);
            make.top.equalTo(aboutUsLabel.mas_bottom).offset(15);
            make.height.equalTo(@200);
        }];
        
        if (kDevice_Is_iPhoneX){
            iconImgView.frame = CGRectMake(SCREENW/2.f - 50, 64+56, 100, 100);
            aboutUsLabel.frame = CGRectMake(15, 250, SCREENW - 30, 90);
            _myTableView.y = 360;
        }
    }
}
#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _txtArr.count;
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
    if (_txtArr.count == 3) {
        return 66.6f;
    }else{
        return 50.f;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
