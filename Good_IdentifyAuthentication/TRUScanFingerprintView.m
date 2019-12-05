//
//  TFScanFingerprintView.m
//  Trusfort
//
//  Created by 黄怡菲 on 16/4/5.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import "TRUScanFingerprintView.h"

@interface TRUScanFingerprintView()

@property (nonatomic, strong) UIImage *successImage;
@property (nonatomic, strong) UIImage *failImage;
@property (nonatomic, strong) UIImage *normalImage;

@end

@implementation TRUScanFingerprintView

- (instancetype)initWithFrame:(CGRect)frame {
    TRUScanFingerprintView *ret = [super initWithFrame:frame];
    if (ret) {
        self.failImage = self.successImage = self.normalImage = [UIImage imageNamed:@"finger"];
//        self.successImage = [self convertImg:self.normalImage UsingColor:RGBCOLOR(0x99, 0xCC, 0)];
//        self.failImage = [self convertImg:self.normalImage UsingColor:RGBCOLOR(0xFF, 0x44, 44)];
    }
    return ret;
}

- (void)setScanMode:(TFScanMode)scanMode{
    _scanMode = scanMode;
    switch (scanMode) {
        case TFScanModeNormal:
            self.alpha = 1;
            self.image = self.normalImage;
            break;
        case TFScanModeFail:
            self.alpha = 0.8;
            self.image =  self.failImage;
            break;
        case TFScanModeSuccess:
            self.alpha = 0.8;
            self.image =  self.successImage;
            break;
        default:
            break;
    }
    if (scanMode != TFScanModeNormal) {
        [UIView animateWithDuration:1 animations:^{
            self.alpha = 0.4;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1 animations:^{
                self.alpha = 0.8;
            } completion:^(BOOL finished) {

            }];
        }];
    }
}


- (UIImage *)convertImg:(UIImage *) source UsingColor:(UIColor *) color{
    CGFloat r=0, g=0, b=0, a=0;
    if (![color getRed:&r green:&g blue:&b alpha:&a]) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    
    // First get the image into your data buffer
    CGImageRef image = [source CGImage];
    NSUInteger width = CGImageGetWidth(image);
    NSUInteger height = CGImageGetHeight(image);
    
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    
    // 改变rgb，只保留alpha
    long size = height * width;
    for (long i = 0; i < size; i ++) {
        NSUInteger byteIndex = i * 4;
        if (rawData[byteIndex + 3] != 0) {
            rawData[byteIndex] = r*255;
            rawData[byteIndex + 1] = g*255;
            rawData[byteIndex + 2] = b*255;
        }
    }
    
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rawData, bytesPerRow * height,nil);
    CGImageRef imageRef = CGImageCreate(width, height, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big, dataProvider,NULL, true, kCGRenderingIntentDefault);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    CGDataProviderRelease(dataProvider);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

@end
