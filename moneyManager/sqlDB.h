//
//  sqlDB.h
//  moneyManager
//
//  Created by ppnd on 14-7-16.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@class DBitem;

@interface sqlDB : NSObject
{
    sqlite3 *dateBase;
    int rowsPerPage;
}

@property (nonatomic,assign) int currentLocation;

+ (id)sharedInstance;

- (BOOL)openDB;
- (BOOL)closeDB;
- (void)createDBWithString:(NSString *)str;

- (BOOL)insertARow:(DBitem *)item;

- (NSArray *)searchByDate:(NSString *)date WithPage:(int)page withFlag:(int)flag;
- (NSArray *)searchByCata:(int)cata WithPage:(int)page;

- (DBitem *)accurateSearch:(NSString *)name withDate:(NSDate *)date;
- (NSArray *)fetchAllWithPage:(int)page;

- (NSArray *)getChartDataByDate:(NSString *)date withFlag:(int)flag;
- (NSArray *)getChartDataByCata:(NSString *)date withFlag:(int)flag;


@end
