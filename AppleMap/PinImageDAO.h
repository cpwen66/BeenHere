//
//  PinImageDAO.h
//  beenhere
//
//  Created by CP Wen on 2015/6/25.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseConnection.h"

@interface PinImageDAO : NSObject

- (PinImageDAO *) init;

- (NSMutableArray *) getAllImageByPinId:(NSString *)pinId;

@end
