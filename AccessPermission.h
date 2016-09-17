//
//  AccessPermission.h
//  sugeOnlineMart
//
//  Created by 1860 on 16/9/14.
//  Copyright © 2016年 FanrongQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessPermission : NSObject

/**
 *  通讯录权限
 *
 *  @param controller 当前控制器
 *
 *  @return 通讯录访问权限状态
 */
- (BOOL)AddressBookPemissionWithController:(UIViewController *)controller;

/**
 *  相机权限
 *
 *  @param controller 当前控制器
 *
 *  @return 相机访问权限状态
 */
- (BOOL)CameraPemissionWithController:(UIViewController *)controller;

/**
 *  相册权限
 *
 *  @param controller 当前控制器
 *
 *  @return 相册访问权限状态
 */
- (BOOL)AssetsLibraryPemissionWithController:(UIViewController *)controller;

/**
 *  位置权限
 *
 *  @param controller 当前控制器
 *
 *  @return 位置访问权限状态
 */
- (BOOL)LocationPemissionWithController:(UIViewController *)controller;

/**
 *  麦克风权限
 *
 *  @param controller 当前控制器
 *
 *  @return 麦克风访问权限状态
 */
- (BOOL)AudioPemissionWithController:(UIViewController *)controller;

/**
 *  蓝牙共享访问权限
 *
 *  @param controller 当前控制器
 *
 *  @return 蓝牙共享权限状态
 */
- (BOOL)PeripheralManagerPemissionWithController:(UIViewController *)controller;

/**
 *  日历访问权限
 *
 *  @param controller 当前控制器
 *
 *  @return 日历权限状态
 */
- (BOOL)CalendarPemissionWithController:(UIViewController *)controller;

/**
 *  提醒事件访问权限
 *
 *  @param controller 当前控制器
 *
 *  @return 提醒事件权限状态
 */
- (BOOL)ReminderPemissionWithController:(UIViewController *)controller;

@end
