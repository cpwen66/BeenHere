//
//  PinImageDAO.m
//  beenhere
//
//  Created by CP Wen on 2015/6/25.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "PinImageDAO.h"
#import "PinImage.h"

FMDatabase *sqlDB;

@implementation PinImageDAO


- (PinImageDAO *) init {
    self = [super init];
    if (self) {
        DatabaseConnection *dbConnection = [DatabaseConnection sharedInstance];
        sqlDB = dbConnection.sqliteDatabase;
    }
    return self;
}

- (NSMutableArray *) getAllImageByPinId:(NSString *)pinId {
    NSMutableArray *rows = [NSMutableArray new];
    
    FMResultSet *resultSet;
    resultSet =[sqlDB executeQuery:@"SELECT * FROM pin_picture WHERE pin_id=?", pinId];
    if ([sqlDB hadError]) {
        NSLog(@"DB Error %d: %@", [sqlDB lastErrorCode], [sqlDB lastErrorMessage]);
    }
    
    while ([resultSet next]) {
        PinImage *pinImage = [[PinImage alloc] init];
        pinImage.imageId = [resultSet.resultDictionary objectForKey:@"picture_id"];
        pinImage.pinId = [resultSet.resultDictionary objectForKey:@"pin_id"];
        
        //NSData *datas = [[NSData alloc] initWithBytes:(__bridge const void *)([resultSet.resultDictionary objectForKey:@"picture"]) length:[[resultSet.resultDictionary objectForKey:@"picture"] length]];
        pinImage.imageData = [resultSet dataForColumn:@"picture"];
        //NSData *datas = [resultSet.resultDictionary objectForKey:@"picture"];
        
//        NSUInteger len = [[resultSet.resultDictionary objectForKey:@"picture"] length];
//
//        Byte byte[len];
//        byte = [resultSet.resultDictionary objectForKey:@"picture"];
//        NSData *data = [[NSData alloc] initWithBytes:byte length:len];
        
        [pinImage description];
        [rows addObject:pinImage];
    }
    return rows;
}

//新增功能
- (void) insertImageIntoSQLite: (PinImage *)pinImage {
    
    //如果新增記錄錯誤，就秀錯誤訊息
    if (![sqlDB executeUpdate:@"insert into pin_picture (pin_id, picture) values (?, ?)", pinImage.pinId, pinImage.imageData]) {
        
        //去executeUpdate看說明，裡面會提到lastErrorMessage
        NSLog(@"Could not insert record: %@", [sqlDB lastErrorMessage]);
    };
    
}



@end
