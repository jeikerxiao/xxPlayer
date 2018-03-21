//
//  XXFileUtil.h
//  xxPlayer
//
//  Created by xiao on 2018/3/21.
//  Copyright © 2018年 jeikerxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXFileUtil : NSObject

/**
 *  @brief  获得指定目录下，指定后缀名的文件列表
 *
 *  @param  type    文件后缀名
 *  @param  dirPath     指定目录
 *
 *  @return 文件名列表
 */
+(NSArray *) getFileNameListOfType:(NSString *)type fromDirPath:(NSString *)dirPath;

@end
