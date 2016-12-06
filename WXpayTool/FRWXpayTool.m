//
//  FRWXpayTool.m
//  sugeOnlineMart
//
//  Created by 1860 on 2016/10/25.
//  Copyright © 2016年 FanrongQu. All rights reserved.
//

#import "FRWXpayTool.h"
#import "WXApiObject.h"
#import "WXApi.h"

@implementation FRWXpayTool

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

+ (instancetype)shareFRWXpayTool {
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

#pragma mark - 微信支付注册

- (void)WXPayRegisterInApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //向微信注册
    [WXApi registerApp:WXpayAppid withDescription:@"sugemall 1.0"];
    
}
#pragma mark - 发起支付
- (NSString *)jumpToBizPayWithPayDictionary:(NSDictionary *)payDictionary {
    
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
//    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
//    //解析服务端返回json数据
//    NSError *error;
//    //加载一个NSURL对象
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    //将请求的url数据放到NSData对象中
//    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if ( response != nil) {
//        NSMutableDictionary *payDictionary = NULL;
//        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
//        payDictionary = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//        
//        NSLog(@"url:%@",urlString);
        if(payDictionary != nil){
            NSMutableString *retcode = [payDictionary objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [payDictionary objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req = [[PayReq alloc] init];
                //商户号
                req.partnerId = [payDictionary objectForKey:@"partnerid"];
                //与支付交易会话Id
                req.prepayId = [payDictionary objectForKey:@"prepayid"];
                //随机字符串
                req.nonceStr = [payDictionary objectForKey:@"noncestr"];
                //时间戳
                req.timeStamp = stamp.intValue;
                //拓展字段
                req.package = [payDictionary objectForKey:@"package"];
                //签名
                req.sign = [payDictionary objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[payDictionary objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                return @"";
            }else{
                return [payDictionary objectForKey:@"retmsg"];
            }
        }else{
            return @"服务器返回错误，未获取到json对象";
        }
//    }else{
//        return @"服务器返回错误";
//    }
}




@end
