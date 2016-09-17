# ToolKit
常用工具集（授权状态、plist操作、密码存储SSKeyChain）
##1、FRAccessPermission（通讯录、相机、相册、位置、麦克风、蓝牙、日历、提醒时间等访问权限获取）
```Objective-C
+ (instancetype)shareFRAccessPermission;

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

```
##2、FRPlist（plist文件读写）
```Objective-C
+ (instancetype)shareFRPlist;

/**
 *  创建plist文件
 *
 *  @param plistName 文件名
 *
 *  @return YES 创建成功  NO 创建失败
 */
- (BOOL)creatPlistFileWithName:(NSString *)plistName;

/**
 *  移除plist文件
 *
 *  @param plistName 文件
 *
 *  @return YES 移除成功  NO 移除失败
 */
- (BOOL)removePlistFileWithName:(NSString *)plistName;

/**
 *  写入数据到plist文件
 *
 *  @param array     需要写入的数据
 *  @param plistName 文件名
 *
 *  @return    YES 写入成功  NO 写入失败
 */
- (BOOL)writeArray:(NSArray *)array toPlist:(NSString *)plistName;

/**
 *  根据plist文件名获取文件内容
 *
 *  @param plistName 文件名
 *
 *  @return 文件内容
 */
- (NSArray *)arrayWithPlistName:(NSString *)plistName;
```
##3、FRUserAccount（用户密码存储SSKeyChain）
```Objective-C

+ (instancetype)shareFRUserAccount;

/**
 *  添加/更新账号密码
 *
 *  @param password 密码
 *  @param account  账号
 *
 *  @return 处理状态
 */
- (BOOL)setPassword:(NSString *)password account:(NSString *)account;

/**
 *  根据账号获取密码
 *
 *  @param account 账号
 *
 *  @return 账号对应的密码
 */
- (NSString *)passwordForAccount:(NSString *)account;

/**
 *  删除存储的账号和密码
 *
 *  @param account 账号
 *
 *  @return 处理状态
 */
- (BOOL)deletePasswordForAccount:(NSString *)account;
```
