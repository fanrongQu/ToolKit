//
//  FRUserAccount.h
//  Haidao
//
//  Created by 1860 on 16/8/25.
//  Copyright © 2016年 FanrongQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRUserAccount : NSObject

+ (instancetype)shareFRUserAccount;

/**
 *  添加/更新账号密码
 *
 *  @param password 密码
 *  @param account  账号
 *
 *  @return 处理状态
 */
- (BOOL)setPassword:(NSString *)password account:(NSString *)account;

/**
 *  根据账号获取密码
 *
 *  @param account 账号
 *
 *  @return 账号对应的密码
 */
- (NSString *)passwordForAccount:(NSString *)account;

/**
 *  删除存储的账号和密码
 *
 *  @param account 账号
 *
 *  @return 处理状态
 */
- (BOOL)deletePasswordForAccount:(NSString *)account;



@end
