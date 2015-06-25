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
    resultSet =[sqlDB executeQuery:@"select * from pin_picture"];
    if ([sqlDB hadError]) {
        NSLog(@"DB Error %d: %@", [sqlDB lastErrorCode], [sqlDB lastErrorMessage]);
    }
    
    while ([resultSet next]) {
        PinImage *pinImage = [[PinImage alloc] init];
        pinImage.imageId = [resultSet.resultDictionary objectForKey:@"picture_id"];
        pinImage.pinId = [resultSet.resultDictionary objectForKey:@"pin_id"];
        pinImage.imageData = [resultSet.resultDictionary objectForKey:@"picture"];
        [rows addObject:pinImage];
    }
    return rows;
}



@end
