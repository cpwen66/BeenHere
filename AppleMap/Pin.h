//
//  Pin.h
//  beenhere
//
//  Created by CP Wen on 2015/6/25.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface Pin : MKPointAnnotation

@property (strong, nonatomic)NSString *pinId;
@property (strong, nonatomic)NSString *memberId;
@property (strong, nonatomic)NSDate *postedDate;
@property (strong, nonatomic)NSDate *visitedDate;
@property (strong, nonatomic)NSNumber *distance;

@end
