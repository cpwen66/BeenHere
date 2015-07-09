//
//  StoreInfo.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/14.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "StoreInfo.h"

@implementation StoreInfo


static StoreInfo *shareInstance;
- (id)init {
    self = [super init];
    if (self) {
        [self url];
    }
    return self;
}

+(StoreInfo *)shareInstance {
    
    if (shareInstance == nil) {
        shareInstance = [[StoreInfo alloc] init];
    }
    return shareInstance;
}

-(void)url{
//   _apiurl=@"http://localhost:8888/beenhere/api.php";
//    _apiupdateurl=@"http://localhost:8888/beenhere/apiupdate.php";

    _apiurl=@"http://192.168.196.118:8888/beenhere/api.php";
    _apiupdateurl=@"http://192.168.196.118:8888/beenhere/apiupdate.php";
}



@end
