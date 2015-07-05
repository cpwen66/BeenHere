//
//  StoreInfo.h
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/14.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StoreInfo : NSObject

@property (strong, nonatomic)NSMutableArray * FriendRequestList;

@property (strong, nonatomic)NSMutableArray * MyFriendtList;

@property (strong, nonatomic)NSMutableArray * indexContent;

@property (strong, nonatomic)NSMutableArray * ContentList;

@property (strong, nonatomic)UIImage * imagee;
@property (nonatomic, strong) NSString* Friendid;
@property (nonatomic, strong) NSString* apiurl;
@property (nonatomic, strong) NSString* apiupdateurl;
+(StoreInfo *)shareInstance;



@end
