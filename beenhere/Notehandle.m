//
//  Notehandle.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/7/11.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "Notehandle.h"

@implementation Notehandle
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.pushdelegate = [[Pushdelegate alloc] init];
        //self.mapManager.delegate = self;
    }
    return self;
}
-(void)pushnotification:(NSString*)actionnumber{


    
    int ActionNumber = [actionnumber intValue];
    if (ActionNumber == 1) {
        [_pushdelegate Recivefriendrequestpush];
    }





}




@end
