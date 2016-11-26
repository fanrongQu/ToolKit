//
//  FRUMessageTool.h
//  sugeOnlineMart
//
//  Created by 1860 on 2016/10/13.
//  Copyright © 2016年 FanrongQu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UMessageAppKey @"57ff2f72e0f55a2078000257"


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif

@interface FRUMessageTool : NSObject

+ (instancetype)shareFRUMessageTool;

#pragma mark - AppDelegate
- (void)UMessageDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)UMessageDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

- (void)UMessageDidReceiveRemoteNotification:(NSDictionary *)userInfo;

//iOS10新增：处理前台收到通知的代理方法
- (void)UMessageUserNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification;

//iOS10新增：处理后台点击通知的代理方法
-(void)UMessageUserNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response;


@end
