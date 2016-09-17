//
//  FRUserAccount.m
//  Haidao
//
//  Created by 1860 on 16/8/25.
//  Copyright © 2016年 FanrongQu. All rights reserved.
//

#import "FRUserAccount.h"
#import "SSKeychainQuery.h"
#import "SSKeychain.h"

static NSString *serviceName = @"com.FanrongQu.www";

@implementation FRUserAccount

// 用来保存唯一的单例
static id _instace;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

+ (instancetype)shareFRUserAccount
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc]init];
    });
    return _instace;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instace;
}

//MRC下需要设置release操作
//- (oneway void)release { }
//- (id)retain { return self; }
//- (NSUInteger)retainCount { return 1;}
//- (id)autorelease { return self;}

/**
 *  添加/更新账号密码
 *
 *  @param password 密码
 *  @param account  账号
 *
 *  @return 处理状态
 */
- (BOOL)setPassword:(NSString *)password account:(NSString *)account {
    return [SSKeychain setPassword:password forService:serviceName account:account];
}

/**
 *  根据账号获取密码
 *
 *  @param account 账号
 *
 *  @return 账号对应的密码
 */
- (NSString *)passwordForAccount:(NSString *)account {
    return [SSKeychain passwordForService:serviceName account:account];
}

/**
 *  删除存储的账号和密码
 *
 *  @param account 账号
 *
 *  @return 处理状态
 */
- (BOOL)deletePasswordForAccount:(NSString *)account {
    return [SSKeychain deletePasswordForService:serviceName account:account];
}


@end
