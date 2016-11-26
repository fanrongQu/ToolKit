//
//  FRLLpayTool.m
//  sugeOnlineMart
//
//  Created by 1860 on 2016/10/25.
//  Copyright © 2016年 FanrongQu. All rights reserved.
//


#import "FRLLpayTool.h"
#import "LLPaySdk.h"
#import "LLPayUtil.h"


/*
 正式环境 认证支付 或 分期付 测试商户号  201408071000001543
 MD5 key  201408071000001543test_20140812
 
 正式环境 快捷支付测试商户号  201408071000001546
 MD5 key  201408071000001546_test_20140815
 */

//******************** 👇👇👇配置区域👇👇👇 ********************

/*! TODO: 修改两个参数成商户自己的配置 */
static NSString *kLLOidPartner = @"201606241000926189";                 // 商户号
static NSString *kLLPartnerKey = @"MIICXQIBAAKBgQDQsoUerviUlJDanqZ1Yx6edSofCw+4f+yr0/fzHzw7lV4BLTGQIhw3Lt4ZFdaoWtJKXkhqTjZ9Mmdpd98HrLmGtuCRuiLAxZCPQkA3RLSpuobQugEgq+ho5gHaGVtgRdq+ckRH8eRYbZpMXhLrFNLVsJecw1KgRaDsdqy+ItpGtQIDAQABAoGAd0J89gLRBL89Y+EjiJNi7PRRZLoCetGHos2XtLRVzErYFF4KI66KZzJ+MuGa8EwuPddRFIardrH2DHw21IDs5zkIvC4lGNcak7f79pOk4xoJ1GGd79vhItjelwnbJMg+v1BRZsCSAqdM+MxicaXkp0NKIAuIZ4JihxlA1/lhYcUCQQD39YVGiq4uO57kZMmcqdWVr7couDxk6Ob47sFtfejTFJwWKrPrx7rcuZLFfxiZb2U0/52kyxSof2qAn0o3r2UnAkEA13cPjIPFX/XpYjauBCmY8rjbN4t5WW1IQsv+PCuQ1wVvVAIt8rUG/T7BOptXVFyoS7ws0ww3mxD4Ey+vFgY2wwJALNxlxXJ3uvOcdrPpagesFc3ZtGtIufUNPMJtinK6Od5Dsxr8vE7Bdwe4DzVEbRYjWGhazCLV1PpgeW7YTaTVBwJBAJFK7whA3zq7V7prxuJ1rnaWYvTMr3K3N5AbgP/QHOZx+sV6hsNwgRsKU0CS+cugg7g2Vz+lsGV3huFhOT6vyAMCQQDRfgPGw6UK0N/OBytC9jTTWicxzztFq0kaGQx7kXHMuTT74wLW/caQqHbWE7TvHs1ixa5sp7zTspEukXGc0nYP";   // 密钥

/*! 接入什么支付产品就改成那个支付产品的LLPayType，如快捷支付就是LLPayTypeQuick */
static LLPayType payType = LLPayTypeQuick;

//******************** 👆👆👆配置区域👆👆👆 ********************


@interface FRLLpayTool () <LLPaySdkDelegate>

@property (nonatomic, retain) NSMutableDictionary *orderDic;

@property (nonatomic, strong) NSString *resultTitle;

/**  支付的控制器  */
@property (nonatomic, strong) UIViewController *controller;

/**  支付成功回调  */
@property (nonatomic, strong) FRLLpayCompletionHandle paySuccess;

@end

@implementation FRLLpayTool

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

+ (instancetype)shareFRLLpayTool {
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



#pragma mark - 订单支付

- (void)payWithSignedOrder:(NSDictionary *)signedOrder controller:(UIViewController *)controller payCompletionHandle:(FRLLpayCompletionHandle)paySucceed {
    
//    NSMutableDictionary *signedOrder = [NSMutableDictionary dictionary];
//    // 请求签名	sign	是	String	MD5（除了sign的所有请求参数+MD5key）
//    signedOrder[@"sign"] = signString;
    
    self.resultTitle = @"支付结果";
    self.controller = controller;
    self.paySuccess = paySucceed;
    
    [LLPaySdk sharedSdk].sdkDelegate = self;
    
    //接入什么产品就传什么LLPayType
    [[LLPaySdk sharedSdk] presentLLPaySDKInViewController:controller
                                              withPayType:payType
                                            andTraderInfo:signedOrder];
}


#pragma - mark 支付结果 LLPaySdkDelegate
// 订单支付结果返回，主要是异常和成功的不同状态
// TODO: 开发人员需要根据实际业务调整逻辑
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    
    NSString *msg = @"支付异常";
    switch (resultCode) {
        case kLLPayResultSuccess: {
            msg = @"支付成功";
            self.paySuccess(YES);
        } break;
        case kLLPayResultFail: {
            msg = @"支付失败";
        } break;
        case kLLPayResultCancel: {
            msg = @"支付取消";
        } break;
        case kLLPayResultInitError: {
            msg = @"支付sdk初始化异常";
        } break;
        case kLLPayResultInitParamError: {
            msg = dic[@"ret_msg"];
        } break;
        default:
            break;
    }
//    NSString *showMsg = [msg stringByAppendingString:[LLPayUtil jsonStringOfObj:dic]];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
    [self.controller presentViewController:alert animated:YES completion:nil];
}





@end
