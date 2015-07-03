//
//  ROOTViewController.h
//  beenhere
//
//  Created by ChiangMengTao on 2015/5/25.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPStackMenu.h"
#import "CameraViewController.h"

@interface ROOTViewController : UIViewController<UPStackMenuDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSMutableArray *ReturnInfo;
    NSString *test;
}

@property (weak, nonatomic) IBOutlet UIImageView *userpicture;
@property (weak, nonatomic) IBOutlet UIImageView *userbackground;

- (IBAction)friendrequestcount:(id)sender;

// 點擊大頭照手勢
- (IBAction)tap:(id)sender;

@property BOOL isThumbnailPicked;
@property BOOL isCoverPhotoPicked;
@property BOOL isLocationPicked;

@end
