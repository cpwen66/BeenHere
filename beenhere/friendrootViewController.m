//
//  friendrootViewController.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/30.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "friendrootViewController.h"
#import "ROOTViewController.h"
#import "ContextMenuCell.h"
#import "YALContextMenuTableView.h"
#import "mydb.h"
#import "AFNetworking.h"
#import "friendTableViewController.h"
#import "StoreInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "CameraViewController.h"
#import "talkviewcontroller.h"
#import "MBProgressHUD.h"
@interface friendrootViewController ()

@end

@implementation friendrootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _friendid=[StoreInfo shareInstance].Friendid;
    NSLog(@"r:%@",_friendid);
    
     NSString * BEID=[[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID" ];
    
    
}
-(void)userinfoinit{
    
    NSString * BEID=[[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID" ];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"downloaduserimage",@"cmd",_friendid , @"userID", nil];
    
    AFHTTPRequestOperationManager *managere = [AFHTTPRequestOperationManager manager];
    managere.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [managere POST:@"http://localhost:8888/beenhere/apiupdate.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        
        NSLog(@"PICTURE:%@",apiResponse);
        NSString *result = [apiResponse objectForKey:@"downloaduserimageresult"];
        
        
        if ([result isEqualToString:@"success"]) {
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary * data=[apiResponse objectForKey:@"downloaduserimage"];
            
            NSData * imagedata = [[NSData alloc]initWithBase64EncodedString:data[@"userpicture"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            
            UIImage * image=[UIImage imageWithData:imagedata];
            
            _userpicture.image=image;
            
            
            
        }else {
            NSLog(@"image download no suceess");
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
