//
//  FRQiniuTool.m
//  sugeOnlineMart
//
//  Created by 1860 on 16/9/30.
//  Copyright © 2016年 FanrongQu. All rights reserved.
//

#import "FRQiniuTool.h"
#import "QiniuSDK.h"


@implementation FRQiniuTool

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

+ (instancetype)shareFRQiniuTool
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

- (void)uploadImageToQNImage:(UIImage *)image withQNToken:(NSString *)token complete:(void (^)(NSString *imageUrl))complete {
//    NSString *filePath = [self getImagePath:image];
    __block NSString *url;
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"percent == %.2f", percent);
    }
                params:nil
                checkCrc:NO
                cancellationSignal:nil];
    
    NSData *uploadData = UIImageJPEGRepresentation(image, 1);
    
    NSDateFormatter *mattter = [[NSDateFormatter alloc]init];
    [mattter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *Nowdate = [mattter stringFromDate:[NSDate date]];
    NSString *imageName = [NSString stringWithFormat:@"%@%uiosuplode.png",Nowdate,arc4random()%100];
    
    //这里对大图片做了压缩，不需要的话下面直接传uploadData就好
    NSData *cutdownData = nil;
    if (uploadData.length < 9999) {
        cutdownData = UIImageJPEGRepresentation(image, 1.0);
    } else if (uploadData.length < 99999) {
        cutdownData = UIImageJPEGRepresentation(image, 0.6);
    } else {
        cutdownData = UIImageJPEGRepresentation(image, 0.3);
    }
    
    [upManager putData:cutdownData key:imageName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        NSLog(@"info ===== %@", info);
        NSLog(@"resp ===== %@", resp);
//        url = [NSString stringWithFormat:@"http://7xv8yu.com2.z0.glb.qiniucdn.com/%@",resp[@"key"]];
        complete(resp[@"key"]);
    } option:uploadOption];
   
}

//照片获取本地路径转换
- (NSString *)getImagePath:(UIImage *)Image {
    NSString *filePath = nil;
    NSData *data = nil;
    if (UIImagePNGRepresentation(Image) == nil) {
        data = UIImageJPEGRepresentation(Image, 1.0);
    } else {
        data = UIImagePNGRepresentation(Image);
    }
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *ImagePath = [[NSString alloc] initWithFormat:@"/theFirstImage.png"];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc] initWithFormat:@"%@%@", DocumentsPath, ImagePath];
    return filePath;
}

+ (void)uploadImages:(NSArray *)images QNtoken:(NSString *)token complete:(void (^)(NSDictionary *))complete
{
    QNUploadManager *qnm = [[QNUploadManager alloc] init];
    NSDateFormatter *mattter = [[NSDateFormatter alloc]init];
    [mattter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *Nowdate = [mattter stringFromDate:[NSDate date]];
    
    __block int count = 0;
    
    for (int i = 0; i < images.count; i++) {
        
        UIImage *image = images[i];
        
        NSData *uploadData = UIImageJPEGRepresentation(image, 1);
        
        //这里对大图片做了压缩，不需要的话下面直接传uploadData就好
        NSData *cutdownData = nil;
        if (uploadData.length < 9999) {
            cutdownData = UIImageJPEGRepresentation(image, 1.0);
        } else if (uploadData.length < 99999) {
            cutdownData = UIImageJPEGRepresentation(image, 0.6);
        } else {
            cutdownData = UIImageJPEGRepresentation(image, 0.3);
        }
        
        
        [qnm putData:cutdownData key:[NSString stringWithFormat:@"%@%d", Nowdate, i+1] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            count++;
            
            NSString *resultKey = [NSString stringWithFormat:@"%d",i];
            
            
            NSString *url = [NSString stringWithFormat:@"http://7xozpn.com2.z0.glb.qiniucdn.com/%@",resp[@"key"]];
            
            if (count == images.count) {
                complete(url);
            }
            
        } option:nil];
        
    }
    
}

@end
