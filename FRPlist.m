//
//  FRPlist.m
//  NetEase News
//
//  Created by 1860 on 16/6/21.
//  Copyright © 2016年 FanrongQu. All rights reserved.
//

#import "FRPlist.h"

@implementation FRPlist



- (BOOL)creatPlistFileWithName:(NSString *)plistName {
    
    NSString *fileName = [self fileNameWithName:plistName];
    
    //1. 创建一个plist文件
    NSFileManager* fm = [NSFileManager defaultManager];
    return [fm createFileAtPath:fileName contents:nil attributes:nil];
}

- (BOOL)removePlistFileWithName:(NSString *)plistName {
    
    NSString *fileName = [self fileNameWithName:plistName];
    
    //1. 移除一个plist文件
    NSFileManager* fm = [NSFileManager defaultManager];
    return [fm removeItemAtPath:fileName error:nil];
}

- (BOOL)writeArray:(NSArray *)array toPlist:(NSString *)plistName {
    
    NSString *fileName = [self fileNameWithName:plistName];
    
    
    return [array writeToFile:fileName atomically:YES];
}

- (NSArray *)arrayWithPlistName:(NSString *)plistName {
    
    NSString *fileName = [self fileNameWithName:plistName];
    NSArray *array = [NSArray arrayWithContentsOfFile:fileName];
    if(array == nil)
    {
        //1. 创建一个plist文件
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:fileName contents:nil attributes:nil];
    }
    return array;
}

- (NSString *)fileNameWithName:(NSString *)plistName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *pathName = [plistName stringByAppendingString:@".plist"];
    return [path stringByAppendingPathComponent:pathName];//获取路径
}



@end
