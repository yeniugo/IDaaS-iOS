//
//  TRUPortalView.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/8/19.
//  Copyright © 2019 zyc. All rights reserved.
//

#import "TRUPortalView.h"
#import "TRUPortalCell.h"
#import "TRUAuthorizedWebViewController.h"
#import "TRUUserAPI.h"
#import "xindunsdk.h"
#import "TRUhttpManager.h"
#import "TRUPortalTitleView.h"
#import "TRUAuthBtn.h"
#import "MJRefresh.h"
@interface TRUPortalView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *portalView;
@property (nonatomic,strong) UIView *blankview;
@property (nonatomic,strong) TRUAuthBtn *authBtn;
@end

@implementation TRUPortalView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        
        UICollectionView *portalView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flow];
        portalView.contentInset = UIEdgeInsetsMake(10, 10, 0, 10);
        portalView.backgroundColor = [UIColor clearColor];
        [self addSubview:portalView];
        CGFloat header_y = 55 * PointWidthRatioX;
        // CGFloat top, left, bottom, right;
//        portalView.contentInset = UIEdgeInsetsMake(header_y, 0, 0, 0);
//        TRUPortalTitleView *portalTitle = [[TRUPortalTitleView alloc] initWithFrame:CGRectMake(0, -header_y, SCREENW, header_y)];
//        [portalView addSubview:portalTitle];
//        [portalView setContentOffset:CGPointMake(0, -header_y)];
        
        self.portalView = portalView;
        self.portalView.delegate = self;
        self.portalView.dataSource = self;
        [portalView registerClass:[TRUPortalCell class] forCellWithReuseIdentifier:@"TRUPortalCell"];
        
        flow.minimumInteritemSpacing = 0;
        flow.minimumLineSpacing = 0;
        [self addSubview:portalView];
        __weak typeof(self) weakSelf = self;
//        portalView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            if (weakSelf.refreshBlock) {
//                weakSelf.refreshBlock();
//            }
//            [weakSelf.portalView.mj_header endRefreshing];
//        }];
        
        TRUAuthBtn *authBtn = [[TRUAuthBtn alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 60 * PointWidthRatioX)];
        [self addSubview:authBtn];
        self.authBtn = authBtn;
        authBtn.hidden = YES;
        [authBtn addTarget:self action:@selector(authBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self.portalView reloadData];
    if (dataArray.count) {
        [self disBlankView];
    }else{
        [self showBlankView];
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *portalCellindex = @"TRUPortalCell";
    TRUPortalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:portalCellindex forIndexPath:indexPath];
    cell.cellModel = self.dataArray[indexPath.row];
//    if (self.dataArray.count > indexPath.row + 1) {
//        cell.cellModel = self.dataArray[indexPath.row];
//    }
//    if (indexPath.row == ((self.dataArray.count-1)/3)*3-3) {
//        cell.cellType = 1;
//    }else if(indexPath.row == ((self.dataArray.count-1)/3)*3-1){
//        cell.cellType = 2;
//    }else{
//        cell.cellType = 0;
//    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count ? ((self.dataArray.count-1)/3 +1)*3 :0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREENW-20.0)/3, (SCREENW-20.0)/3);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TRUPortalModel *cellmodel = self.dataArray[indexPath.row];
    if (self.portalClick) {
        self.portalClick(cellmodel);
    }
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeMake(SCREENW, 44 * PointWidthRatioX);
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // 头部视图
        // 代码初始化表头
        // [collectionView registerClass:[HeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView"];
        // xib初始化表头
//        [collectionView registerNib:[UINib nibWithNibName:@"HeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView"];
        [collectionView registerClass:[TRUPortalTitleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TRUPortalTitleView"];
        TRUPortalTitleView *tempHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TRUPortalTitleView" forIndexPath:indexPath];
        reusableView = tempHeaderView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        // 底部视图
    }
    return reusableView;
}

- (void)showBlankView{
    if (self.blankview) {
        self.blankview.hidden = NO;
    }else{
        UIView *blankview = [[UIView alloc] init];
        self.blankview = blankview;
        blankview.backgroundColor = [UIColor clearColor];
        UIImageView *addBlank = [[UIImageView alloc] init];
        [blankview addSubview:addBlank];
        addBlank.image = [UIImage imageNamed:@"portal_banner_blank"];
        [self.portalView addSubview:blankview];
        blankview.frame = self.bounds;
        addBlank.frame = CGRectMake(0, 0, 318/2.0, 237/2.0);
        addBlank.centerY = blankview.centerY*0.7;
        addBlank.centerX = blankview.centerX;
        UILabel *showlabel = [[UILabel alloc] init];
        showlabel.font = [UIFont systemFontOfSize:14.0];
        showlabel.textColor = RGBCOLOR(136, 136, 136);
        [blankview addSubview:showlabel];
        showlabel.textAlignment = NSTextAlignmentCenter;
        showlabel.text = @"暂时没有任何应用";
        showlabel.frame = CGRectMake(0, addBlank.centerY + 237/2.0/2.0 + 10, SCREENW, 20);
    }
}

- (void)disBlankView{
    self.blankview.hidden = YES;
}

- (void)authBtnClick:(UIButton *)btn{
    if (self.authBtnClick) {
        self.authBtnClick(self.model);
    }
}

- (void)setModel:(TRUPushAuthModel *)model{
    _model = model;
    if (model==nil) {
        self.authBtn.hidden = YES;
    }else{
        self.authBtn.hidden = NO;
        [self.authBtn setButtonTitle:[NSString stringWithFormat:@"正在登录【%@】",model.appname]];
    }
}
- (void)stopRefresh{
    [self.portalView.mj_header endRefreshing];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
