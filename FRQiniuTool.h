//
//  FRQiniuTool.h
//  sugeOnlineMart
//
//  Created by 1860 on 16/9/30.
//  Copyright © 2016年 FanrongQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRQiniuTool : NSObject

+ (instancetype)shareFRQiniuTool;

- (void)uploadImageToQNImage:(UIImage *)image withQNToken:(NSString *)token complete:(void (^)(NSString *imageUrl))complete;

@end
