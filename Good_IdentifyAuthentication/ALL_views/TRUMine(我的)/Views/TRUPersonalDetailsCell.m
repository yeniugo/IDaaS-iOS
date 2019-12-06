//
//  TRUPersonalDetailsCell.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/31.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUPersonalDetailsCell.h"
#import "TRUAddPhoneViewController.h"
#import "TRUModifyInfoViewController.h"
#import "TRUUserAPI.h"
#import "xindunsdk.h"
#import "TRUhttpManager.h"
#import "TRUFingerGesUtil.h"
@interface TRUPersonalDetailsCell()
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellDetailsLabel;
@property (weak, nonatomic) IBOutlet UIButton *cellEditButton;
@property (weak, nonatomic) IBOutlet UILabel *cellCenterLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellDetailsRightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImageView;
@property (nonatomic,strong) UIView *lineView;//下划线
@end

@implementation TRUPersonalDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = RGBCOLOR(234, 234, 234);
    [self addSubview:self.lineView];
}
- (IBAction)editButtonClick:(UIButton *)sender {
//    [self performSelector: NSSelectorFromString(self.cellDate.selectStr)];
}
//编辑手机号
- (void)editCellPhone{
    if ([TRUUserAPI getUser].phone == nil || [TRUUserAPI getUser].phone.length == 0) {
        TRUAddPhoneViewController *addPhoneVC = [[TRUAddPhoneViewController alloc] init];
        [self.rootVC.navigationController pushViewController:addPhoneVC animated:YES];
    }else{
        TRUModifyInfoViewController *vc = [[TRUModifyInfoViewController alloc] init];
        [self.rootVC.navigationController pushViewController:vc animated:YES];
    }
}
//
-(void)unbind{
    NSString *userid = [TRUUserAPI getUser].userId;
    __weak TRUBaseViewController *weakVC = self.rootVC;
    [self.rootVC showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"此操作将会删除您手机内的账户信息，确定要解除绑定？" confrimTitle:@"解除绑定" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
        [weakVC showHudWithText:@"正在解除绑定..."];
        NSString *uuid = [xindunsdk getCIMSUUID:userid];
        
        NSArray *deleteDevices = @[uuid];
        NSString *deldevs = nil;
        if (!deleteDevices || deleteDevices.count == 0) {
            deldevs = @"";
        }else{
            deldevs = [deleteDevices componentsJoinedByString:@","];
        }
        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        NSArray *ctx = @[@"del_uuids",deldevs];
        NSString *sign = [NSString stringWithFormat:@"%@",deldevs];
        NSString *params = [xindunsdk encryptByUkey:userid ctx:ctx signdata:sign isDeviceType:NO];
        NSDictionary *paramsDic = @{@"params" : params};
        [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/device/delete"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
            [weakVC hideHudDelay:0.0];
            if (errorno == 0) {
                [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
                [TRUUserAPI deleteUser];
                //清除APP解锁方式
                [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
                [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                id delegate = [UIApplication sharedApplication].delegate;
                if ([delegate respondsToSelector:@selector(changeAvtiveRootVC)]) {
                    [delegate performSelector:@selector(changeAvtiveRootVC) withObject:nil];
                }
#pragma clang diagnostic pop
            }else if (-5004 == errorno){
                [weakVC showHudWithText:@"网络错误，请稍后重试"];
                [weakVC hideHudDelay:2.0];
            }else if (9008 == errorno){
                [weakVC deal9008Error];
            }else if (9019 == errorno){
                [weakVC deal9019Error];
            }else{
                NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
                [weakVC showHudWithText:err];
                [weakVC hideHudDelay:2.0];
            }
        }];
        
    } cancelBlock:^{
        
    }];
}



- (void)setCellDate:(TRUPersonalDetailsModel *)cellDate{
    _cellDate = cellDate;
    switch (cellDate.type) {
        case 0:
        {
            self.cellTitleLabel.hidden = NO;
            self.cellDetailsLabel.hidden = NO;
            self.cellEditButton.hidden = YES;
            self.cellCenterLable.hidden = YES;
            self.rightArrowImageView.hidden = YES;
            self.cellTitleLabel.text = cellDate.titleStr;
            self.cellDetailsLabel.text = cellDate.detailsStr;
            self.cellDetailsRightConstraint.constant = -16.0f;
        }
            break;
        case 1:
        {
            self.cellTitleLabel.hidden = NO;
            self.cellDetailsLabel.hidden = NO;
            self.cellEditButton.hidden = NO;
            self.cellCenterLable.hidden = YES;
            self.rightArrowImageView.hidden = YES;
            self.cellTitleLabel.text = cellDate.titleStr;
            self.cellDetailsLabel.text = cellDate.detailsStr;
            self.cellDetailsRightConstraint.constant = 10.0f;
        }
            break;
        case 2:
        {
            self.cellTitleLabel.hidden = YES;
            self.cellDetailsLabel.hidden = YES;
            self.cellEditButton.hidden = YES;
            self.cellCenterLable.hidden = NO;
            self.rightArrowImageView.hidden = YES;
            self.cellCenterLable.text = cellDate.centerStr;
        }
            break;
        case 3:
        {
            self.cellTitleLabel.hidden = NO;
            self.cellDetailsLabel.hidden = NO;
            self.cellEditButton.hidden = YES;
            self.cellCenterLable.hidden = YES;
            self.cellTitleLabel.text = cellDate.titleStr;
            self.cellDetailsLabel.text = cellDate.detailsStr;
            self.cellDetailsRightConstraint.constant = 10.0f;
        }
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.lineView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, -1);
}

@end
