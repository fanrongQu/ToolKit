//
//  LLPayUtil.h
//  DemoPay
//
//  Created by xuyf on 15/4/16.
//  Copyright (c) 2015年 llyt. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kLLPaySignMethodMD5 = 0,
    kLLPaySignMethodRSA,
} LLPaySignMethod;


//#define kLLPayUtilNeedRSASign

@interface LLPayUtil : NSObject

@property (nonatomic, retain) NSArray *signKeyArray;
// 签名工具
// signKey 在 md5时是md5key，rsa是rsa私钥。
// 然后在此再次强调：不建议客户端做签名，容易导致密钥泄露，以及不必要的客户端更新
- (NSDictionary*)signedOrderDic:(NSDictionary*)orderDic
                     andSignKey:(NSString*)signKey;

// 其他工具
// 转换dic成string
+ (NSString*)jsonStringOfObj:(NSDictionary*)dic;

+ (NSString *)LLURLEncodedString:(NSString*)str;
+ (NSString *)LLURLDecodedString:(NSString*)str;
@end
