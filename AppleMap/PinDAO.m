//
//  PinDAO.m
//  beenhere
//
//  Created by CP Wen on 2015/6/23.
//  Copyright (c) 2015年 CP Wen. All rights reserved.
//

#import "PinDAO.h"
#import "Pin.h"

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
    
    //如果這行發生找不到table的error，表示沒有拿到sqlite檔案
    //上次發生錯誤，是sqlite的fileName打錯
    FMResultSet *resultSet;
    resultSet = [sqlDB executeQuery:@"select * from pins"];
    
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
        pin.visitedDate = [resultSet dateForColumn:@"pin_visited_date"];
        CLLocationDegrees latitude = [[resultSet.resultDictionary objectForKey:@"pin_latitude"] doubleValue];
        CLLocationDegrees longitude = [[resultSet.resultDictionary objectForKey:@"pin_longitude"] doubleValue];
        CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        pin.coordinate = locationCoordinate;

        [rows addObject:pin];
        
    }
    //NSLog(@"rows = %@", rows);
    return rows;
}

- (Pin *) getPinById:(NSString *)pinId {
    FMResultSet *resultSet;
    resultSet = [sqlDB executeQuery:@"select * from pins where pin_id=?", pinId];
    Pin *pin = [[Pin alloc] init];
    while ([resultSet next]) {
        pin.pinId = [resultSet stringForColumn:@"pin_id"];
        pin.subtitle= [resultSet stringForColumn:@"pin_id"];
        pin.title = [resultSet stringForColumn:@"pin_title"];
        pin.memberId = [resultSet stringForColumn:@"member_id"];
        pin.visitedDate = [resultSet dateForColumn:@"pin_visited_date"];
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

    
    if (![sqlDB executeUpdate:@"insert into pins (pin_title, pin_latitude, pin_longitude) values (?, ?, ?)", pin.title,  pinLatitude, pinLongitude]) {
     
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

@end
