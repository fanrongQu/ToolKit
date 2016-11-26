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

#pragma mark - 支付
//
//选中商品调用支付宝极简支付
//
- (void)doAlipayPayWithOrderId:(NSString *)orderId subject:(NSString *)subject body:(NSString *)body orderPrice:(NSString *)orderPrice;

@end
