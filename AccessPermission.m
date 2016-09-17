//
//  AccessPermission.m
//  sugeOnlineMart
//
//  Created by 1860 on 16/9/14.
//  Copyright © 2016年 FanrongQu. All rights reserved.
//  访问权限工具类

#import "AccessPermission.h"
#import <AVFoundation/AVFoundation.h>
#import <AddressBook/AddressBook.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <EventKit/EventKit.h>

@interface AccessPermission ()

/**  app名称  */
@property (nonatomic, strong) NSString *appName;

@end

@implementation AccessPermission

/**
 *  通讯录权限
 *
 *  @param controller 当前控制器
 *
 *  @return 通讯录访问权限状态
 */
- (BOOL)AddressBookPemissionWithController:(UIViewController *)controller {
    
    int __block tip=0;
    //声明一个通讯簿的引用
    ABAddressBookRef addBook =nil;
    //创建通讯簿的引用
    addBook=ABAddressBookCreateWithOptions(NULL, NULL);
    //创建一个出事信号量为0的信号
    dispatch_semaphore_t sema=dispatch_semaphore_create(0);
    //申请访问权限
    ABAddressBookRequestAccessWithCompletion(addBook, ^(bool greanted, CFErrorRef error){
        //greanted为YES是表示用户允许，否则为不允许
        if (!greanted) {
            tip=1;
        }
        //发送一次信号
        dispatch_semaphore_signal(sema);
    });
    //等待信号触发
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    if (tip) {
        
        [self presentAlertControllerWithTitle:@"通讯录权限受限" message:[NSString stringWithFormat:@"请在iPhone的\"设置->隐私->通讯录\"选项中,允许\"%@\"访问您的通讯录.",self.appName] controller:controller];
        return NO;
    }
    return YES;
}

/**
 *  相机权限
 *
 *  @param controller 当前控制器
 *
 *  @return 相机访问权限状态
 */
- (BOOL)CameraPemissionWithController:(UIViewController *)controller {
    
    BOOL isHavePemission = YES;
    
    //判断是否可以打开相机
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusDenied){
        
        [self presentAlertControllerWithTitle:@"相机权限受限" message:[NSString stringWithFormat:@"请在iPhone的\"设置->隐私->相机\"选项中,允许\"%@\"访问您的相机.",self.appName] controller:controller];
        return NO;
    }else if(authStatus == AVAuthorizationStatusRestricted) {
        NSLog(@"相机权限受到限制");
        return NO;
    }
    
    return isHavePemission;
    
}

/**
 *  相册权限
 *
 *  @param controller 当前控制器
 *
 *  @return 相册访问权限状态
 */
- (BOOL)AssetsLibraryPemissionWithController:(UIViewController *)controller {
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if(author == ALAuthorizationStatusDenied){
        
        [self presentAlertControllerWithTitle:@"照片权限受限" message:[NSString stringWithFormat:@"请在iPhone的\"设置->隐私->相册\"选项中,允许\"%@\"访问您的照片.",self.appName] controller:controller];
        return NO;
    }else if(author == ALAuthorizationStatusRestricted) {
        NSLog(@"相册权限受到限制");
        return NO;
    }
    return YES;
}

/**
 *  位置权限
 *
 *  @param controller 当前控制器
 *
 *  @return 位置访问权限状态
 */
- (BOOL)LocationPemissionWithController:(UIViewController *)controller {
    BOOL enable=[CLLocationManager locationServicesEnabled];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (!enable) {
        NSLog(@"定位服务未开启");
        return NO;
    }
    switch (status) {
        case kCLAuthorizationStatusDenied:{
            
            [self presentAlertControllerWithTitle:@"位置权限受限" message:[NSString stringWithFormat:@"请在iPhone的\"设置->隐私->定位服务\"选项中,允许\"%@\"访问您的位置.",self.appName] controller:controller];
            return NO;
        }
            break;
        case kCLAuthorizationStatusRestricted:{
            
            NSLog(@"定位权限受到限制");
            return NO;
        }
            break;
            
        default:
            break;
    }
    return YES;
}

/**
 *  麦克风权限
 *
 *  @param controller 当前控制器
 *
 *  @return 麦克风访问权限状态
 */
- (BOOL)AudioPemissionWithController:(UIViewController *)controller {
    AVAudioSessionRecordPermission authStatus = [[AVAudioSession sharedInstance] recordPermission];
    
    if (authStatus == AVAudioSessionRecordPermissionDenied) {
        
        [self presentAlertControllerWithTitle:@"麦克风权限受限" message:[NSString stringWithFormat:@"请在iPhone的\"设置->隐私->麦克风\"选项中,允许\"%@\"访问您的麦克风.",self.appName] controller:controller];
        return NO;
    }
    return YES;
}


/**
 *  蓝牙共享访问权限
 *
 *  @param controller 当前控制器
 *
 *  @return 蓝牙共享权限状态
 */
- (BOOL)PeripheralManagerPemissionWithController:(UIViewController *)controller {
    CBPeripheralManagerAuthorizationStatus authStatus = [CBPeripheralManager authorizationStatus];
    
    if (authStatus == CBPeripheralManagerAuthorizationStatusDenied) {
        
        [self presentAlertControllerWithTitle:@"蓝牙权限受限" message:[NSString stringWithFormat:@"请在iPhone的\"设置->隐私->蓝牙共享\"选项中,允许\"%@\"访问您的蓝牙共享数据.",self.appName] controller:controller];
        return NO;
    } else if (authStatus == CBPeripheralManagerAuthorizationStatusRestricted) {
        
        NSLog(@"蓝牙受到限制");
        return NO;
    }
    return YES;
}


/**
 *  日历访问权限
 *
 *  @param controller 当前控制器
 *
 *  @return 日历权限状态
 */
- (BOOL)CalendarPemissionWithController:(UIViewController *)controller {
    return [self EntityPemissionWithController:controller forEntityType:EKEntityTypeEvent];
}


/**
 *  提醒事件访问权限
 *
 *  @param controller 当前控制器
 *
 *  @return 提醒事件权限状态
 */
- (BOOL)ReminderPemissionWithController:(UIViewController *)controller {
    return [self EntityPemissionWithController:controller forEntityType:EKEntityTypeReminder];
}

- (BOOL)EntityPemissionWithController:(UIViewController *)controller forEntityType:(EKEntityType)type {
    
    EKAuthorizationStatus authStatus = [EKEventStore authorizationStatusForEntityType:type];
    switch (authStatus) {
        case EKAuthorizationStatusDenied: {
            
            NSString *title;
            NSString *message;
            if (type == EKEntityTypeEvent) {
                title = @"日历权限受限";
                message = [NSString stringWithFormat:@"请在iPhone的\"设置->隐私->日历\"选项中,允许\"%@\"访问您的日历.",self.appName];
            }
            
            if (type == EKEntityTypeReminder) {
                title = @"提醒事项权限受限";
                message = [NSString stringWithFormat:@"请在iPhone的\"设置->隐私->提醒事项\"选项中,允许\"%@\"访问您的提醒事项.",self.appName];
            }
            
            [self presentAlertControllerWithTitle:title message:message controller:controller];
            
            return NO;
        }
            break;
        case EKAuthorizationStatusRestricted: {
            
            NSLog(@"日历/提醒事项授权受到限制");
            return NO;
        }
            break;
            
        default:
            break;
    }
    return YES;
}


/**
 *  是否可以打开设置页面
 *
 *  @return
 */
- (BOOL)canOpenSystemSettingView {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        return YES;
    } else {
        return NO;
    }
}

/**
 *  跳到系统设置页面
 */
- (void)systemSettingView {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message controller:(UIViewController *)controller {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self canOpenSystemSettingView]) {
            [self systemSettingView];
        }
    }]];
    [controller presentViewController:alert animated:YES completion:nil];
}

- (NSString *)appName {
    if (!_appName) {
        
        _appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
        if (!_appName) _appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
    }
    return _appName;
}

@end
