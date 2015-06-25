//
//  PinImage.h
//  beenhere
//
//  Created by CP Wen on 2015/6/25.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinImage : UIImage

@property (weak, nonatomic)NSString *imageId;
@property (weak, nonatomic)NSString *pinId;
@property (weak, nonatomic)NSData *imageData;

@end
