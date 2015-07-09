//
//  CloudDAO.m
//  beenhere
//
//  Created by CP Wen on 2015/7/2.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "CloudDAO.h"
#import "Pin.h"
#import "PinImage.h"
#import "AFNetworking.h"
#import "StoreInfo.h"
//#import "AFHTTPRequestOperationManager.h"

AFHTTPRequestOperationManager *manager;
@interface CloudDAO()
@property (strong,nonatomic) MapDateStore *mapManager ;
@end
@implementation CloudDAO

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.mapManager = [[MapDateStore alloc] init];
        self.mapManager.delegate = self;
    }
    return self;
}

- (void)uploadManager {
    manager = [AFHTTPRequestOperationManager manager];
   // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
   // manager.requestSerializer = [AFJSONRequestSerializer serializer];
}

- (NSString *)uploadNewPin:(Pin *)pin {
    
    self.preference = [NSUserDefaults standardUserDefaults];
    NSString *memberId = [self.preference stringForKey:@"bhereID"];
    NSDictionary *params = [NSDictionary new];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *postedDate = [dateFormatter stringFromDate:pin.postedDate];
    NSString *visitedDate = [dateFormatter stringFromDate:pin.visitedDate];
    
    params = @{@"cmd": @"uploadNewPin",
               @"member_id": memberId,
               @"pin_title":pin.title,
               @"pin_latitude":[NSString stringWithFormat:@"%f", pin.coordinate.latitude],
               @"pin_longitude":[NSString stringWithFormat:@"%f", pin.coordinate.longitude],
               @"pin_posted_date":postedDate,
               @"pin_visited_date":visitedDate
               };
//    mapManager = [MapDateStore new];
//    [mapManager setDelegate:self];
    [self.mapManager StoreTagdata:params];
    
    /*
    
    // 指定url是連結到伺服器中負責 上傳 的程式
    NSURL *url = [NSURL URLWithString:@"http://localhost:8888/beenhere/apiup.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
  
    
  
     
    
       NSData *data = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:nil];
    
    NSError *jsonError = nil;
    if(!jsonError) {
        
          NSString *serJSON = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"\n\nSerialized JSON: %@", serJSON);
        
    } else {
        
        NSLog(@"JSON Encoding Failed: %@", [jsonError localizedDescription]);
    }

    
    
    [[AFHTTPRequestOperationManager manager] POST:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failBlock(error);
        }
    }];
    
    
    
    //把JSON轉成NSData(包裝成二進位格式)
 
    
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:params];
    
    //NSString *jsonMessage = [params JSONRepresentation];
    
    NSLog(@"data:%@",data);
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    NSLog(@"idi:%@",myData);
    
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"content-Length"];

       // [request setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    //server回傳的NSData
    NSData *returndata = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];//這行會傳資料到雲端，需要一些時間
   // NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
    //將雲端伺服器回傳的訊息(例如成功或失敗的訊息)解成UTF8的字串
    //NSDictionary *data = [NSDictionary alloc] initwith
    //NSString *returnString = [[NSString alloc] initWithData:returndata encoding:NSUTF8StringEncoding];
    NSDictionary *pinIdDict = [NSDictionary new];
    pinIdDict = [NSJSONSerialization JSONObjectWithData:returndata options:kNilOptions error:nil];
     
     
     return pinIdDict[@"pin_id"];
   */
  //  NSLog(@"pinIdDict = %@", pinIdDict);
    
    
    
    
    
    return 0;


}

//測試delgate
-(void)returnPinID:(NSString *)pinid{
    NSLog(@"pin_id:%@",pinid);
}
-(void)StoreTagdata{



}

- (void)uploadPin:(Pin *)pin {
    [self uploadManager];
    //Pin *newPin = [[Pin alloc] init];
    
}

-(void)uploadImageOfPin:(PinImage *)pinImage {
    [self uploadManager];
    
    NSDictionary *params = [NSDictionary new];
    params = @{@"cmd": @"uploadImageOfPin",
               @"pin_id": pinImage.pinId,
               @"pin_image":pinImage.imageData
               };
    
    [manager POST:[StoreInfo shareInstance].apiupdateurl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"operation success: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (error) {
            NSLog(@"error: %@", error);
        }
        
    }];


    
}





@end
