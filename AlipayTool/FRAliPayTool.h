//
//  FRAliPayTool.h
//  sugeOnlineMart
//
//  Created by 1860 on 2016/10/25.
//  Copyright © 2016年 FanrongQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRAliPayTool : NSObject

+ (instancetype)shareFRAliPayTool;


#pragma mark - appDelegate
- (void)PayBackInApplication:(UIApplication *)application
                     openURL:(NSURL *)url
           sourceApplication:(NSString *)sourceApplication
                  annotation:(id)annotation;

// NOTE: 9.0以后使用新API接口
- (void)PayBackInApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;


#pragma mark - 支付
//
//选中商品调用支付宝极简支付
//
- (void)doAlipayPayWithOrderId:(NSString *)orderId subject:(NSString *)subject body:(NSString *)body orderPrice:(NSString *)orderPrice;

#pragma mark -
#pragma mark   ==============点击模拟授权行为==============

- (void)doAlipayAuth;

@end
