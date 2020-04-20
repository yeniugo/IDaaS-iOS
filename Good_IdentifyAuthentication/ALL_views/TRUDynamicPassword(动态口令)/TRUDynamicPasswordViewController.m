//
//  TRUDynamicPasswordViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/25.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUDynamicPasswordViewController.h"
#import <Lottie/Lottie.h>
#import "YCAnimationNumberView.h"
#import "TRUTimeView.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import "TRUTimeSyncUtil.h"
#import "TRUHomeButton.h"
#import "UIButton+Touch.h"

@interface TRUDynamicPasswordViewController ()
@property (nonatomic, strong) CADisplayLink *dislink;
@property(nonatomic, strong) LOTAnimationView *aniationView;
@property(nonatomic, strong) YCAnimationNumberView *numberView;
@property(nonatomic, strong) TRUTimeView *timeView;
@property(nonatomic, strong) LOTAnimationView *refreshView;
@property(nonatomic, strong) TRUHomeButton *refreshBtn;
@property (nonatomic, strong)UILabel *numLabel;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong)UILabel *syncLabel;//时间同步按钮下面文字
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *lastPassword;
@property (atomic,assign) long gs_timeNow;
@property (atomic,assign) long gs_timelast;
@end

@implementation TRUDynamicPasswordViewController
NSInteger timeNum = 0;
static double dytime = 0.0;
BOOL isFirstEnter = YES;
BOOL isFirst = YES;
static NSString *userId;
extern long gs_time;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动态口令";
    userId = [TRUUserAPI getUser].userId;
    [self customUI];
    isFirstEnter = YES;
    self.refreshBtn.timeInterval = 0.5;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewBackGround) name:@"EnterForegroundDyPw" object:nil];
    
}



-(BOOL)checkNumberView{
    int labelNum = 0;
    for (id iview in self.numberView.subviews) {
        if ([iview isKindOfClass:[UILabel class]]) {
            labelNum++;
        }
    }
    if (labelNum >0) {
        return YES;
    }else{
        return NO;
    }
}


-(void)requestData{
    
//    _refreshBtn.enabled = NO;
    
    isFirstEnter = YES;
    [self showHudWithText:@"正在同步动态口令..."];
//    [self hideHudDelay:2.0];
    __weak typeof(self) weakSelf = self;
    [TRUTimeSyncUtil syncTimeWithResult:^(int error) {
        
        [self hideHudDelay:0.0];
        if (error == 0) {
            
            //            BOOL isss = [self checkNumberView];
            //            if (isss) {
            //                [self initTimeCountNotFirst];
            //            }else{
            //                isFirst = YES;
            //                [self initTimeCount];
            //            }
            [self initTimeCount];
            [self showHudWithText:@"同步成功"];
            [self hideHudDelay:2.0];
            
            
        }else if (error == -5004){
            [self showHudWithText:@"网络错误，稍后请重试"];
            [self hideHudDelay:2.0];
        }else if (9008 == error){
            [self deal9008Error];
        }else{
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",error];
            [self showHudWithText:err];
            [self hideHudDelay:2.0];
        }
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            weakSelf.refreshBtn.enabled = YES;
//        });
    }];
}

-(void)viewBackGround{
    [self requestData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    if (isFirstEnter) {
    //        [self initTimeCount];
    //    }else{
    //        [self initTimeCountNotFirst];
    //    }
    [self initTimeCount];
    [self startCountdown];
    //    [self requestData];
    self.scanBtn.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isFirst = isFirstEnter = YES;
    userId = [TRUUserAPI getUser].userId;
    dytime = 0.0;
    ////    [self initTimeCount];
    //    [self startCountdown];
    //    [self initTimeCountNotFirst];
    //    self.scanBtn.hidden = NO;
}

- (void)startCountdown{
    
    if (!self.dislink) {
        self.dislink = [CADisplayLink displayLinkWithTarget:self selector:@selector(setProgressNumber)];
        self.dislink.frameInterval = 60;
        [self.dislink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
}
//int tempTest;
- (void)setProgressNumber{//PERCENTKEY
//    YCLog(@"dytime = %f",dytime);
    
//    self.gs_timeNow = gs_time;
//    if (self.gs_timelast != self.gs_timeNow) {
//        self.gs_timelast = self.gs_timeNow;
//        YCLog(@"gs_time = %ld",gs_time);
//
//    if (self.gs_timeNow == 0) {
//        self.gs_timeNow = -1;
//    }else{
//        self.gs_timeNow = 0;
//    }
//    self.gs_timeNow = gs_time;
//    tempTest = tempTest +1 ;
//    if (tempTest%2 == 0) {
//        self.password = [xindunsdk getCIMSDynamicCode:userId temp:0];
//    }else{
//        self.password = [xindunsdk getCIMSDynamicCode:userId temp:1];
//    }
    if (dytime >= 1.0) {
//        YCLog(@"动态口令为 = %@",[xindunsdk getCIMSDynamicCode:userId]);
        [self.numberView setNumberStr:[xindunsdk getCIMSDynamicCode:userId] isFirst:NO];
        dytime = 0.0;
        [_aniationView stop];
        [_aniationView playFromProgress:dytime toProgress:1.0 withCompletion:nil];
        [_timeView startCountWithTime:29];
        [self startCountWithTime:29];
    }else{
        dytime = dytime + self.dislink.duration / 30.0 *60;
//        dytime = dytime + self.dislink.duration / 30.0;
    }
}
- (void)initTimeCountNotFirst{
    
    if (isFirstEnter) {
        dytime = [TRUTimeSyncUtil getTimePercent];
    }else{
        dytime = [TRUTimeSyncUtil getTimePercent] + [TRUTimeSyncUtil getTimeSpan];
        
    }
    
    if (dytime >= 1.0) {
        dytime = dytime - 1.0;
        
    }
    [_aniationView playFromProgress:dytime toProgress:1.0 withCompletion:nil];
    NSInteger num = (1 -dytime) *30 - 1;
    [_timeView startCountWithTime:num];
    isFirstEnter = NO;
    isFirst = NO;
}
- (void)initTimeCount{
    if (isFirstEnter) {
        dytime = [TRUTimeSyncUtil getTimePercent];
    }else{
        dytime = [TRUTimeSyncUtil getTimePercent] + [TRUTimeSyncUtil getTimeSpan];
    }
    
    if (dytime >= 1.0) {
        dytime = dytime - 1.0;
    }
    [self.numberView setNumberStr:[xindunsdk getCIMSDynamicCode:userId] isFirst:isFirst];
//    YCLog(@"动态口令为 = %@",[xindunsdk getCIMSDynamicCode:userId]);
    [_aniationView playFromProgress:dytime toProgress:1.0 withCompletion:nil];
    NSInteger num = (1 -dytime) *30 - 1;
    [_timeView startCountWithTime:num];
    [self startCountWithTime:num];
    isFirstEnter = NO;
    isFirst = NO;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.dislink invalidate];
    self.dislink = nil;
    
    [TRUTimeSyncUtil saveTimePercent:dytime];
    [TRUTimeSyncUtil saveCurrentTime];
    self.scanBtn.hidden = YES;
}


-(void)startCountWithTime:(NSInteger)timeNumber{
    [self stopCount];
    NSString *txt = [NSString stringWithFormat:@"%zdS", timeNumber];
    timeNum = timeNumber;
    self.numLabel.text = txt;
    
    __weak typeof(self) weskself = self;
    if (!self.timer){
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weskself selector:@selector(dealCount) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        weskself.timer = timer;
    }
}
-(void)stopCount{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)dealCount{
    timeNum -- ;
    if (timeNum >= 0) {
        NSString *txt = [NSString stringWithFormat:@"%zdS", timeNum];
        self.numLabel.text = txt;
    }else{
        [self stopCount];
    }
}

-(void)customUI{
    
    //获取当前UIWindow 并添加一个视图
    //    UIApplication *ap = [UIApplication sharedApplication];
    //    [ap.keyWindow addSubview:self.scanBtn];
    
    
    _aniationView = [LOTAnimationView animationNamed:@"dongtaikouling.json"];
    _aniationView.frame = CGRectMake(SCREENW/6.f, 80, SCREENW/3.f *2, SCREENW/2.f+30);
    
    
    
    self.numberView = [[YCAnimationNumberView alloc] initWithFrame:CGRectMake(SCREENW/12.f, SCREENW/3.f -(40.0 * PointHeightRatio6)/2.f - 10, SCREENW/2.f - 2, 40.0 * PointHeightRatio6)];
    self.numberView.spacing = 3.0;
    self.numberView.isVoice = NO;
    self.numberView.textFont = [UIFont systemFontOfSize:35.0 * PointHeightRatio6];
    [self.numberView setBgColor:ViewDefaultBgColor];
    [_aniationView addSubview:self.numberView];
    
    
    UIImageView *imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"passwordBG"]];
    imgview.frame = CGRectMake(0, 100 + SCREENW/2.f, SCREENW, 120);
    
    _timeView = [[TRUTimeView alloc] initWithFrame:CGRectMake((SCREENW - 170)/2.f, 230 + SCREENW/2.f, 170, 25) withTimelength:30];
    //    _timeView.hidden = YES;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 260 + SCREENW/2.f, SCREENW, 20)];
    label.text = @"如果多次输入动态密码验证失败请及时同步时间";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGBCOLOR(107, 108, 109);
    label.font = [UIFont systemFontOfSize:13];
    
    _refreshBtn = [[TRUHomeButton alloc] initWithFrame:CGRectMake((SCREENW -80*PointHeightRatio6)/2.f, 300 + SCREENW/2.f, 80*PointHeightRatio6, 80*PointHeightRatio6) withButtonClickEvent:^(TRUHomeButton *sender) {
//        sender.enabled = NO;
        [self requestData];
    }];
    [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"synctime"] forState:UIControlStateNormal];
    
    _syncLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300 + SCREENW/2.f + 80*PointHeightRatio6+8, SCREENW, 20)];
    if(kDevice_Is_iPhoneX){
        _syncLabel.frame = CGRectMake(0, 300 + SCREENW/2.f + 80*PointHeightRatio6+kNavBarAndStatusBarHeight, SCREENW, 20);
    }
    _syncLabel.text = @"同步时间";
    _syncLabel.textAlignment = NSTextAlignmentCenter;
    _syncLabel.textColor = RGBCOLOR(51, 51, 51);
    _syncLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_aniationView];
    [self.view addSubview:label];
    [self.view addSubview:_refreshBtn];
    [self.view addSubview:_timeView];
    [self.view addSubview:imgview];
    [self.view addSubview:_syncLabel];
    
    self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREENW - 50)/2.f, 260, 50, 20)];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    [self.numLabel setTextColor:RGBCOLOR(75, 159, 47)];
    [self.view addSubview:self.numLabel];
    self.numLabel.hidden = YES;
    if (SCREENW == 320) {
        _aniationView.frame = CGRectMake(SCREENW/4.f - 15, 80, SCREENW/2.f+30, SCREENW/3.f+60);
        self.numberView.frame = CGRectMake(SCREENW/12.f, SCREENW/4.f -(35.0 * PointHeightRatio6)/2.f + 10, SCREENW/3.f + 30, 35.0 * PointHeightRatio6);
        self.numberView.textFont = [UIFont systemFontOfSize:35.0 * PointHeightRatio6];
        imgview.frame = CGRectMake(0, 140 + SCREENW/3.f, SCREENW, 80);
        _timeView.frame = CGRectMake((SCREENW - 170)/2.f, 230 + SCREENW/3.f, 170, 25);
        label.frame = CGRectMake(0, 260 + SCREENW/3.f, SCREENW, 20);
        _refreshBtn.frame = CGRectMake((SCREENW -60)/2.f, 290 + SCREENW/3.f, 60, 60);
    }else if (kDevice_Is_iPhoneX){
        _aniationView.frame = CGRectMake(SCREENW/6.f, 130, SCREENW/3.f *2, SCREENW/2.f+30);
        imgview.frame = CGRectMake(0, 155 + SCREENW/2.f, SCREENW, 120);
        _timeView.frame = CGRectMake((SCREENW - 170)/2.f, 285 + SCREENW/2.f, 170, 25);
        label.frame = CGRectMake(0, 315 + SCREENW/2.f, SCREENW, 20);
        _refreshBtn.frame = CGRectMake((SCREENW -80)/2.f, 380 + SCREENW/2.f, 80, 80);
    }
}


- (void)dealloc{
    //    [super dealloc];
    YCLog(@"TRUDynamicPasswordViewController dealloc");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
