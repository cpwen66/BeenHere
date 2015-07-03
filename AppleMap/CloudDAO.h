//
//  CloudDAO.h
//  beenhere
//
//  Created by CP Wen on 2015/7/2.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pin.h"
#import "PinImage.h"

@interface CloudDAO : NSObject

@property (weak, nonatomic)NSUserDefaults *preference;

- (NSString *)uploadNewPin:(Pin *)pin;

-(void)uploadImageOfPin:(PinImage *)pinImage;


@end
