//
//  PinEditViewController.h
//  beenhere
//
//  Created by CP Wen on 2015/6/24.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//#import <CoreLocation/CoreLocation.h>
#import "Pin.h"

@interface PinEditViewController : UIViewController

@property (strong, nonatomic) Pin *currentPin;
@property (assign, nonatomic) float currentPinlatitude;


+ (UIImage *)imageWithiamge:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
