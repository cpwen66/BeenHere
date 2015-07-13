//
//  Pushdelegate.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/7/11.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "Pushdelegate.h"
#import "StoreInfo.h"
#import "mydb.h"

@implementation Pushdelegate
-(instancetype)init
{
    self = [super init];
    if (self) {
        //        [self.delegate returnPinID:@"123"];
    }
    return self;
}
-(void)Recivefriendrequestpush{

     //呼叫rootcontroller 執行serach
    [self.delegate Recivefriendrequest];



}



-(void)friendRequestPush:(NSString *)friend_id{


    
    
    NSURL *url = [NSURL URLWithString:[StoreInfo shareInstance].apiurlpush];
    
    //多兩個參數，cachea會自作聰明，會用舊的資料。要cache做reload，不要用舊的資料。操作逾時。
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    //將device token及其他資訊傳到後台(Provider)的PHP處理
    //    NSString *memID = [[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID"];
    
    NSString *memID =friend_id;
    
    NSString *memName = [[NSUserDefaults standardUserDefaults]stringForKey:@"bherename"];
    [request setHTTPMethod:@"POST"];//request必須是NSMutableURLRequest才有HTTPMethod屬性
    
    NSString * msg=@"好友請求";
    NSString * action=@"1";
    NSString *postString = [NSString stringWithFormat:@"memID=%@&memName=%@&msg=%@&action=%@", memID, memName,msg,action];
    
    //如果要傳遞多個參數，就用下面的程式
    //NSString *postString = [NSString stringWithFormat:@"qrcode=%@&param1=%@", self.textField.text, @"1"];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];//編碼成UTF-8，所以也可以傳中文
    [request setHTTPBody:postData];//request必須是NSMutableURLRequest才有HTTPBody屬性
    
    //以下是用同步，實際產品會用非同步及block的方式
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"been push%@", dict);





}

//回覆通知
-(void)FriendReplyPush:(NSString *)friend_id and:(NSString *)content_no {
    
    
    NSURL *url = [NSURL URLWithString:[StoreInfo shareInstance].apiurlpush];
    
    //多兩個參數，cachea會自作聰明，會用舊的資料。要cache做reload，不要用舊的資料。操作逾時。
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    //將device token及其他資訊傳到後台(Provider)的PHP處理
    //    NSString *memID = [[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID"];
    
    NSString *memID =friend_id;
    
    NSLog(@"friend_id:%@",friend_id);
    
    NSString *memName = [[NSUserDefaults standardUserDefaults]stringForKey:@"bherename"];
    [request setHTTPMethod:@"POST"];//request必須是NSMutableURLRequest才有HTTPMethod屬性
    
    NSString * msg=@"回覆內容";
    NSString * action=@"2";
    NSString *postString = [NSString stringWithFormat:@"memID=%@&memName=%@&msg=%@&action=%@&contentno=%@", memID, memName,msg,action,content_no];
    
    //如果要傳遞多個參數，就用下面的程式
    //NSString *postString = [NSString stringWithFormat:@"qrcode=%@&param1=%@", self.textField.text, @"1"];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];//編碼成UTF-8，所以也可以傳中文
    [request setHTTPBody:postData];//request必須是NSMutableURLRequest才有HTTPBody屬性
    
    //以下是用同步，實際產品會用非同步及block的方式
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"been push%@", dict);
    
    
    
    
    
}


-(void)FriendcontentPush:(NSString *)friend_id{

    NSURL *url = [NSURL URLWithString:[StoreInfo shareInstance].apiurlpush];
    
    //多兩個參數，cachea會自作聰明，會用舊的資料。要cache做reload，不要用舊的資料。操作逾時。
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    //將device token及其他資訊傳到後台(Provider)的PHP處理
    //    NSString *memID = [[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID"];
    
    NSString *memID =friend_id;
    
    NSLog(@"friend_id:%@",friend_id);
    
    NSString *memName = [[NSUserDefaults standardUserDefaults]stringForKey:@"bherename"];
    [request setHTTPMethod:@"POST"];//request必須是NSMutableURLRequest才有HTTPMethod屬性
    
    NSString * msg=@"您有一筆新留言";
    NSString * action=@"3";
    NSString *postString = [NSString stringWithFormat:@"memID=%@&memName=%@&msg=%@&action=%@", memID, memName,msg,action];
    
    //如果要傳遞多個參數，就用下面的程式
    //NSString *postString = [NSString stringWithFormat:@"qrcode=%@&param1=%@", self.textField.text, @"1"];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];//編碼成UTF-8，所以也可以傳中文
    [request setHTTPBody:postData];//request必須是NSMutableURLRequest才有HTTPBody屬性
    
    //以下是用同步，實際產品會用非同步及block的方式
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"been push%@", dict);




}


-(void)SendPinUpdate{
    
    NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
   
    
    NSURL *url = [NSURL URLWithString:[StoreInfo shareInstance].apiurlpush];
    
    //多兩個參數，cachea會自作聰明，會用舊的資料。要cache做reload，不要用舊的資料。操作逾時。
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    //將device token及其他資訊傳到後台(Provider)的PHP處理
    //    NSString *memID = [[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID"];
    NSString *memID =[userdefaults stringForKey:@"bhereID"];
    ;
    NSMutableArray * friendlist=[[mydb sharedInstance]SearchFriendList:memID];
    
    
    
    NSLog(@"friend_id:%@",friendlist);
    
    for (int i=0; i<=friendlist.count-1; i++) {
        NSString *memName = [[NSUserDefaults standardUserDefaults]stringForKey:@"bherename"];
        [request setHTTPMethod:@"POST"];//request必須是NSMutableURLRequest才有HTTPMethod屬性
        NSString * msg=[NSString stringWithFormat:@"%@有一筆新Pin",memName];
        // NSString * msg=@"您有一筆新留言";
        NSString * action=@"4";
        NSString *postString = [NSString stringWithFormat:@"memID=%@&memName=%@&msg=%@&action=%@&id=%@", friendlist[i][@"friendID"], friendlist[i][@"friendname"],msg,action,memID];
                                      
        //如果要傳遞多個參數，就用下面的程式
        //NSString *postString = [NSString stringWithFormat:@"qrcode=%@&param1=%@", self.textField.text, @"1"];
        
        NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];//編碼成UTF-8，所以也可以傳中文
        [request setHTTPBody:postData];//request必須是NSMutableURLRequest才有HTTPBody屬性
        
        //以下是用同步，實際產品會用非同步及block的方式
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"been push%@", dict);
        

    }
    
    
}



@end