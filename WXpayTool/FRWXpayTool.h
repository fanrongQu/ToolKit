//
//  FRWXpayTool.h
//  sugeOnlineMart
//
//  Created by 1860 on 2016/10/25.
//  Copyright © 2016年 FanrongQu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WXpayAppid @"wxe0647edc57816c38"

@interface FRWXpayTool : NSObject

+ (instancetype)shareFRWXpayTool;

#pragma mark - 微信支付注册
- (void)WXPayRegisterInApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

#pragma mark - 发起支付
- (NSString *)jumpToBizPayWithPayDictionary:(NSDictionary *)payDictionary;

@end
