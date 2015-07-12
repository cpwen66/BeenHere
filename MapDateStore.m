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
#import "PinImageDAO.h"
#import "PinImage.h"
#import "mydb.h"

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
    
    
    NSLog(@"data:%@",Tagdata);
    
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
//搜尋有沒有PIN一筆
-(void)SearchPinContentone{

    NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *memberId = [userdefaults stringForKey:@"bhereID"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"searchPinone",@"cmd", memberId, @"userID", nil];
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    [manager POST:[StoreInfo shareInstance].apiupdateurl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //request成功之後要做的事情
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        NSLog(@"apiResponse:%@",apiResponse);
        // 取的signIn的key值，並輸出
        NSString *result = [apiResponse objectForKey:@"searchPinone"];
        NSLog(@"result:%@",result);
        
        //   判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
            
            
            NSDictionary *pin = [apiResponse objectForKey:@"searchPinoneResult"];
            
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
                
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
                // 此格式必須完全符合SQLite裡時間欄位的格式，不然回傳會是nil
                // 24小時制，要用大寫的H
                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                NSTimeZone *tz = [NSTimeZone localTimeZone];
                // 取出時間，還要一些轉換
                NSString *postedTime = dict[@"pin_posted_date"];
                NSString *visitedTime = dict[@"pin_visited_date"];
                NSDate *visitUTCDate = [dateFormat dateFromString:visitedTime];
                NSDate *postUTCDate = [dateFormat dateFromString:postedTime];
                NSTimeInterval seconds = [tz secondsFromGMTForDate:postUTCDate];
                NSTimeInterval secondvisit = [tz secondsFromGMTForDate:visitUTCDate];
                //NSDate *dateInUTC = pin.postedDate;
                pin.postedDate = [postUTCDate dateByAddingTimeInterval:seconds];
                pin.visitedDate =[postUTCDate dateByAddingTimeInterval:secondvisit];
                
                //存到sqlite
                PinDAO*pinDAO = [[PinDAO alloc] init];
                [pinDAO insertPinIntoSQLite:pin];
                
                
                
                //去從mysql取pin的圖
                [self SearchPinContentimage:dict[@"pin_id"]];
                
            }
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
             
             
             NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
             [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
             // 此格式必須完全符合SQLite裡時間欄位的格式，不然回傳會是nil
             // 24小時制，要用大寫的H
             [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
             
             NSTimeZone *tz = [NSTimeZone localTimeZone];
             // 取出時間，還要一些轉換
             NSString *postedTime = dict[@"pin_posted_date"];
             NSString *visitedTime = dict[@"pin_visited_date"];
             NSDate *visitUTCDate = [dateFormat dateFromString:visitedTime];
            NSDate *postUTCDate = [dateFormat dateFromString:postedTime];
             NSTimeInterval seconds = [tz secondsFromGMTForDate:postUTCDate];
                NSTimeInterval secondvisit = [tz secondsFromGMTForDate:visitUTCDate];
             //NSDate *dateInUTC = pin.postedDate;
             pin.postedDate = [postUTCDate dateByAddingTimeInterval:seconds];
            pin.visitedDate =[postUTCDate dateByAddingTimeInterval:secondvisit];
             
             //存到sqlite
              PinDAO*pinDAO = [[PinDAO alloc] init];
             [pinDAO insertPinIntoSQLite:pin];
            
             
            
             //去從mysql取pin的圖
             [self SearchPinContentimage:dict[@"pin_id"]];
             
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
            
            
               NSDictionary * pin=[apiResponse objectForKey:@"searchPinimageResult"];
            
            
     
                   
                   
                   
            NSData * imagedata = [[NSData alloc]initWithBase64EncodedString:pin[@"picture"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            // UIImage * image=[UIImage imageWithData:imagedata];
            
                  
                   
            PinImage * pinimage=[[PinImage alloc]init];
          
                pinimage.imageData=imagedata;
                   
                pinimage.pinId=pin[@"pin_id"];
            
            PinImageDAO * pinimageDAO=[[PinImageDAO alloc] init];
            
            [pinimageDAO insertImageIntoSQLite:pinimage];
                   
            
            NSLog(@"success");
        }else {
            
            NSLog(@"no suceess");
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
        
        
        
        
        
    }];
    




}


//查詢主頁內容數量
-(void)searchcontentCount:(NSString*)BEID{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"queryindexcontentcount",@"cmd", BEID, @"userID", nil];
    
    
    
    
    //產生hud物件，並設定其顯示文字
    
    
    
    
    
    //產生控制request的物件
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    [manager POST:[StoreInfo shareInstance].apiupdateurl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //request成功之後要做的事情
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        
        NSString *result = [apiResponse objectForKey:@"queryindexcontentcountresult"];
        
        
        
        
        //   判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
            
            
//            NSMutableArray *data = [apiResponse objectForKey:@"queryindexcontentcount"];
            
           // NSLog(@"index content:%@",data);
            int count= [[apiResponse objectForKey:@"queryindexcontentcount"] intValue];
           
            
           int sqlcount=[[mydb sharedInstance]countdsqlcontentnumber:BEID ];
           
            NSLog(@"count:%d sqlcount:%d",count,sqlcount);
            
            if (count!=sqlcount) {
            
                
                [self.delegate initindexcontent];
                
            }
            
          
        }else {
            
            NSLog(@"no suceess");
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
        
    }];
    

      
    
    

}
@end
