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

@class SvnHttpSerialization;

@interface SvnHttpURLProtocol : NSURLProtocol<NSURLAuthenticationChallengeSender>
{
    NSCachedURLResponse *_cachedResponse;
    SvnHttpSerialization /* nonretained */ *_connection;	// where we have been queued up
	//NSMutableArray *_runLoops;				// additional runloops to schedule
	//NSMutableArray *_modes;						// additional modes to schedule
    
    NSURLAuthenticationChallenge *_challenge;

}

- (NSString *) _uniqueKey;	// a key to identify the same server connection

- (void) _setConnection:(SvnHttpSerialization *) connection;
- (SvnHttpSerialization *) _connection;

- (void) didFailWithError:(NSError *) error;
- (void) didLoadData:(NSData *) data;
- (void) didFinishLoading;
- (void) didReceiveResponse:(NSHTTPURLResponse *) response;

@end
