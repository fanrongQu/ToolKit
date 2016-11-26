//
//  FRUMengUShareTool.h
//  sugeOnlineMart
//
//  Created by 1860 on 2016/11/1.
//  Copyright © 2016年 FanrongQu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialUIManager.h"


#define UmSocialAppkey @"57b432afe0f55a9832001a0a"
#define WxAppKey @"wxd8bb6785f420406f"
#define WxAppSecret @"0df73d05ac70347ef91a19b57e109431"
#define QQAppKey @"1105316381"



@interface FRUMengUShareTool : NSObject

+ (instancetype)shareFRUMengUShareTool;

#pragma mark - 开启分享
- (void)setShareInApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

#pragma mark - 开始分享
//点击分享按钮
- (void)clickShareButtonWithShareTitle:(NSString *)shareTitle shareDescription:(NSString *)shareDescription shareImage:(NSString *)shareImage shareUrl:(NSString *)shareUrl;

@end
