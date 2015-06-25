//
//  Pin.h
//  beenhere
//
//  Created by CP Wen on 2015/6/25.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface Pin : MKPointAnnotation

@property (weak, nonatomic)NSString *pinId;
@property (weak, nonatomic)NSString *memberId;

@end
