//
//  AppDelegate.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/5/12.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "AppDelegate.h"
#import "mydb.h"
#import "MapDateStore.h"


static NSString * const kJSON = @"http://10.0.1.6:8888/beenhere/DeviceRegister.php";

@interface AppDelegate ()<PushProtocol,MapDataProtocol>

@end

@implementation AppDelegate


- (NSString *)GetBundleFilePath:(NSString *)filename
{
    //可讀取，不可寫入
    NSString *bundleResourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *dbPath = [bundleResourcePath stringByAppendingPathComponent:filename];
    return dbPath;
    
}


- (NSString *)GetDocumentFilePath:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths firstObject];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:filename];
    return dbPath;
    
}

-(void)copyDBtoDocumentifNeeded{
    
    //可讀寫 db:在document 內的實際資料
    NSString *dbPath=[self GetDocumentFilePath:@"beenhere.sqlite"];
    NSString *pinDBPath=[self GetDocumentFilePath:@"pin_V1_20150624.sqlite"];
    
    //發佈安裝時,再套件 bundle的原始db(只可讀取)
    NSString *defaultDBPath =[self GetBundleFilePath:@"beenhere.sqlite" ];
    NSString *defaultPinDBPath =[self GetBundleFilePath:@"pin_V1_20150624.sqlite" ];
    NSLog(@"\ndb:%@\ndefaltDB:%@",dbPath,defaultDBPath);
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    BOOL success, isPinDBPathOK;
    NSError *error, *pinDBPathError;
    
    success=[fileManager fileExistsAtPath:dbPath ];
    isPinDBPathOK=[fileManager fileExistsAtPath:pinDBPath ];

    if (!success) {
        //copy
        success=[fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        if (!success) {
            //NSLog(@"error:%@",[error localizedDescription]);
        }
        
    }else{
        //處理db/table資料結構
        
    }
    
    if (!isPinDBPathOK) {
        //copy
        isPinDBPathOK=[fileManager copyItemAtPath:defaultPinDBPath toPath:pinDBPath error:&pinDBPathError];
        if (!isPinDBPathOK) {
            //NSLog(@"pinDBPathError:%@",[pinDBPathError localizedDescription]);
        }
        
    }else{
        //處理db/table資料結構
        
    }
    
    
}


//- (void)recorderApplicationIconBadgeNumber {
//    NSArray *restSheduledNotis = [[UIApplication sharedApplication] scheduledLocalNotifications];
//    int notiIndex = 1;
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    for (UILocalNotification *noti in restSheduledNotis) {
//        noti.applicationIconBadgeNumber = notiIndex;
//        [[UIApplication sharedApplication] scheduleLocalNotification:noti];
//        notiIndex++;
//    }
//}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    //註冊apns 推播
    // For iOS 8
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    // Override point for customization after application launch.
    [self copyDBtoDocumentifNeeded];
    
    //讓使用者同意 接受提醒。讓使用者授權 允許通知
    //檢查UIApplication的實體在runtime是否可執行registerUserNotificationSettings:
    //registerUserNotificationSettings:是在delegate裡的方法
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          UIUserNotificationTypeAlert|//在手機中設定要通知的類型(橫幅...)
          UIUserNotificationTypeBadge|
          UIUserNotificationTypeSound categories:nil]];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // 將Badge歸零
    application.applicationIconBadgeNumber = 0;

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // 將Badge歸零
    application.applicationIconBadgeNumber = 0;
    //[self reorderApplicationIconBadgeNumber];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_PIN_VISITED_DATE" object:nil];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - Push Notification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString * newToken = [deviceToken description];
    NSLog(@"Device token: %@", newToken);
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"Device token: %@", newToken);
    
//    判斷手機上的Device Token是否存在。
//    NSUserDefault也會儲存device token，如果app沒有上雲端，移除app，也會移除device token
//    
//    
//    處理使用者帳號、名稱、密碼…的資訊
//    將device token及其他資訊傳到後台(Provider)的PHP處理
       NSString *userID = [[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID"];
         NSString *username = [[NSUserDefaults standardUserDefaults]stringForKey:@"bherename"];
    
    NSString *memID = userID;
    NSString *memName = username;
    
    //將Device Token與User資料傳到Provider Server
    NSURL *url = [NSURL URLWithString:kJSON];
    
    //多兩個參數，cachea會自作聰明，會用舊的資料。要cache做reload，不要用舊的資料。操作逾時。
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    
    [request setHTTPMethod:@"POST"];//request必須是NSMutableURLRequest才有HTTPMethod屬性
    
    NSString *postString = [NSString stringWithFormat:@"device_token=%@&memID=%@&memName=%@", newToken, memID, memName];
    //如果要傳遞多個參數，就用下面的程式
    //NSString *postString = [NSString stringWithFormat:@"qrcode=%@&param1=%@", self.textField.text, @"1"];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];//編碼成UTF-8，所以也可以傳中文
    [request setHTTPBody:postData];//request必須是NSMutableURLRequest才有HTTPBody屬性
    
    //以下是用同步，實際產品會用非同步及block的方式
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@", dict);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Failed to get device token, error:%@", [error localizedDescription]);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //NSLog(@"didReceiveRemoteNotification");
    NSLog(@"userinfo%@",userInfo);
   // Pushdelegate * PUSH=[[Pushdelegate alloc] init];
    NSDictionary * server=userInfo[@"server"];
    NSString * action=server[@"action"];
    
    NSString * beeid=[[NSUserDefaults standardUserDefaults] stringForKey:@"bhereID"];
    
    int ActionNumber = [action intValue];
    if (ActionNumber == 1) {
        //收到好有請求通知上mysql查詢好友請求
        [_myViewController SearchRequest:beeid];
        
    }else if (ActionNumber == 2){
        NSString * content_no=server[@"contentno"];
  
        //收到通知上mysql查詢子回覆
        [[mydb sharedInstance]Searchcontentno:content_no];
       
    }else if(ActionNumber == 3){
       // NSString * beeid=server[@"memID"];
        
        //收到通知上mysql查詢子回覆
        [[mydb sharedInstance]querymysqlindexcontentone:beeid];
        
    }else if (ActionNumber == 4){
    
        MapDateStore * mapManager = [[MapDateStore alloc] init];
                mapManager.delegate = self;
              [mapManager SearchPinContent];
        NSLog(@"dd");
    
    }
    
       
}

@end
