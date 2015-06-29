//
//  PinImage.m
//  beenhere
//
//  Created by CP Wen on 2015/6/25.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "PinImage.h"

@implementation PinImage
-(NSString *)description
{
    return [NSString stringWithFormat:@"data:%@",self.imageData];
}
@end
