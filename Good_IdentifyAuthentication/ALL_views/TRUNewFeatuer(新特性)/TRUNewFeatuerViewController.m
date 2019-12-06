//
//  TRUNewFeatuerViewController.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/2/9.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUNewFeatuerViewController.h"
#import "TRUVersionUtil.h"


#define kScreen_height  [[UIScreen mainScreen] bounds].size.height
#define kScreen_width   [[UIScreen mainScreen] bounds].size.width
@interface TRUNewFeatuerViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *featureImgArray;

/**
 *  选中page的指示器颜色，默认白色
 */
@property (nonatomic, strong) UIColor *currentColor;
/**
 *  其他状态下的指示器的颜色，默认
 */
@property (nonatomic, strong) UIColor *nomalColor;

@end

@implementation TRUNewFeatuerViewController
{
    UIScrollView  *launchScrollView;
    UIPageControl *page;
    
    //1
    UIImageView* Oneimgview1;
    UIImageView* Oneimgview2;
    UIImageView* Oneimgview3;
    UIImageView* Oneimgview4;
    
    //2
    UIImageView* Twoimgview1;
    UIImageView* Twoimgview2;
    UIImageView* Twoimgview3;
    UIImageView* Twoimgview4;
    
    //3
    UIImageView* Threeimgview1;
    UIImageView* Threeimgview2;
    UIImageView* Threeimgview3;
    UIImageView* Threeimgview4;
    
    //4
    UIImageView* Fourimgview1;
    UIImageView* Fourimgview2;
    UIImageView* Fourimgview3;
    UIImageView* Fourimgview4;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!_featureImgArray) {
        _featureImgArray = @[@"yindaoBG01.jpeg",@"yindaoBG02.jpeg",@"yindaoBG04.jpeg",@"yindaoBG03.jpeg"];
    }
    
    launchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    launchScrollView.showsHorizontalScrollIndicator = NO;
    launchScrollView.bounces = YES;
    launchScrollView.pagingEnabled = YES;
    launchScrollView.delegate = self;
    launchScrollView.contentSize = CGSizeMake(kScreen_width * 4, kScreen_height);
    [self.view addSubview:launchScrollView];
    float y = kScreen_height/2.f;
    for (int i = 0; i < 4; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreen_width, 0, kScreen_width, kScreen_height)];
        imageView.image = [UIImage imageNamed:_featureImgArray[i]];
        [launchScrollView addSubview:imageView];
        if (i ==0) {//第一张轮播页
            Oneimgview1 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width/2.f, y - 20, 50, 50)];
            Oneimgview1.image = [UIImage imageNamed:@"p103"];
            [imageView addSubview:Oneimgview1];
            
            Oneimgview2 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width - 40, y - 70, 150, 150)];
            Oneimgview2.image = [UIImage imageNamed:@"p101"];
            [imageView addSubview:Oneimgview2];
            
            Oneimgview3 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width, y -60, 50, 50)];
            Oneimgview3.image = [UIImage imageNamed:@"p102"];
            [imageView addSubview:Oneimgview3];
            
            Oneimgview4 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width, y+20, 50, 50)];
            Oneimgview4.image = [UIImage imageNamed:@"p104"];
            [imageView addSubview:Oneimgview4];
            
            [self appendAnimation:Oneimgview1 legth:130];
            [self appendAnimation:Oneimgview2 legth:kScreen_width/2.f + 30];
            [self appendAnimation:Oneimgview3 legth:90];
            [self appendAnimation:Oneimgview4 legth:90];
            
        }else if (i == 1){//第2张轮播页
            Twoimgview1 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width/2.f, y - 20, 50, 50)];
            Twoimgview1.image = [UIImage imageNamed:@"p204"];
            [imageView addSubview:Twoimgview1];
            
            Twoimgview2 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width - 40, y - 60, 150, 120)];
            Twoimgview2.image = [UIImage imageNamed:@"p201"];
            [imageView addSubview:Twoimgview2];
            
            Twoimgview3 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width, y -60, 50, 50)];
            Twoimgview3.image = [UIImage imageNamed:@"p202"];
            [imageView addSubview:Twoimgview3];
            
            Twoimgview4 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width, y+20, 50, 50)];
            Twoimgview4.image = [UIImage imageNamed:@"p203"];
            [imageView addSubview:Twoimgview4];
        }else if (i == 2){//第3张轮播页
            Fourimgview1 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width/2.f, y + 5, 50, 50)];
            Fourimgview1.image = [UIImage imageNamed:@"p404"];
            [imageView addSubview:Fourimgview1];
            
            Fourimgview2 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width - 70, y - 70, 180, 140)];
            Fourimgview2.image = [UIImage imageNamed:@"p401"];
            [imageView addSubview:Fourimgview2];
            
            Fourimgview3 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width, y -70, 50, 50)];
            Fourimgview3.image = [UIImage imageNamed:@"p402"];
            [imageView addSubview:Fourimgview3];
            
            Fourimgview4 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width, y+30, 50, 50)];
            Fourimgview4.image = [UIImage imageNamed:@"p403"];
            [imageView addSubview:Fourimgview4];
        }else if (i == 3){//第4张轮播页
            Threeimgview1 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width/2.f, y - 55, 50, 50)];
            Threeimgview1.image = [UIImage imageNamed:@"p304"];
            [imageView addSubview:Threeimgview1];
            
            Threeimgview2 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width - 70, y - 60, 180, 100)];
            Threeimgview2.image = [UIImage imageNamed:@"p301"];
            [imageView addSubview:Threeimgview2];
            
            Threeimgview3 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width, y -70, 50, 50)];
            Threeimgview3.image = [UIImage imageNamed:@"p303"];
            [imageView addSubview:Threeimgview3];
            
            Threeimgview4 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width, y+20, 50, 50)];
            Threeimgview4.image = [UIImage imageNamed:@"p302"];
            [imageView addSubview:Threeimgview4];
            
        }
    }
    
    //跳过
    CGRect iframe;
    if (kDevice_Is_iPhoneX) {
        iframe = CGRectMake(kScreen_width - 73, 60, 53, 30);
    }else{
        iframe = CGRectMake(kScreen_width - 73, 40, 53, 30);
    }
    UIButton *enterButton = [[UIButton alloc] initWithFrame:iframe];
    [enterButton setBackgroundImage:[UIImage imageNamed:@"yindaotiaoguo"] forState:UIControlStateNormal];
    [enterButton addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterButton];
//    imageView.userInteractionEnabled = YES;
    
    
    page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreen_height - 70, kScreen_width, 30)];
    page.numberOfPages = 4;
    page.backgroundColor = [UIColor clearColor];
    page.currentPage = 0;
    page.defersCurrentPageDisplay = YES;
    page.currentPageIndicatorTintColor = DefaultColor;
    page.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self.view addSubview:page];
   
}

-(void)enterBtnClick{
    [TRUVersionUtil saveCurrentVersion];
    UIApplication *app = [UIApplication sharedApplication];
    id appDelegate = app.delegate;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    // your override
    if ([appDelegate respondsToSelector:@selector(configRootBaseVCForApplication:WithOptions:)]) {
        [appDelegate performSelector:@selector(configRootBaseVCForApplication:WithOptions:) withObject:app withObject:nil];
        
    }
#pragma clang diagnostic pop
    
}

#pragma mark - scrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == launchScrollView) {
        int cuttentIndex = (int)(scrollView.contentOffset.x + kScreen_width/2)/kScreen_width;
        page.currentPage = cuttentIndex;
        __weak typeof(self) weakself = self;
        if (scrollView.contentOffset.x - 3*kScreen_width >30) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself enterBtnClick];
            });
            
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{//滚动停止
    if (scrollView == launchScrollView) {
        int cuttentIndex = (int)(scrollView.contentOffset.x + kScreen_width/2)/kScreen_width;
        
        [self setImageViewAnimationWithIndex:cuttentIndex];
    }
}

#pragma mark - 判断滚动方向
-(BOOL )isScrolltoLeft:(UIScrollView *) scrollView{
    //返回YES为向左反动，NO为右滚动
    if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].x < 0) {
        return YES;
    }else{
        return NO;
    }
} 

-(void)setImageViewAnimationWithIndex:(int)index{
    if (index == 0) {
        [self appendAnimation:Oneimgview1 legth:130];
        [self appendAnimation:Oneimgview2 legth:kScreen_width/2.f + 30];
        [self appendAnimation:Oneimgview3 legth:70];
        [self appendAnimation:Oneimgview4 legth:70];
    }else if (index == 1){
        [self appendAnimation:Twoimgview1 legth:130];
        [self appendAnimation:Twoimgview2 legth:kScreen_width/2.f + 30];
        [self appendAnimation:Twoimgview3 legth:70];
        [self appendAnimation:Twoimgview4 legth:70];
    }else if (index == 2){
        [self appendAnimation:Fourimgview1 legth:130];
        [self appendAnimation:Fourimgview2 legth:kScreen_width/2.f + 30];
        [self appendAnimation:Fourimgview3 legth:65];
        [self appendAnimation:Fourimgview4 legth:80];
       
    }else if (index == 3){
        [self appendAnimation:Threeimgview1 legth:130];
        [self appendAnimation:Threeimgview2 legth:kScreen_width/2.f + 30];
        [self appendAnimation:Threeimgview3 legth:60];
        [self appendAnimation:Threeimgview4 legth:78];
    }
}

-(void)appendAnimation:(UIImageView *)bgView legth:(float)length{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];///.y的话就向下移动。
    //是否设置fromValue，可以改变展示效果
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:-length];
    //随机数模拟不同速度
    int du = arc4random()%8;
    float dur;
    if (du <= 3) {
        dur = 0.6;
    }else{
        dur = du/8.0;
    }
    animation.duration = dur;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    animation.fillMode = kCAFillModeForwards;
    [bgView.layer addAnimation:animation forKey:@"moveBegin"];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
