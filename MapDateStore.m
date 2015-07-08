//
//  MapDateStore.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/7/6.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "MapDateStore.h"
#import "StoreInfo.h"
#import "AFNetworking.h"
#import "Pin.h"
#import "PinDAO.h"



@implementation MapDateStore

-(instancetype)init
{
    self = [super init];
    if (self) {
//        [self.delegate returnPinID:@"123"];
    }
    return self;
}

-(void)StoreTagdata:(NSDictionary*)Tagdata{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    [manager POST:[StoreInfo shareInstance].apiupdateurl parameters:Tagdata success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //request成功之後要做的事情
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        NSLog(@"apiResponse:%@",apiResponse);
        // 取的signIn的key值，並輸出
        NSString *result = [apiResponse objectForKey:@"uploadNewPin"];
        NSLog(@"result:%@",result);
        
        //   判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
            
            
                  NSString *pin_id = [apiResponse objectForKey:@"uploadNewPinresult"];
            
           // [self recievePinID:pin_id];
            [self.delegate returnPinID:pin_id];

            
            
            NSLog(@"success:%@",pin_id);
        }else {
            
            NSLog(@"no suceess");
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
       
        
    }];



}

//搜尋有沒有pin內容
-(void)SearchPinContent{

    NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *memberId = [userdefaults stringForKey:@"bhereID"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"searchPin",@"cmd", memberId, @"userID", nil];
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    [manager POST:[StoreInfo shareInstance].apiupdateurl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //request成功之後要做的事情
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        NSLog(@"apiResponse:%@",apiResponse);
        // 取的signIn的key值，並輸出
        NSString *result = [apiResponse objectForKey:@"searchPin"];
        NSLog(@"result:%@",result);
        
        //   判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
            
            
            NSDictionary *pin = [apiResponse objectForKey:@"searchPinResult"];
            
            // [self recievePinID:pin_id];
           // [self.delegate returnPinID:pin_id];
         for (NSDictionary *dict in pin) {
             NSLog(@"id:%@",dict[@"pin_id"]);
        [self SearchPinContentimage:dict[@"pin_id"]];
            //存ＰＩＮ
             
             Pin * pin=[[Pin alloc]init];
             pin.pinId=dict[@"pin_id"];
             pin.memberId=dict[@"member_id"];
             pin.title=dict[@"pin_title"];
             CGFloat latitude=  (CGFloat)[dict[@"pin_latitude"] floatValue];
             CGFloat longitude=  (CGFloat)[dict[@"pin_longitude"] floatValue];
             CLLocationCoordinate2D pinCoordinate;
             pinCoordinate.latitude =latitude;
             pinCoordinate.longitude = longitude;
             pin.coordinate = pinCoordinate;
             
             
             //存到sqlite
              PinDAO*pinDAO = [[PinDAO alloc] init];
             [pinDAO insertPinIntoSQLite:pin];
            
          //   PIN.coordinate.latitude=dict[@""]
             
             
             
         }
        }else {
            
            NSLog(@"no suceess");
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
        
        
        
        
        
    }];
    









}
-(void)SearchPinContentimage:(NSString*)pin_id{


    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"searchPinimage",@"cmd", pin_id, @"pin_id", nil];
    
    
    NSLog(@"pas,%@",params);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    [manager POST:[StoreInfo shareInstance].apiupdateurl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        NSLog(@"apiResponse:%@",apiResponse);
        // 取的signIn的key值，並輸出
        NSString *result = [apiResponse objectForKey:@"searchPinimage"];
   
        
        //   判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
            
            //存sqlite pin_picture
            Pin * pin=[[Pin alloc]init];
     
            
            
            NSLog(@"success");
        }else {
            
            NSLog(@"no suceess");
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
        
        
        
        
        
    }];
    




}

@end
