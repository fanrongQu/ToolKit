//
//  FRPlist.h
//  NetEase News
//
//  Created by 1860 on 16/6/21.
//  Copyright © 2016年 FanrongQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRPlist : NSObject

/**
 *  创建plist文件
 *
 *  @param plistName 文件名
 *
 *  @return YES 创建成功  NO 创建失败
 */
- (BOOL)creatPlistFileWithName:(NSString *)plistName;

/**
 *  移除plist文件
 *
 *  @param plistName 文件
 *
 *  @return YES 移除成功  NO 移除失败
 */
- (BOOL)removePlistFileWithName:(NSString *)plistName;

/**
 *  写入数据到plist文件
 *
 *  @param array     需要写入的数据
 *  @param plistName 文件名
 *
 *  @return    YES 写入成功  NO 写入失败
 */
- (BOOL)writeArray:(NSArray *)array toPlist:(NSString *)plistName;

/**
 *  根据plist文件名获取文件内容
 *
 *  @param plistName 文件名
 *
 *  @return 文件内容
 */
- (NSArray *)arrayWithPlistName:(NSString *)plistName;


@end
