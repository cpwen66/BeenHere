//
//  PinDAO.m
//  beenhere
//
//  Created by CP Wen on 2015/6/23.
//  Copyright (c) 2015年 CP Wen. All rights reserved.
//

#import "PinDAO.h"
#import "Pin.h"
#import "mydb.h"

FMDatabase *sqlDB;


@implementation PinDAO

- (PinDAO *)init {
    self = [super init];
    if (self) {
        DatabaseConnection *dbConnection = [DatabaseConnection sharedInstance];
        sqlDB = dbConnection.sqliteDatabase;
        
    }
    return self;
}

//與database相關的程式大多follow下面的程序
//利用FMDB API的方法，如：executeQuery或executeUpdate...，與資料庫溝通
//如果資料庫會回傳資料，就用FMResultSet去接資料，FMResultSet是資料集合
//利用FMDB API的方法next取得資料集合的內容
//如果資料集合不只一筆，用next搭配while取出每一筆資料


//查詢功能，查詢全部大頭針
- (NSMutableArray *)getAllPin{
    NSMutableArray *rows = [NSMutableArray new];
    
    mydb *friendDB = [[mydb alloc] init];

    
    //如果這行發生找不到table的error，表示沒有拿到sqlite檔案
    //上次發生錯誤，是sqlite的fileName打錯
    FMResultSet *resultSet;
//    FMResultSet *friendResutlSet;
    resultSet = [sqlDB executeQuery:@"select * from pins"];
    
    if ([sqlDB hadError]) {
        NSLog(@"DB Error %d: %@", [sqlDB lastErrorCode], [sqlDB lastErrorMessage]);
    }
    
    while ([resultSet next]) {
        //NSLog(@"resultDictionary: %@", resultSet.resultDictionary);
        Pin *pin = [[Pin alloc] init];
        pin.pinId = [resultSet.resultDictionary objectForKey:@"pin_id"];

        pin.title = [resultSet.resultDictionary objectForKey:@"pin_title"];
        pin.memberId = [resultSet.resultDictionary objectForKey:@"member_id"];
        
        // 如果資料庫裡沒資料會有"No such table ..." 的錯誤訊息
        NSMutableArray *memberInfoArray = [NSMutableArray new];
        
        NSString *userID = [[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID"];
        
        NSLog(@"id%@, pin_id%@",pin.memberId,userID);
        
        NSString *memberIdString = [NSString stringWithFormat:@"%@",pin.memberId];
        
        if ([memberIdString isEqualToString:userID]) {
            memberInfoArray=[friendDB querymemberinfo:memberIdString];
            
             pin.subtitle = [NSString stringWithFormat:@"%@ 到此一遊", memberInfoArray[0][@"name"]];
             
            NSLog(@"array = %@", memberInfoArray);
        }else{
        memberInfoArray = [friendDB SearchFriendList:pin.memberId];
        pin.subtitle = [NSString stringWithFormat:@"%@ 到此一遊", memberInfoArray[0][@"friendname"]];
        
        }
        
        //NSLog(@"pin.memberId = %@", pin.memberId);
        //NSLog(@"array = %@", memberInfoArray);
      
        
        
        
        
        //NSLog(@"pin.pinId = %@, subtitle= %@, title = %@", pin.pinId, pin.subtitle, pin.title);
        
        // 自訂方法，把UTC時間字串轉本地時間NSData
        pin.postedDate =[self transfromUTCTimeToLocalTime:[resultSet.resultDictionary objectForKey:@"pin_posted_date"]];
    
//        NSString *visitedTime = [resultSet.resultDictionary objectForKey:@"pin_visited_date"];
//        NSLog(@"visitedTime= %@", visitedTime);

        if (![[resultSet.resultDictionary objectForKey:@"pin_visited_date"] isEqual:[NSNull new]]) {
            
            pin.visitedDate =[self transfromUTCTimeToLocalTime:[resultSet.resultDictionary objectForKey:@"pin_visited_date"]];
            
        } else {
            //pin.visitedDate = [dateFormat dateFromString:@"1970-01-01 00:00:00"];
        }
       
    
//        pin.postedDate = [resultSet dateForColumn:@"pin_posted_date"];
        
        CLLocationDegrees latitude = [[resultSet.resultDictionary objectForKey:@"pin_latitude"] doubleValue];
        CLLocationDegrees longitude = [[resultSet.resultDictionary objectForKey:@"pin_longitude"] doubleValue];
        CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        pin.coordinate = locationCoordinate;

        [rows addObject:pin];
        
    }
    //NSLog(@"rows = %@", rows);
    return rows;
}

- (NSMutableArray*)getPinsByFilter:(NSString *)owner visited:(NSString *)visited {
    NSMutableArray *rows = [NSMutableArray new];
    
//    NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
//    NSString *memberId = [preference stringForKey:@"bhereID"];
   
    //假資料
    NSString *memberId = @"1";
    NSString *queryString;
    if ([owner isEqualToString:@"0"]) {
        
        if ([visited isEqualToString:@"0"]) {
            queryString = @"SELECT * FROM pins";
        } else if ([visited isEqualToString:@"1"]){//Visited
            queryString = @"SELECT * FROM pins WHERE pin_visited_date IS NOT NULL";
        } else {//UNVISITED
            queryString = @"SELECT * FROM pins WHERE pin_visited_date IS NULL";
        }
        
    } else if([owner isEqualToString:@"1"]){
        
        queryString = [NSString stringWithFormat:@"SELECT * FROM pins WHERE member_id=%@", memberId];
        
    } else {
        
        if ([visited isEqualToString:@"0"]) {
            queryString = [NSString stringWithFormat:@"SELECT * FROM pins WHERE member_id<>%@", memberId];
            
        } else if ([visited isEqualToString:@"1"]){//Visited
            queryString = [NSString stringWithFormat:@"SELECT * FROM pins WHERE member_id<>%@ AND pin_visited_date IS NOT NULL", memberId];
            
        } else {//UNVISITED
            queryString = [NSString stringWithFormat:@"SELECT * FROM pins WHERE member_id<>%@ AND pin_visited_date IS NULL", memberId];
        }
    }
    

    NSLog(@"queryString= %@", queryString);
    FMResultSet *resultSet;
    resultSet = [sqlDB executeQuery:queryString];
    if ([sqlDB hadError]) {
        NSLog(@"DB Error %d: %@", [sqlDB lastErrorCode], [sqlDB lastErrorMessage]);
    }
    
    while ([resultSet next]) {
        //NSLog(@"resultDictionary: %@", resultSet.resultDictionary);
        Pin *pin = [[Pin alloc] init];
        pin.pinId = [resultSet.resultDictionary objectForKey:@"pin_id"];
        
        // 這裡有奇怪的地方，就是pin.pinId出來是__NSCFNumber格式，所以要轉NSString
        // 這裡只是暫時用pinId來當subtitle，之後會用好友的名字
        pin.subtitle = [NSString stringWithFormat:@"%@到此一遊", pin.pinId];
        pin.title = [resultSet.resultDictionary objectForKey:@"pin_title"];
        pin.memberId = [resultSet.resultDictionary objectForKey:@"member_id"];
//        pin.postedDate = [resultSet dateForColumn:@"pin_posted_date"];
//        pin.visitedDate = [resultSet dateForColumn:@"pin_visited_date"];

        // 自訂方法，把UTC時間字串轉本地時間NSData
        pin.postedDate =[self transfromUTCTimeToLocalTime:[resultSet.resultDictionary objectForKey:@"pin_posted_date"]];
        
        if (![[resultSet.resultDictionary objectForKey:@"pin_visited_date"] isEqual:[NSNull new]]) {
            
            pin.visitedDate =[self transfromUTCTimeToLocalTime:[resultSet.resultDictionary objectForKey:@"pin_visited_date"]];
            
        } else {
            //pin.visitedDate = [dateFormat dateFromString:@"1970-01-01 00:00:00"];
        }

        CLLocationDegrees latitude = [[resultSet.resultDictionary objectForKey:@"pin_latitude"] doubleValue];
        CLLocationDegrees longitude = [[resultSet.resultDictionary objectForKey:@"pin_longitude"] doubleValue];
        CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        pin.coordinate = locationCoordinate;
        
        [rows addObject:pin];
        
    }
    //NSLog(@"rows = %@", rows);
    return rows;
    
}

- (Pin *)getPinById:(NSString *)pinId {
    FMResultSet *resultSet;
    resultSet = [sqlDB executeQuery:@"select * from pins where pin_id=?", pinId];
    Pin *pin = [[Pin alloc] init];
    while ([resultSet next]) {
        pin.pinId = [resultSet stringForColumn:@"pin_id"];
        pin.subtitle= [resultSet stringForColumn:@"pin_id"];
        pin.title = [resultSet stringForColumn:@"pin_title"];
        pin.memberId = [resultSet stringForColumn:@"member_id"];
        pin.postedDate = [resultSet dateForColumn:@"pin_posted_date"];
        NSLog(@"postedDate = %@", pin.postedDate);
        pin.visitedDate = [resultSet dateForColumn:@"pin_visited_date"];
        NSLog(@"postedDate= %@", pin.postedDate);
        NSLog(@"visitedDate= %@", pin.visitedDate);
        CLLocationDegrees latitude = [resultSet doubleForColumn:@"pin_latitude"];
        CLLocationDegrees longitude = [resultSet doubleForColumn:@"pin_longitude"];
        CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        pin.coordinate = locationCoordinate;
        
    }
    return pin;
}

 //新增功能
- (void)insertPinIntoSQLite: (Pin *)pin {
    
//    if (![FMDBdb executeUpdate:@"insert into pins (pin_title, pin_latitude, pin_longitude) values (?, ?, ?)", record[@"pin_title"], record[@"pin_latitude"], record[@"pin_longitude"]]) {
//        //去executeUpdate看說明，裡面會提到lastErrorMessage
//        NSLog(@"Could not insert record: %@", [FMDBdb lastErrorMessage]);
//    };    //如果新增記錄錯誤，就秀錯誤訊息
    
    NSString *pinLatitude = [NSString stringWithFormat:@"%1.6f", pin.coordinate.latitude];
    NSString *pinLongitude = [NSString stringWithFormat:@"%1.6f", pin.coordinate.longitude];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *postedDate = [dateFormatter stringFromDate:pin.postedDate];
    NSString *visitedDate = [dateFormatter stringFromDate:pin.visitedDate];

    
    if (![sqlDB executeUpdate:@"insert into pins (member_id, pin_title, pin_latitude, pin_longitude, pin_posted_date, pin_visited_date) values (?, ?, ?, ?, ?, ?)", pin.memberId, pin.title, pinLatitude, pinLongitude, postedDate, visitedDate]) {
     
     //去executeUpdate看說明，裡面會提到lastErrorMessage
     NSLog(@"Could not insert record: %@", [sqlDB lastErrorMessage]);
    };

}
 

//刪除功能
- (void)deleteRecordFromSQLite:(NSInteger *)pinId {
    if (![sqlDB executeUpdate:@"delete from pins where pin_id=?", pinId]) {
     
        NSLog(@"Could not delete record: %@", [sqlDB lastErrorMessage]);
    }
}
 

 //修改功能，修改title
- (void)updateRecordFromSQLite:(NSInteger *)pinId setTitle:(NSString *) title{
    if(![sqlDB executeUpdate:@"update pins set pin_title=? where pin_id=?", title, pinId]) {

     NSLog(@"Could not update record: %@", [sqlDB lastErrorMessage]);

    }
    
}

//修改功能，修改 到訪的日期時間
- (void)updateVisitedDateFromSQLite:(NSString *)pinId setVisitedDate:(NSDate *) visitedDate {
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //將UTC轉成本地時間
//    [dateFormat setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
//    NSString = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:visitedDate]];
    if(![sqlDB executeUpdate:@"update pins set pin_visited_date=? where pin_id=?", visitedDate, pinId]) {
        
        NSLog(@"Could not update record: %@", [sqlDB lastErrorMessage]);
        
    }
    
}


- (NSString *)getLastPinId {
    
    FMResultSet *resultSet;
    //resultSet = [sqlDB executeQuery:@"select max(pin_id) from pins"];
    resultSet = [sqlDB executeQuery:@"select pin_id from pins ORDER BY pin_id DESC LIMIT 1"];

    NSString *maxPinId;
    
    while ([resultSet next]) {

        maxPinId = (NSString *)[resultSet.resultDictionary objectForKey:@"pin_id"];
    }
    if ([sqlDB hadError]) {
        NSLog(@"DB Error %d: %@", [sqlDB lastErrorCode], [sqlDB lastErrorMessage]);
    }
    return maxPinId;
}

// 自訂方法，把UTC時間字串轉本地時間NSData
-(NSDate *)transfromUTCTimeToLocalTime:(NSString *)UTCTime {
    
    NSDate *localTime = [NSDate new];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    // 此格式必須完全符合SQLite裡時間欄位的格式，不然回傳會是nil
    // 24小時制，要用大寫的H
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    // 取出時間
    NSString *postedTime = UTCTime;
    // 換成NSDate
    NSDate *postUTCDate = [dateFormat dateFromString:postedTime];
    // UTC時間與本地時間的秒數差
    NSTimeInterval seconds = [tz secondsFromGMTForDate:postUTCDate];
    // 利用秒數差，換成本地時間
    localTime = [postUTCDate dateByAddingTimeInterval:seconds];
    
    return localTime;
}

@end
