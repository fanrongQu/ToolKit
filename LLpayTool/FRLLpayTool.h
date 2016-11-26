//
//  FRLLpayTool.h
//  sugeOnlineMart
//
//  Created by 1860 on 2016/10/25.
//  Copyright © 2016年 FanrongQu. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^FRLLpayCompletionHandle)(BOOL paySucceed);

@interface FRLLpayTool : NSObject

+ (instancetype)shareFRLLpayTool;


#pragma mark - 订单支付

- (void)payWithSignedOrder:(NSDictionary *)signedOrder controller:(UIViewController *)controller payCompletionHandle:(FRLLpayCompletionHandle)paySucceed;

@end
