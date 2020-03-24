//
//  TRUVoiceBaseViewController.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/5.
//  Copyright © 2017年 Trusfort. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "TRUVoiceBaseViewController.h"
#import "TRUDigitBlockInputView.h"
#import "YCAnimationNumberView.h"
#import "YCVoiceButton.h"
#import "TRUMTDTool.h"
@interface TRUVoiceBaseViewController ()<IFlyISVDelegate>

@property (nonatomic, strong) TRUDigitBlockInputView *inputView1;
@property (nonatomic, strong) TRUDigitBlockInputView *inputView2;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIImageView *animationView1;
@property (nonatomic, strong) UIImageView *animationView2;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, weak) YCAnimationNumberView *numberLabel;
@property (nonatomic, weak) UIImageView *animaImageView ;
@property (nonatomic, weak) UILongPressGestureRecognizer *longPressGesture;

@property (nonatomic, weak) UILabel *sstLabel;//训练组
//动画layer
@property (nonatomic, weak) CAReplicatorLayer *animLayer;
@property (nonatomic, strong) LOTAnimationView *btnBGlotview;

@end

@implementation TRUVoiceBaseViewController
{
    BOOL isFirst;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isFirst = YES;
    [self setupViews];
    self.isvRecognizer=[IFlyISVRecognizer sharedInstance];
    self.isvRecognizer.delegate = self;
    [self initPassword];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.isvRecognizer isListening]) {
        [self.isvRecognizer stopListening];
    }
}

- (void)setupViews {
 
    _vocieLotView = [LOTAnimationView animationNamed:@"voicebg.json"];
    [self.view addSubview:_vocieLotView];
    _vocieLotView.size = CGSizeMake(288, 308);
    _vocieLotView.x = SCREENW/2.f - 144;
    if (kDevice_Is_iPhoneX) {
        _vocieLotView.y = 95;
    }else{
        _vocieLotView.y = 65;
    }
    _vocieLotView.loopAnimation = YES;
    [_vocieLotView stop];
    
    
    
    
    YCAnimationNumberView *numberL = [[YCAnimationNumberView alloc] init];
    numberL.spacing = 2.0;
    numberL.isVoice = YES;
    if (kDevice_Is_iPhoneX) {
        numberL.textFont = [UIFont systemFontOfSize:28.0 * PointHeightRatio6];
    }else{
        numberL.textFont = [UIFont systemFontOfSize:32.0 * PointHeightRatio6];
    }
    ;
    [numberL setBgColor:ViewDefaultBgColor];
    numberL.size = CGSizeMake(180, 33);
    numberL.x = SCREENW/2.f - 90;
    numberL.centerY = _vocieLotView.centerY;
    [self.view addSubview:numberL];
    self.numberLabel = numberL;
    //
    UILabel *sstLabel = [[UILabel alloc] init];
    sstLabel.textColor = [UIColor blackColor];
    sstLabel.font = [UIFont systemFontOfSize:CommonTipFont * PointHeightRatio6];
    sstLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.sstLabel = sstLabel];
    sstLabel.size = CGSizeMake(180, 20);
    sstLabel.x = SCREENW/2.f - 90;
    sstLabel.centerY = _vocieLotView.centerY - 40;
    //
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"请按住按钮,读出上面的8位数字.\n读完一组数字,请松开.";
    tipLabel.textColor = RGBCOLOR(102, 102, 102);
    tipLabel.font = [UIFont systemFontOfSize:CommonTipFont * PointHeightRatio6];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    [self.view addSubview:tipLabel];
    tipLabel.size = CGSizeMake(SCREENW - 30, 50);
    tipLabel.x = 15;
    if (kDevice_Is_iPhoneX) {
        tipLabel.y = _vocieLotView.bottom +10;
    }else{
        tipLabel.y = _vocieLotView.bottom - 20;
    }
    
    
    _btnBGlotview = [LOTAnimationView animationNamed:@"voicebtnbg.json"];
    [self.view addSubview:_btnBGlotview];
    _btnBGlotview.size = CGSizeMake(120, 120);
    _btnBGlotview.x = SCREENW/2.f - 60;
    
    if (kDevice_Is_iPhoneX) {
        _btnBGlotview.y = _vocieLotView.bottom + 80;
    }else if (SCREENW == 750){
        _btnBGlotview.y = _vocieLotView.bottom + 30;
    }else{
        _btnBGlotview.y = _vocieLotView.bottom +20;
    }
    _btnBGlotview.hidden = YES;
    //
    YCVoiceButton *pressBtn = [YCVoiceButton buttonWithType:UIButtonTypeCustom];
    pressBtn.backgroundColor = DefaultGreenColor;
    [pressBtn addTarget:self action:@selector(startRecVoice) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.pressBtn = pressBtn];
    [pressBtn setImage:[UIImage imageNamed:@"mic3"] forState:UIControlStateNormal];
    pressBtn.size = CGSizeMake(80, 80);
    pressBtn.layer.cornerRadius = 40;
    pressBtn.layer.masksToBounds = YES;
    pressBtn.x = SCREENW/2.f - 40;
    pressBtn.centerY = _btnBGlotview.centerY;
    __weak typeof(self) weakSelf = self;
    pressBtn.TouchEndBlock =^(){
        [weakSelf.vocieLotView stop];
    };
    pressBtn.TouchBeganBlock =^(){
        AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (videoAuthStatus == AVAuthorizationStatusNotDetermined) {// 未询问用户是否授权
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
                [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                    if (granted) {
                        [self startRecVoice];
                        weakSelf.btnBGlotview.hidden = NO;
                        [weakSelf.vocieLotView play];
                        [weakSelf.btnBGlotview playWithCompletion:^(BOOL animationFinished) {
                            weakSelf.pressBtn.size = CGSizeMake(70, 70);
                            weakSelf.pressBtn.x = SCREENW/2.f - 35;
                            if (animationFinished) {
                                weakSelf.pressBtn.size = CGSizeMake(80, 80);
                                weakSelf.pressBtn.x = SCREENW/2.f - 40;
                            }
                        }];
                    } else {
                        [self showConfrimCancelDialogAlertViewWithTitle:@"未开启录音功能" msg:@"请到设置中开启声纹设置" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:nil cancelBlock:nil];
                    }
                }];
            }
        } else if(videoAuthStatus == AVAuthorizationStatusRestricted || videoAuthStatus == AVAuthorizationStatusDenied) {
            // 未授权
            [self showConfrimCancelDialogAlertViewWithTitle:@"未开启录音功能" msg:@"请到设置中开启声纹设置" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:nil cancelBlock:nil];
        } else{
            // 已授权
            [self startRecVoice];
            weakSelf.btnBGlotview.hidden = NO;
            [weakSelf.vocieLotView play];
            [weakSelf.btnBGlotview playWithCompletion:^(BOOL animationFinished) {
                weakSelf.pressBtn.size = CGSizeMake(70, 70);
                weakSelf.pressBtn.x = SCREENW/2.f - 35;
                if (animationFinished) {
                    weakSelf.pressBtn.size = CGSizeMake(80, 80);
                    weakSelf.pressBtn.x = SCREENW/2.f - 40;
                }
            }];
        }
        
    };
    
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.text = @"长按开始说话";
    bottomLabel.textColor = RGBCOLOR(102, 102, 102);
    bottomLabel.font = [UIFont systemFontOfSize:CommonTipFont * PointHeightRatio6];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bottomLabel];
    bottomLabel.size = CGSizeMake(120, 20);
    bottomLabel.x = SCREENW/2.f - 60;
    
    if (SCREENW == 320) {
        bottomLabel.y = pressBtn.bottom;
    }else{
        bottomLabel.y = pressBtn.bottom + 20;
    }
}

- (void)initPassword {
    self.passwords = [self newPassword];
}
- (void)setNumber:(NSString *)number{
    [self.numberLabel setNumberStr:number isFirst:isFirst];
    isFirst = NO;
}
- (void) initMsg:(NSString *) msg{
    if (msg.length != 8) {
        return;
    }
    self.inputView1.info = [msg substringWithRange:NSMakeRange(0, 4)];
    self.inputView2.info = [msg substringWithRange:NSMakeRange(4, 4)];
}

-(NSArray*)newPassword {
    NSArray* tmpArray=[self.isvRecognizer getPasswordList:PWDT_NUM_CODE];
    if( tmpArray == nil ){
        YCLog(@"in %s,请求数据有误",__func__);
        return nil;
    }
    YCLog(@"newPassword :%@", tmpArray);
    return tmpArray;
}
- (void)setIsvParamWithAuthId:(NSString *)auth_id withPassword:(NSString *) password withSSType:(NSString*)sst {
    if( self.isvRecognizer != nil ){
        [self.isvRecognizer setParameter:@"ivp" forKey:KEY_SUB];
        [self.isvRecognizer setParameter:[NSString stringWithFormat:@"%d",PWDT_NUM_CODE] forKey:KEY_PWDT];
        [self.isvRecognizer setParameter:@"50" forKey:KEY_TSD];
        [self.isvRecognizer setParameter:@"3000" forKey:KEY_VADTIMEOUT];
        [self.isvRecognizer setParameter:@"700" forKey:KEY_TAIL];
        [self.isvRecognizer setParameter:password forKey:KEY_PTXT];
        [self.isvRecognizer setParameter:auth_id forKey:KEY_AUTHID];
        [self.isvRecognizer setParameter:sst forKey:KEY_SST];            /* train or test */
        [self.isvRecognizer setParameter:@"180000" forKey:KEY_KEYTIMEOUT];
        [self.isvRecognizer setParameter:@"5" forKey:KEY_RGN];
    }else{
        YCLog(@"isvRec is nil\n");
    }
    
}

//正常结果返回回调
- (void)onResult:(NSDictionary *)dic {
//    [self.animaImageView stopAnimating];
    [self stopWaveAnimation];
    
}

//发生错误
- (void) onError:(IFlySpeechError *) errorCode {
    YCLog(@"onError:%d", errorCode.errorCode);
    [self stopWaveAnimation];
    //超时
    if (10114 == errorCode.errorCode) {
        [self showHudWithText:@"初始化语音引擎超时，请稍后重试"];
        [self hideHudDelay:2.0];
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:2.0];
//        [HAMLogOutputWindow printLog:@"popViewControllerAnimated"];
    }
}

//音量回调
-(void)onVolumeChanged:(int)volume {
}

//识别中回调
-(void)onRecognition {
    YCLog(@"onRecognition");
}
- (NSString *)generateVoiceId {
    NSString *userId =@""; //[TFUserProfile getCurrentUserId];
    if ((userId == nil) || [userId length] == 0) {
        return  nil;
    }
    NSString *suffixedId = [userId stringByAppendingString:@"82360154297"];
    NSString *vid = @"xd";
    
    NSArray *shuffler = [NSArray arrayWithObjects:@10, @1, @9, @0, @8, @5, @3, @7, @6, @2, @4, nil];
    for (int i = 0; i<11; i++) {
        long loc = [[shuffler objectAtIndex:i] integerValue];
        NSRange range = NSMakeRange(loc, 1);
        vid = [vid stringByAppendingString:[suffixedId substringWithRange:range]];
    }
    YCLog(@"vid=%@", vid);
    return vid;
}

- (void)startRecVoice{
    
}

- (void)stopWaveAnimation{
    [self.animLayer removeAllAnimations];
    [self.animLayer removeFromSuperlayer];
}
- (void)setSSTLable:(NSInteger)index total:(NSInteger)total{
    NSString *text = nil;
    if ([self.sst isEqualToString:TRAIN_SST]) {
        text = [NSString stringWithFormat:@"训练第%zd组数字，剩余%zd组",index,total - index];
    }else if ([self.sst isEqualToString:VERIFY_SST]){
        text = [NSString stringWithFormat:@"验证第%zd组，剩余%zd组",index,total - index];
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:DefaultGreenColor
                    range:NSMakeRange(10, 1)];
    self.sstLabel.attributedText = attrStr;
}
@end
