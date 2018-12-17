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

#import "SvnSocketStream.h"


@interface SvnASIHttpStream : NSInputStream<NSStreamDelegate>
{
    //CFHTTPMessageRef _originRequest;
    // sending
	NSOutputStream *_outputStream;
	NSInputStream *_headerStream;	// header while sending
	//NSInputStream *_bodyStream;		// for sending the body
	BOOL _shouldClose;								// server will close after current request - we must requeue other requests on a new connection
	BOOL _sendChunked;				// sending with transfer-encoding: chunked
	// receiving
	NSInputStream *_inputStream;
	unsigned _statusCode;							// status code defined by response
	NSMutableDictionary *_headers;		// received headers
    CFHTTPMessageRef _responseHeader;
	unsigned long long _contentLength;		// if explicitly specified by header
	NSMutableString *_headerLine;			// current header line

	unsigned int _chunkLength;				// current chunk length for receiver
	char _lastChr;										// previouds character while reading header
	BOOL _readingBody;								// done with reading header
	BOOL _isChunked;									// transfer-encoding: chunked
	BOOL _willClose;									// server has announced to close the connection	
    BOOL _willRedirect;
    volatile int fd;
    
    unsigned long long _bodySended;
    
    BOOL _headerReady;
    
    BOOL _headerReceived;
    
    BOOL _bodyReceived;
    
    BOOL _trailersReceived;

}




+ (NSString *)pathForURL:(NSURL *)url;

+ (NSInputStream *)getReadStreamForStreamedHttpRequest:(CFHTTPMessageRef)request stream:(NSInputStream *) postStream;

+ (NSInputStream *)getReadStreamForHttpRequest:(CFHTTPMessageRef)request;

+ (NSString *)getHostArress:(NSString *)host;




@property (assign)CFHTTPMessageRef originRequest;

//@property(nonatomic, retain) __attribute__((NSObject))CFHTTPMessageRef originRequest;

@property (retain)NSInputStream* bodyStream;

@end
