//
//  TFScanFingerprintView.h
//  Trusfort
//
//  Created by 黄怡菲 on 16/4/5.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TFScanMode) {
    TFScanModeNormal,
    TFScanModeSuccess,
    TFScanModeFail
};

@interface TRUScanFingerprintView : UIImageView

@property (nonatomic, assign)TFScanMode scanMode;

@end
