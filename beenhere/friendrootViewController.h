//
//  friendrootViewController.h
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/30.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "ViewController.h"
#import "UPStackMenu.h"
@interface friendrootViewController : ViewController<UPStackMenuDelegate>

{
    NSMutableArray * ReturnInfo;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *userpicture;
@property (weak, nonatomic) IBOutlet UIImageView *userbackground;

@property (nonatomic, strong) NSString* friendid;

@end
