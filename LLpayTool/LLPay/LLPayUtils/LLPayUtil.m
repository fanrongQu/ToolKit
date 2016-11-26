//
//  LLPayUtil.m
//  DemoPay
//
//  Created by xuyf on 15/4/16.
//  Copyright (c) 2015年 llyt. All rights reserved.
//

#import "LLPayUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#ifdef kLLPayUtilNeedRSASign

@protocol LLPDataSigner

- (NSString *)algorithmName;
- (NSString *)signString:(NSString *)string;

@end

id<LLPDataSigner> LLPCreateRSADataSigner(NSString *privateKey);

#endif

@interface LLPayUtil()

@property (nonatomic, assign) LLPaySignMethod signMethod;

@property (nonatomic, retain) NSString *signKey;
@property (nonatomic, retain) NSString *rsaPrivateKey;

@end

@implementation LLPayUtil


- (NSDictionary*)signedOrderDic:(NSDictionary*)orderDic
                     andSignKey:(NSString*)signKey
{
    self.signKey = signKey;
    
    NSMutableDictionary* signedOrder = [NSMutableDictionary dictionaryWithDictionary:orderDic];
    NSString *signString = [self partnerSignOrder:orderDic];
    
    
    // 请求签名	sign	是	String	MD5（除了sign的所有请求参数+MD5key）
    signedOrder[@"sign"] = signString;
    
    return signedOrder;
}


- (NSString*)partnerSignOrder:(NSDictionary*)paramDic
{
    // 所有参与订单签名的字段，这些字段以外不参与签名
    NSArray *keyArray = @[@"busi_partner",@"dt_order",@"info_order",
                          @"money_order",@"name_goods",@"no_order",
                          @"notify_url",@"oid_partner",@"risk_item", @"sign_type",
                          @"valid_order",@"repayment_plan",@"repayment_no",@"sms_param"];
    
    if (self.signKeyArray != nil){
        keyArray = self.signKeyArray;
    }
    
    // 对字段进行字母序排序
    NSMutableArray *sortedKeyArray = [NSMutableArray arrayWithArray:keyArray];
    
    [sortedKeyArray sortUsingComparator:^NSComparisonResult(NSString* key1, NSString* key2) {
        return [key1 compare:key2];
    }];
    
    NSMutableString *paramString = [NSMutableString stringWithString:@""];
    
    // 拼接成 A=B&X=Y
    for (NSString *key in sortedKeyArray)
    {
        if ([paramDic[key] length] != 0)
        {
            [paramString appendFormat:@"&%@=%@", key, paramDic[key]];
        }
    }
    
    if ([paramString length] > 1)
    {
        [paramString deleteCharactersInRange:NSMakeRange(0, 1)];    // remove first '&'
    }
    
    BOOL bMd5Sign = [paramDic[@"sign_type"] isEqualToString:@"MD5"];
    BOOL bHmacSign = [paramDic[@"sign_type"] isEqualToString:@"HMAC"];
    
    if (bMd5Sign)
    {
        // MD5签名，在最后加上key， 变成 A=B&X=Y&key=1234
        [paramString appendFormat:@"&key=%@", self.signKey];
    }
    else{
        // RSA HMAC
    }
    
    
    NSLog(@"签名原串: %@", paramString);
    
    NSString *signString = nil;
    if (bMd5Sign)
    {
        signString = [self signString:paramString];
    }
    else if (bHmacSign){
        signString = [LLPayUtil signHmacString:paramString withKey:self.signKey];
    }
    else{
#ifdef kLLPayUtilNeedRSASign
        id<LLPDataSigner> signer = LLPCreateRSADataSigner(self.signKey);
        signString = [signer signString:paramString];
#endif
    }
    
    
    return signString;
}

- (NSString *)signString:(NSString*)origString
{
    const char *original_str = [origString UTF8String];
    unsigned char result[32];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);//调用md5
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02x", result[i]];
    }
    
    return hash;
}

+ (NSString *)signHmacString:(NSString*)text withKey:(NSString*)key
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    //NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    
    NSString *hash;
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02x", cHMAC[i]];
    }
    
    hash = output;
    
    return hash;
}



+ (NSString*)jsonStringOfObj:(NSDictionary*)dic{
    NSError *err = nil;
    
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:dic 
                                                         options:0
                                                           error:&err];
    
    NSString *str = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    
    return str;
}

+ (NSString *)LLURLEncodedString:(NSString*)str
{
#if __has_feature(objc_arc)
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                    (__bridge CFStringRef)str,
                                                                                    NULL,
                                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                    kCFStringEncodingUTF8);
#else
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)str,
                                                                           NULL,
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
#endif
    return result;
}
+ (NSString *)LLURLDecodedString:(NSString*)str
{
    NSString *result = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return result;
}
@end
