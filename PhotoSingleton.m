//
//  PhotoSingleton.m
//  beenhere
//
//  Created by YA on 2015/7/1.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "PhotoSingleton.h"
#import "ROOTViewController.h"

@implementation PhotoSingleton

static PhotoSingleton *shareInstance;

+(PhotoSingleton *)shareInstance {
    
    if (shareInstance == nil) {
        shareInstance = [[PhotoSingleton alloc] init];
    }
    return shareInstance;
}


@end
