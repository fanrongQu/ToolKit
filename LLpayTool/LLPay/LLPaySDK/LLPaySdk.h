//
//  PaySdkColor.h
//  PaySdkColor
//
//  Created by xuyf on 14-4-23.
//  Copyright (c) 2014年 llyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern const NSString* const kLLPaySDKBuildVersion;
extern const NSString *const kLLPaySDKVersion;

typedef enum LLPayResult {
    kLLPayResultSuccess = 0,    // 支付成功
    kLLPayResultFail = 1,       // 支付失败
    kLLPayResultCancel = 2,     // 支付取消，用户行为
    kLLPayResultInitError,      // 支付初始化错误，订单信息有误，签名失败等
    kLLPayResultInitParamError, // 支付订单参数有误，无法进行初始化，未传必要信息等
    kLLPayResultUnknow,         // 其他
}LLPayResult;

typedef NS_ENUM(NSUInteger, LLPayType) {
    LLPayTypeQuick,     // 快捷
    LLPayTypeVerify,    // 认证
    LLPayTypePreAuth,   // 预授权
    LLPayTypeTravel,    // 游易付之随心付
    LLPayTypeRealName,  // 实名快捷支付
    LLPayTypeCar,       // 车易付
    LLPayTypeInstalments,//分期付
};

@protocol LLPaySdkDelegate <NSObject>

@required
/* 可能返回的参数含义
 
 参数名                     含义
 result_pay                  支付结果
 oid_partner                 商户编号
 dt_order                    商户订单时间
 no_order                    商户唯一订单号
 ￼oid_paybill                 连连支付支付单号
 money_order                 交易金额
 ￼￼settle_date                 清算日期
 ￼￼info_order                  订单描述
 pay_type                    支付类型
 bank_code                   银行编号
 bank_name                   银行名称
 memo                        支付备注
 */

/**
 *  调用sdk以后的结果回调
 *
 *  @param resultCode 支付结果
 *  @param dic        回调的字典，参数中，ret_msg会有具体错误显示
 */
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary*)dic;

@end

@interface LLPaySdk : NSObject
{
    UIViewController        *presentController;
}

/**
 *  单例sdk add:20151106
 *
 *  @return 返回LLPaySdk的单例对象
 */
+ (LLPaySdk *)sharedSdk;

/** 代理 */
@property (nonatomic, assign) NSObject<LLPaySdkDelegate> *sdkDelegate;

/**
 *  连连支付 支付接口
 *
 *  @param viewController 推出连连支付支付界面的ViewController
 *  @param payType        连连支付类型:LLPayType （快捷支付、认证支付、预授权支付、游易付、实名快捷支付、车易付）
 *  @param traderInfo     交易信息
 */
- (void)presentLLPaySDKInViewController: (UIViewController *)viewController
                            withPayType: (LLPayType)payType
                          andTraderInfo: (NSDictionary *)traderInfo;

/**
 *  连连支付 签约接口
 *
 *  @param viewController 推出连连支付签约界面的ViewController
 *  @param payType        连连支付类型:LLPayType（签约支持快捷签约、认证签约、实名快捷签约）
 *  @param traderInfo     交易信息
 */
- (void)presentLLPaySignInViewController: (UIViewController *)viewController
                             withPayType: (LLPayType)payType
                           andTraderInfo: (NSDictionary *)traderInfo;


/**
 *  在sdk标题栏下面设定一个广告条或者操作指南bar
 *
 *  @param view 要显示的广告View
 */
+ (void)setADView:(UIView *)view;

@end
