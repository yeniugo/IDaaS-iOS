/*
 * Copyright 2015 Huawei Technologies Co., Ltd. All rights reserved.
 * eSDK is licensed under the Apache License, Version 2.0 ^(the "License"^);
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *      http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>

@interface NSData(SvnData)


+ (instancetype)dataWithContentsOfFileSvn:(NSString *)path options:(NSDataReadingOptions)readOptionsMask error:(NSError **)errorPtr;
+ (instancetype)dataWithContentsOfFileSvn:(NSString *)path;

- (instancetype)initWithContentsOfFileSvn:(NSString *)path options:(NSDataReadingOptions)readOptionsMask error:(NSError **)errorPtr;
- (instancetype)initWithContentsOfFileSvn:(NSString *)path;

- (BOOL)writeToFileSvn:(NSString *)path atomically:(BOOL)useAuxiliaryFile;

@end


@interface NSString(SvnString)

+ (instancetype)stringWithContentsOfFileSvn:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)error;
+ (instancetype)stringWithContentsOfFileSvn:(NSString *)path usedEncoding:(NSStringEncoding *)enc error:(NSError **)error;


- (instancetype)initWithContentsOfFileSvn:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)error;
- (instancetype)initWithContentsOfFileSvn:(NSString *)path usedEncoding:(NSStringEncoding *)enc error:(NSError **)error;





- (BOOL)writeToFileSvn:(NSString *)path atomically:(BOOL)useAuxiliaryFile encoding:(NSStringEncoding)enc error:(NSError **)error;

@end



@interface NSMutableArray (SvnMutableArray)


+ (instancetype)arrayWithContentsOfFileSvn:(NSString *)path;
- (instancetype)initWithContentsOfFileSvn:(NSString *)path;


- (BOOL)writeToFileSvn:(NSString *)path atomically:(BOOL)useAuxiliaryFile;

@end



@interface NSMutableDictionary (SvnMutableDictionary)

+ (instancetype)dictionaryWithContentsOfFileSvn:(NSString *)path;
- (instancetype)initWithContentsOfFileSvn:(NSString *)path;

- (BOOL)writeToFileSvn:(NSString *)path atomically:(BOOL)useAuxiliaryFile;

@end




