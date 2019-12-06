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
#import "Progressimage.h"

@interface TRUDynamicPasswordViewController ()
@property (nonatomic, strong) CADisplayLink *dislink;
@property(nonatomic, strong) Progressimage *progessimage;
@property(nonatomic, strong) YCAnimationNumberView *numberView;
@property(nonatomic, strong) TRUTimeView *timeView;
//@property(nonatomic, strong) LOTAnimationView *refreshView;
@property(nonatomic, strong) TRUHomeButton *refreshBtn;
@property (nonatomic, strong)UILabel *numLabel;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong)UILabel *syncLabel;//时间同步按钮下面文字
@property (nonatomic,assign) BOOL firstRun;
@end

@implementation TRUDynamicPasswordViewController

static NSString *userId;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动态口令";
    userId = [TRUUserAPI getUser].userId;
    [self customUI];
    self.firstRun = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewBackGround) name:@"EnterForegroundDyPw" object:nil];
}


-(void)requestData{
    _refreshBtn.enabled = NO;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *passwordStr = [xindunsdk getCIMSDynamicCode:userId];
    [self.numberView setNumberStr:passwordStr isFirst:!self.firstRun];
    [self showHudWithText:@"正在同步动态口令..."];
    [self hideHudDelay:2.0];
    __weak typeof(self) weakSelf = self;
    [TRUTimeSyncUtil syncTimeWithResult:^(int error) {
        [self hideHudDelay:0.0];
        if (error == 0) {
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.refreshBtn.enabled = YES;
        });
    }];
}

-(void)viewBackGround{
    //    [self requestData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.scanBtn.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startCountdown];
    //    [HAMLogOutputWindow printLog:@"动态口令界面显示"];
}

- (void)startCountdown{
    if (!self.dislink) {
        self.dislink = [CADisplayLink displayLinkWithTarget:self selector:@selector(runDisLink)];
        [self.dislink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        //        [HAMLogOutputWindow printLog:@"动态口令启动刷新"];
    }
}

- (void)runDisLink{
    CGFloat time = [self getPersent];
    //    NSString *timeStr= [NSString stringWithFormat:@"time1 = %f",time];
    //    [HAMLogOutputWindow printLog:timeStr];
    self.progessimage.progress = (float)time;
    //    NSString *timestr = [NSString stringWithFormat:@"%dS",29-(int)(time*30)];
    [self.timeView startCountWithTime:(29-(int)(time*30))];
}

- (CGFloat)getPersent{
    NSDate *date = [NSDate date];
    double time = [date timeIntervalSince1970];
    double timeDifference = [[[NSUserDefaults standardUserDefaults] objectForKey:@"GS_DETAL_KEY"] doubleValue];
    long time1 = (long)(time-timeDifference)/30;
    double time2 = [[NSUserDefaults standardUserDefaults] doubleForKey:@"password1"];
    if (self.firstRun) {
        [[NSUserDefaults standardUserDefaults] setDouble:(double)(time1) forKey:@"password1"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.firstRun = NO;
        //        [self requestData];
        NSString *userid = [TRUUserAPI getUser].userId;
        NSString *passwordStr = [xindunsdk getCIMSDynamicCode:userId];
        [self.numberView setNumberStr:passwordStr isFirst:!self.firstRun];
    }else{
        if ((long)time2!=time1) {
            YCLog(@"change------------");
            //            [self requestData];
            NSString *userid = [TRUUserAPI getUser].userId;
            NSString *passwordStr = [xindunsdk getCIMSDynamicCode:userId];
            [self.numberView setNumberStr:passwordStr isFirst:!self.firstRun];
            [[NSUserDefaults standardUserDefaults] setDouble:(double)(time1) forKey:@"password1"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
        }
    }
    return (long long)((time-timeDifference)*100)%3000/3000.0;
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.dislink invalidate];
    self.dislink = nil;
    self.scanBtn.hidden = YES;
}

-(void)customUI{
    self.numberView = [[YCAnimationNumberView alloc] initWithFrame:CGRectMake(SCREENW/12.f, (SCREENW/2.f+30)*0.4 , (SCREENW/3.f *2)*0.6, 40.0 * PointHeightRatio6)];
    self.numberView.spacing = 3.0;
    self.numberView.isVoice = NO;
    self.numberView.textFont = [UIFont systemFontOfSize:35.0 * PointHeightRatio6];
    [self.numberView setBgColor:ViewDefaultBgColor];
    
    
    self.progessimage = [[Progressimage alloc] init];
    [self.view addSubview:self.progessimage];
    self.progessimage.backgroundColor = [UIColor clearColor];
    self.progessimage.frame = CGRectMake(SCREENW/6.f, 80, SCREENW/3.f *2, SCREENW/2.f+30);
    [self.progessimage addSubview:self.numberView];
    self.numberView.frame = CGRectMake(SCREENW/12.f, (SCREENW/2.f+30)*0.4 , (SCREENW/3.f *2)*0.65, 40.0 * PointHeightRatio6);
    
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
        sender.enabled = NO;
        [self requestData];
    }];
    [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"synctime"] forState:UIControlStateNormal];
    
    _syncLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300 + SCREENW/2.f + 80*PointHeightRatio6+8, SCREENW, 20)];
    _syncLabel.text = @"同步时间";
    _syncLabel.textAlignment = NSTextAlignmentCenter;
    _syncLabel.textColor = RGBCOLOR(107, 108, 109);
    _syncLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.progessimage];
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
        self.progessimage.frame = CGRectMake(SCREENW/4.f - 15, 80, SCREENW/2.f+30, SCREENW/3.f+60);
        self.numberView.frame = CGRectMake(SCREENW/12.f, (SCREENW/2.f+30)*0.35 , (SCREENW/3.f *2)*0.57, 40.0 * PointHeightRatio6);
        self.numberView.textFont = [UIFont systemFontOfSize:35.0 * PointHeightRatio6];
        imgview.frame = CGRectMake(0, 140 + SCREENW/3.f, SCREENW, 80);
        _timeView.frame = CGRectMake((SCREENW - 170)/2.f, 230 + SCREENW/3.f, 170, 25);
        label.frame = CGRectMake(0, 260 + SCREENW/3.f, SCREENW, 20);
        _refreshBtn.frame = CGRectMake((SCREENW -60)/2.f, 290 + SCREENW/3.f, 60, 60);
    }else if (kDevice_Is_iPhoneX){
        self.progessimage.frame = CGRectMake(SCREENW/6.f, 130, SCREENW/3.f *2, SCREENW/2.f+30);
        imgview.frame = CGRectMake(0, 155 + SCREENW/2.f, SCREENW, 120);
        _timeView.frame = CGRectMake((SCREENW - 170)/2.f, 285 + SCREENW/2.f, 170, 25);
        label.frame = CGRectMake(0, 315 + SCREENW/2.f, SCREENW, 20);
        _refreshBtn.frame = CGRectMake((SCREENW -80)/2.f, 380 + SCREENW/2.f, 80, 80);
        _syncLabel.frame = CGRectMake((SCREENW -80)/2.f, 380 + SCREENW/2.f+88, 80, 20);
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
