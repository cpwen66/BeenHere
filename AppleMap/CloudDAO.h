//
//  CloudDAO.h
//  beenhere
//
//  Created by CP Wen on 2015/7/2.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//
#import "AFHTTPRequestOperationManager.h"
#import <Foundation/Foundation.h>
#import "Pin.h"
#import "PinImage.h"
#import "MapDateStore.h"

@interface CloudDAO : NSObject<MapDataProtocol>
@property (strong,nonatomic) MapDateStore *mapManager ;
@property (weak, nonatomic)NSUserDefaults *preference;

- (NSString *)uploadNewPin:(Pin *)pin;


//-(void)hello:(stringBlock)block;

-(void)uploadImageOfPin:(PinImage *)pinImage;


@end
