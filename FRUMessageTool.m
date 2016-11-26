//
//  FRUMessageTool.m
//  sugeOnlineMart
//
//  Created by 1860 on 2016/10/13.
//  Copyright © 2016年 FanrongQu. All rights reserved.
//

#import "FRUMessageTool.h"
#import "UMessage.h"
//以下几个库仅作为调试引用引用的
#import <AdSupport/AdSupport.h>
#import <CommonCrypto/CommonDigest.h>

#import "WebViewController.h"


@interface FRUMessageTool ()<UNUserNotificationCenterDelegate>

@property(nonatomic, strong)NSDictionary *userInfo;

@end

@implementation FRUMessageTool


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

+ (instancetype)shareFRUMessageTool
{
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


#pragma mark - AppDelegate
- (void)UMessageDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //设置 AppKey 及 LaunchOptions
    [UMessage startWithAppkey:UMessageAppKey launchOptions:launchOptions];
    //注册通知
    [UMessage registerForRemoteNotifications];

    //iOS10必须加下面这段代码。
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
#endif
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            
        } else {
            //点击不允许
            
        }
    }];
    
    //如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = @"action1_identifier";
    action1.title=@"打开应用";
    action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
    action2.identifier = @"action2_identifier";
    action2.title=@"忽略";
    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action2.destructive = YES;
    UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
    actionCategory1.identifier = @"category1";//这组动作的唯一标示
    [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
    NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
    
    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
    if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
        
        //UNNotificationCategoryOptionNone
        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
        [center setNotificationCategories:categories_ios10];
    }else
    {
        [UMessage registerForRemoteNotifications:categories];
    }
    
    //如果对角标，文字和声音的取舍，请用下面的方法
    //UIRemoteNotificationType types7 = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
    //UIUserNotificationType types8 = UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge;
    //[UMessage registerForRemoteNotifications:categories withTypesForIos7:types7 withTypesForIos8:types8];
    
    //for log
#if DEBUG
    [UMessage setLogEnabled:YES];
#else
    [UMessage setLogEnabled:NO];
#endif
    
}


- (void)UMessageDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    // [UMessage registerDeviceToken:deviceToken];
    NSString *DeviceToken =[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                          stringByReplacingOccurrencesOfString: @">" withString: @""]
                         stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [kNSUserDefaults setObject:DeviceToken forKey:@"pushDeviceToken"];
    [kNSUserDefaults synchronize];
    
    //下面这句代码只是在demo中，供页面传值使用。
    [self postTestParams:[self stringDevicetoken:deviceToken] idfa:[self idfa] openudid:[self openUDID]];
}

/**
 - (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
 {
 //如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
 //1.2.7版本开始自动捕获这个方法，log以application:didFailToRegisterForRemoteNotificationsWithError开头
 } */

- (void)UMessageDidReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoNotification" object:self userInfo:@{@"userinfo":[NSString stringWithFormat:@"%@",userInfo]}];
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    self.userInfo = userInfo;
    //定制自定的的弹出框
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        NSDictionary *aps = userInfo[@"aps"];
        NSDictionary *alert = aps[@"alert"];
        
        
        NSString *title = alert[@"title"];
        NSString *message = alert[@"body"];
        if (title.length < 1) {
            title = @"新消息";
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"稍后再看"
                                                  otherButtonTitles:@"现在浏览",nil];

        [alertView show];

    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //发送给友盟服务器，说明用户查看该推送信息
    [UMessage sendClickReportForRemoteNotification:self.userInfo];
    switch (buttonIndex) {
        case 0:{//稍后查看
            NSLog(@"稍后查看");
        }
            break;
        case 1:{//现在浏览
            
            NSString *url = _userInfo[@"url"];
//            [WebViewController showWebViewController:controller Url:url title:nil];
        }
            break;
            
        default:
            break;
    }
}



//iOS10新增：处理前台收到通知的代理方法
- (void)UMessageUserNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    
}

//iOS10新增：处理后台点击通知的代理方法
-(void)UMessageUserNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
}


#pragma mark 以下的方法仅作调试使用
- (NSString *)stringDevicetoken:(NSData *)deviceToken
{
    NSString *token = [deviceToken description];
    NSString *pushToken = [[[token stringByReplacingOccurrencesOfString:@"<"withString:@""]                   stringByReplacingOccurrencesOfString:@">"withString:@""] stringByReplacingOccurrencesOfString:@" "withString:@""];
    return pushToken;
}

-(NSString *)idfa
{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];;
}

-(NSString *)openUDID
{
    NSString* openUdid = nil;
    if (openUdid==nil) {
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef cfstring = CFUUIDCreateString(kCFAllocatorDefault, uuid);
        const char *cStr = CFStringGetCStringPtr(cfstring,CFStringGetFastestEncoding(cfstring));
        unsigned char result[16];
        CC_MD5( cStr,(CC_LONG)strlen(cStr), result );
        CFRelease(uuid);
        CFRelease(cfstring);
        openUdid = [NSString stringWithFormat:
                    @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%08lx",
                    result[0], result[1], result[2], result[3],
                    result[4], result[5], result[6], result[7],
                    result[8], result[9], result[10], result[11],
                    result[12], result[13], result[14], result[15],
                    (unsigned long)(arc4random() % NSUIntegerMax)];
    }
    return openUdid;
}

-(void)postTestParams:(NSString *)devicetoken idfa:(NSString *)idfa  openudid:(NSString *)openudid
{
    UIUserNotificationType types;
    UIRemoteNotificationType setting ;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
#endif
    
    
    
    if ([[[UIDevice currentDevice] systemVersion]intValue]<8) {// system <iOS8
        setting = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        NSLog(@"%lu",(unsigned long)setting);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Devicetoken" object:self userInfo:@{@"devicetoken":[NSString stringWithFormat:@"%@",devicetoken],@"setting":[NSString stringWithFormat:@"%lu",(unsigned long)types],@"idfa":idfa,@"openudid":openudid,@"alert":[NSString stringWithFormat:@"%lu",(setting & UIRemoteNotificationTypeAlert)],@"sound":[NSString stringWithFormat:@"%lu",(setting & UIRemoteNotificationTypeSound)],@"badge":[NSString stringWithFormat:@"%lu",(setting & UIRemoteNotificationTypeBadge)]}];
    }else if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {// system >=iOS10
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
        
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Devicetoken" object:self userInfo:@{@"devicetoken":[NSString stringWithFormat:@"%@",devicetoken],@"setting":[NSString stringWithFormat:@"%lu",(unsigned long)types],@"idfa":idfa,@"openudid":openudid,@"alert":[NSString stringWithFormat:@"%ld",(long)settings.alertSetting],@"sound":[NSString stringWithFormat:@"%ld",(long)settings.soundSetting],@"badge":[NSString stringWithFormat:@"%ld",(long)settings.badgeSetting]}];
            });
        }];
        
        
#endif
    }else{
        
        types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
        NSLog(@"%lu",(unsigned long)types);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Devicetoken" object:self userInfo:@{@"devicetoken":[NSString stringWithFormat:@"%@",devicetoken],@"setting":[NSString stringWithFormat:@"%lu",(unsigned long)types],@"idfa":idfa,@"openudid":openudid,@"alert":[NSString stringWithFormat:@"%lu",(types & UIRemoteNotificationTypeAlert)],@"sound":[NSString stringWithFormat:@"%lu",(types & UIRemoteNotificationTypeSound)],@"badge":[NSString stringWithFormat:@"%lu",(types & UIRemoteNotificationTypeBadge)]}];
    }
}


@end
