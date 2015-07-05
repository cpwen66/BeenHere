//
//  PinDAO.h
//  beenhere
//
//  Created by CP Wen on 2015/6/23.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//
//  DatabaseConnection及PinDAO是將DatabaseModel拆開成兩個類別，
//  DatabaseConnection功能是和資料庫連結，
//  PinDAO功能是要執行資料庫的查詢、新增、修改、刪除

#import <Foundation/Foundation.h>
#import "DatabaseConnection.h"
#import "Pin.h"

@interface PinDAO : NSObject

//@property (weak, nonatomic)NSUserDefaults *preference;

- (PinDAO *) init;

- (NSMutableArray *) getAllPin;
- (Pin *) getPinById:(NSString *)pinId;
- (void) insertPinIntoSQLite: (Pin *)pin;
- (NSString *)getLastPinId;
- (void)updateVisitedDateFromSQLite:(NSString *)pinId setVisitedDate:(NSDate *) visitedDate;
- (NSMutableArray*) getPinsByFilter:(NSString *)owner visited:(NSString *)visite;

@end
