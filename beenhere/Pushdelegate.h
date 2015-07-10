//
//  Pushdelegate.h
//  beenhere
//
//  Created by ChiangMengTao on 2015/7/11.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol PushProtocol


@optional
-(void)Recivefriendrequest;
@end

@interface Pushdelegate : NSObject
@property (weak, nonatomic)id<PushProtocol> delegate;
-(void)friendRequestPush:(NSString *)friend_id;
-(void)Recivefriendrequestpush;
@end
