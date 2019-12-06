//
//  TRUVoiceInitViewController.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/5.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUVoiceInitViewController.h"
#import <iflyMSC/IFlySpeechConstant.h>
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import "YCVoiceButton.h"
#import "TRUhttpManager.h"

@interface TRUVoiceInitViewController ()
@property (nonatomic, assign) BOOL started;
@end

@implementation TRUVoiceInitViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册声纹";
    self.sst = TRAIN_SST;
    int err;
    NSString *authid = [xindunsdk getCIMSVoiceAuthIDForUser:[TRUUserAPI getUser].userId];
    [self.isvRecognizer sendRequest:@"del" authid:authid pwdt:3 ptxt:@"" vid:@"" err:&err];
    YCLog(@"结果 %d",err);
    
    NSString *ptString=[self numArrayToString:self.passwords];
    
    [self setIsvParamWithAuthId:authid withPassword:ptString withSSType:TRAIN_SST];
    
    [self setNumber:self.passwords.firstObject];
    [self setSSTLable:1 total:self.passwords.count];
}

-(void)startRecVoice {
    [super startRecVoice];
    [self.isvRecognizer startListening];//开始录音
}

-(void)onResult:(NSDictionary *)dic{
    [super onResult:dic];
    YCLog(@"init onResult");
    [self resultProcess:dic];
}

-(void)onError:(IFlySpeechError *)errorCode{
    YCLog(@"init onError:%d，--->%@", errorCode.errorCode,errorCode);
    [super onError:errorCode];
   
    
}

//数字密码 把array里面的数字 串起来,ISV 固定规则
-(NSString*)numArrayToString:(NSArray *)numArrayParam
{
    if( numArrayParam == nil ){
        YCLog(@"在%s中，numArrayParam is nil",__func__);
        return nil;
    }
    
    NSMutableString *ptxtString = [NSMutableString stringWithCapacity:1];
    [ptxtString appendString:[numArrayParam objectAtIndex:0]];
    
    for (int i = 1;i < [numArrayParam count] ; i++ ){
        NSString *str = [numArrayParam objectAtIndex:i];
        [ptxtString appendString:[NSString stringWithFormat:@"-%@",str]];
        
    }
    return  ptxtString;
}


//对声纹回调结果进行处理
-(void)resultProcess:(NSDictionary *)dic {
    if( dic == nil ){
        YCLog(@"in %s,dic is nil",__func__);
        return;
    }
    YCLog(@"%@",dic);
    NSNumber *suc=[dic objectForKey:SUC_KEY] ;
    YCLog(@"suc = %d",[suc intValue]);
    NSNumber *rgn=[dic objectForKey:RGN_KEY];
    if([suc intValue] >= [rgn intValue]){
        [self initMsg:@"训练成功"];
        NSString *voicid = dic[@"vid"];
        [self syncVoiceInfoVoiceID:voicid];
    } else {
        int suci = [suc intValue];
        [self setNumber:[self.passwords objectAtIndex:suci]];
        [self setSSTLable:(suci+1) total:self.passwords.count];
    }
}

// 0 关闭， 1 开启， 2 删除并关闭
-(void) setVoiceInfo {
    
}
- (void)syncVoiceInfoVoiceID:(NSString *)voiceID{
    NSString *userid = [TRUUserAPI getUser].userId;
    __weak typeof(self) weakSelf = self;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *sign = voiceID;
    NSArray *ctxx = @[@"voiceid",voiceID];
    //同步用户信息
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/voiceinfosync"] withParts:dictt onResult:^(int errorno, id responseBody) {
        [weakSelf hideHudDelay:0.0];
        if (errorno == 0) {
            
            TRUUserModel *model = [TRUUserAPI getUser];
            model.voiceid = voiceID;
            [TRUUserAPI saveUser:model];
            [weakSelf.navigationController popViewControllerAnimated:YES];
//            [HAMLogOutputWindow printLog:@"popViewControllerAnimated"];
        }else if (-5004 == errorno){//网络错误
            [weakSelf showHudWithText:@"网络错误，请稍后重试"];
            [weakSelf hideHudDelay:2.0];
            [weakSelf performSelector:@selector(popVC) withObject:nil afterDelay:2.0];
        }else if (9008 == errorno){//秘钥失效
            [weakSelf deal9008Error];
        }else if (9019 == errorno){
            [weakSelf deal9019Error];
        }else{//其他
            [weakSelf showHudWithText:@"声纹初始化失败，请稍后重试"];
            [weakSelf hideHudDelay:2.0];
            [weakSelf performSelector:@selector(popVC) withObject:nil afterDelay:2.0];
        }
    }];

}
- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
//    [HAMLogOutputWindow printLog:@"popViewControllerAnimated"];
}


@end
