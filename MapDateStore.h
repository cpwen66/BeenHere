//
//  MapDateStore.h
//  beenhere
//
//  Created by ChiangMengTao on 2015/7/6.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import <Foundation/Foundation.h>

//@protocol MapDataProtocol <NSObject>
@protocol MapDataProtocol
-(void)returnPinID:(NSString*)pinid;
@end

@interface MapDateStore : NSObject
@property (weak, nonatomic)id<MapDataProtocol> delegate;
-(void)StoreTagdata:(NSDictionary*)Tagdata;
-(void)SearchPinContent;


@end
