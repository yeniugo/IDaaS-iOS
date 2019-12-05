//
//  TCSafe.h
//  TCSafe
//
//  Created by jinkeke@techshino.com on 16/5/16.
//  Copyright © 2016年 www.techshino.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    加载种子文件， 返回值>=0 成功，其他失败
    @seedFilePath 密钥或种子文件
 */
int TC_loadEncryptSeed(NSString *seedFilePath);

/**
    加密数据, 返回加密后的数据，成功返回NSData对象，失败返回 nil
    @imgB64 需要加密的图片Base64
    @terimalNum 终端号，必须10位
    @tokenNum token号，必须12位
 */
NSData *TC_encryptData(NSString *imgB64,NSString *terimalNum,NSString *tokenNum);

