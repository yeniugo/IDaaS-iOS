//
//  RadomMutableNumber.m
//  AuthenAnti_SpoofingDemo
//
//  Created by hukai on 2018/8/29.
//  Copyright © 2018年 Authen. All rights reserved.
//

#import "RadomMutableNumber.h"
#include <algorithm>
#include <iostream>
#include <vector>
using namespace std;
@implementation RadomMutableNumber
//Num数组总长度
//len取数组长度
+(NSArray *)randperm:(int)Num getLength:(int)len
{
    vector<int> temp;
    for (int i = 0; i < Num; ++i)
    {
        temp.push_back(i);
    }
    
    random_shuffle(temp.begin(), temp.end());
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < len; i++)
    {
        [array addObject: [NSNumber numberWithInt:temp[i]]];
    }
    return array;
}
@end
