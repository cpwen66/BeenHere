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
//#import "AFHTTPRequestOperationManager.h"

AFHTTPRequestOperationManager *manager;

@implementation CloudDAO

- (void)uploadManager {
    manager = [AFHTTPRequestOperationManager manager];
   // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
   // manager.requestSerializer = [AFJSONRequestSerializer serializer];
}

- (NSString *)uploadNewPin:(Pin *)pin {
    // 指定url是連結到伺服器中負責 上傳 的程式
    NSURL *url = [NSURL URLWithString:@"http://localhost:8888/beenhere/apiupdate.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    self.preference = [NSUserDefaults standardUserDefaults];
    NSString *memberId = [self.preference stringForKey:@"bhereID"];
    
    NSDictionary *params = [NSDictionary new];
    params = @{@"cmd": @"uploadNewPin",
              @"member_id": memberId,
              @"pin_title":pin.title,
              @"pin_latitude":[NSString stringWithFormat:@"%f", pin.coordinate.latitude],
              @"pin_longitude":[NSString stringWithFormat:@"%f", pin.coordinate.longitude]
              };
    
    
    
    //把JSON轉成NSData(包裝成二進位格式)
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:nil];
    
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:params];
    
    NSLog(@"data:%@",data);
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    NSLog(@"idi:%@",myData);
    
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];

       // [request setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    //server回傳的NSData
    NSData *returndata = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];//這行會傳資料到雲端，需要一些時間
    
    //將雲端伺服器回傳的訊息(例如成功或失敗的訊息)解成UTF8的字串
    //NSDictionary *data = [NSDictionary alloc] initwith
    //NSString *returnString = [[NSString alloc] initWithData:returndata encoding:NSUTF8StringEncoding];
    NSDictionary *pinIdDict = [NSDictionary new];
    pinIdDict = [NSJSONSerialization JSONObjectWithData:returndata options:kNilOptions error:nil];
    
    NSLog(@"pinIdDict = %@", pinIdDict);
    
    

    return pinIdDict[@"pin_id"];


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
    
    [manager POST:@"http://192.168.196.159:8000/pins/addpin/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"operation success: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (error) {
            NSLog(@"error: %@", error);
        }
        
    }];


    
}





@end
