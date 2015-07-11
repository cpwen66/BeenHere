//
//  Notehandle.h
//  beenhere
//
//  Created by ChiangMengTao on 2015/7/11.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pushdelegate.h"


@interface Notehandle : NSObject

-(void)pushnotification:(NSString*)actionnumber;
@property (strong,nonatomic)  Pushdelegate * pushdelegate ;
@end
