//
//  PhotoSingleton.h
//  beenhere
//
//  Created by YA on 2015/7/1.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PhotoSingleton.h"

@interface PhotoSingleton : NSObject

// 大頭照片
@property (strong, nonatomic) UIImage *thumbnailPhoto;

// 封面照片
@property (strong, nonatomic) UIImage *frontPhoto;

// 打卡照片
@property (strong, nonatomic) UIImage *locationPostPhoto;

@property (strong, nonatomic) UIImage *contentPhoto;

+ (PhotoSingleton *)shareInstance;

@property (nonatomic, assign) NSInteger *isPhoto;
@property (nonatomic, assign) NSInteger *isImage;
@property (nonatomic, assign) NSInteger *isLocation;
@property (nonatomic, assign) NSInteger *isContent;

@end
