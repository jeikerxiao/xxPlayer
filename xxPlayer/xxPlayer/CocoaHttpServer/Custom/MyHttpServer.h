//
//  MyHttpServer.h
//  xxPlayer
//
//  Created by xiao on 2018/3/19.
//  Copyright © 2018年 jeikerxiao. All rights reserved.
//

#import "HTTPConnection.h"

@class MultipartFormDataParser;

@interface MyHttpServer : HTTPConnection {
    MultipartFormDataParser* parser;
    NSFileHandle* storeFile;
    NSMutableArray* uploadedFiles;
}

@end
