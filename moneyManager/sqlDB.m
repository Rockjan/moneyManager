//
//  sqlDB.m
//  moneyManager
//
//  Created by ppnd on 14-7-16.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "sqlDB.h"
#import "DBitem.h"
#import "productItem.h"

#define DBName @"consumeDB.sqlite"
#define tableName @"detailTable"

@implementation sqlDB

+ (id)sharedInstance {
    
    static sqlDB* shareInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        shareInstance = [[self alloc] init];
        
    });
    
    return shareInstance;
}
- (BOOL)openDB {
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [path objectAtIndex:0];
    NSString *db_path = [documents stringByAppendingPathComponent:DBName];
    NSString *home = NSHomeDirectory();
    
    //不存在，则新建数据库
    if (sqlite3_open([db_path UTF8String], &dateBase) != SQLITE_OK) {
        
        NSLog(@"数据库打开失败！");
        return NO;
        
    }
    
    NSString *sql = @"CREATE TABLE IF NOT EXISTS personInfo (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER)";
    char *error;
    if (sqlite3_exec(dateBase, [sql UTF8String], NULL,NULL, &error) != SQLITE_OK) {
        NSLog(@"新建type-table失败！");
    }
    
    NSString *sqlt = @"CREATE TABLE IF NOT EXISTS typeTable (ID INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, tid INTEGER)";
    
    [self createDBWithString:sqlt];
    
    NSDictionary *dict = @{@"0":@"餐饮",@"1":@"书籍",@"2":@"房租",@"3":@"话费",@"4":@"网购",@"5":@"服饰",@"6":@"交通",@"7":@"其他"};

    for (NSString *key in dict) {
        sql = [NSString stringWithFormat:@"INSERT INTO typeTable (type,tid) VALUES('%@',%d)"
               ,[dict valueForKey:key]
               ,[key intValue]];
        
        char *error;
        
        if (sqlite3_exec(dateBase, [sql UTF8String], NULL,NULL, &error) != SQLITE_OK) {
            NSLog(@"数据库插入失败！");
            return NO;
        }
        
    }
    
    rowsPerPage = 5;
    NSLog(@"-----:%@",home);
    return YES;
}
- (BOOL)closeDB {
    
    return YES;
}
- (void)createDBWithString:(NSString *)str {
    
    //NSString *sql = @"CREATE TABLE IF NOT EXISTS personInfo (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER)";
    char *error;
    if (sqlite3_exec(dateBase, [str UTF8String], NULL,NULL, &error) != SQLITE_OK) {
        NSLog(@"新建table失败！");
    }
     NSLog(@"新建table成功！");
    
}

- (BOOL)insertARow:(DBitem *)item {
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (name,price,counts,type,year,month,day) VALUES('%@',%.2f,%d,%d,'%@','%@','%@')"
                     ,tableName
                     ,item.name
                     ,item.price
                     ,item.counts
                     ,item.type
                     ,item.year
                     ,item.month
                     ,item.day];
    
    char *error;
    
    if (sqlite3_exec(dateBase, [sql UTF8String], NULL,NULL, &error) != SQLITE_OK) {
        NSLog(@"数据库插入失败！");
        return NO;
    }
    return YES;
}

#pragma mark - search by date with page

//输入日期格式：yyyy-mm-dd
- (NSArray *)searchByDate:(NSString *)date WithPage:(int)page withFlag:(int)flag {
    
    NSArray *dateArray = [[NSArray alloc] initWithArray:[date componentsSeparatedByString:@"-"]];
    
    if(flag == 2){//按日查询

        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE year='%@' and month='%@' and day='%@' LIMIT %d OFFSET %d"
                         ,tableName
                         ,dateArray[0]
                         ,dateArray[1]
                         ,dateArray[2]
                         ,rowsPerPage
                         ,page*rowsPerPage];
        
        return [self fetchExec:sql];
    }else if(flag == 1){//按月份查询

        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE year='%@' and month='%@' LIMIT %d OFFSET %d"
                         ,tableName
                         ,dateArray[0]
                         ,dateArray[1]
                         ,rowsPerPage
                         ,page*rowsPerPage];
        
        return [self fetchExec:sql];
    }
    //按年份
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE year='%@' LIMIT %d OFFSET %d"
                     ,tableName
                     ,dateArray[0]
                     ,rowsPerPage
                     ,page*rowsPerPage];
    
    return [self fetchExec:sql];
}

- (NSArray *)searchByCata:(int)cata WithPage:(int)page {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE type=%d LIMIT %d OFFSET %d"
                     ,tableName
                     ,cata
                     ,rowsPerPage
                     ,page*rowsPerPage];
    
    return [self fetchExec:sql];
    
}

#pragma mark - accurate search
- (DBitem *)accurateSearch:(NSString *)name withDate:(NSDate *)date {
    return nil;
}
#pragma mark - fetch all
- (NSArray *)fetchAllWithPage:(int)page {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM detailTable inner join typeString ON detailTable.type=typeString.type LIMIT %d OFFSET %d",rowsPerPage,page*rowsPerPage];
    
    return [self fetchExec:sql];
}

#pragma mark - draw chart Data
//输入日期格式：yyyy-mm-dd
- (NSArray *)getChartDataByDate:(NSString *)date withFlag:(int)flag {

    
    NSArray *dateArray = [[NSArray alloc] initWithArray:[date componentsSeparatedByString:@"-"]];
    
    
    if(flag == 1){//按月份查询 1
        
        //数据一定要有31个，不足的（比如2月份只有28天）用0 补齐
         NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:31];
        
        for (int i = 1 ; i <=9 ;i++) {
            
            NSString *tempDate = [NSString stringWithFormat:@"%@-%@-0%d",dateArray[0],dateArray[1],i];
           
            float tp = 0.0f;
            
            tp = [self searchByDate:tempDate withFlag:2];
        
            [temp addObject:[NSString stringWithFormat:@"%.2f",tp]];
            
        }
        for (int i = 10 ; i <=31 ;i++) {
            
            NSString *tempDate = [NSString stringWithFormat:@"%@-%@-%d",dateArray[0],dateArray[1],i];
            
            float tp = 0.0f;
            
            tp = [self searchByDate:tempDate withFlag:2];
            
            [temp addObject:[NSString stringWithFormat:@"%.2f",tp]];
        }
        
        return temp;
    }
    
    //按年份 0
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:12];
    
    for (int i = 1 ; i <=9 ;i++) {
        
        NSString *tempDate = [NSString stringWithFormat:@"%@-0%d-00",dateArray[0],i];
        float tp = 0.0f;
        
        tp = [self searchByDate:tempDate withFlag:1];
        
        [temp addObject:[NSString stringWithFormat:@"%.2f",tp]];
    }
    for (int i = 10 ; i <=12 ;i++) {
        
        NSString *tempDate = [NSString stringWithFormat:@"%@-%d-00",dateArray[0],i];
        float tp = 0.0f;
        
        tp = [self searchByDate:tempDate withFlag:1];
        
        [temp addObject:[NSString stringWithFormat:@"%.2f",tp]];
    }
    
    return temp;
    
}
- (NSArray *)getChartDataByCata:(NSString *)date withFlag:(int)flag {
    
    NSArray *dateArray = [[NSArray alloc] initWithArray:[date componentsSeparatedByString:@"-"]];
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:8];
    
    NSDictionary *dict = @{@"0":@"餐饮",@"1":@"书籍",@"2":@"房租",@"3":@"话费",@"4":@"网购",@"5":@"服饰",@"6":@"交通",@"7":@"其他"};

    
    if(flag == 1){//按月份查询 1
        
        //数据一定要有31个，不足的（比如2月份只有28天）用0 补齐

       for (int t = 0; t < 8; t++) {
            
            float tp = 0.0f;
           
            NSString *tempDate = [NSString stringWithFormat:@"%@-%@-00",dateArray[0],dateArray[1]];
            tp = [self searchByCata:t withDate:tempDate andFlag:1];


            productItem *proItem = [[productItem alloc] init];
            proItem.price = tp;
            proItem.name = [dict valueForKey:[NSString stringWithFormat:@"%d",t]];
            
            [temp addObject:proItem];            
        }

        return temp;
    }
    
    //按年份 0
      for (int t = 0; t < 8; t++) {
          
          float tp = 0.0f;
          
          NSString *tempDate = [NSString stringWithFormat:@"%@-%@-00",dateArray[0],dateArray[1]];
          tp = [self searchByCata:t withDate:tempDate andFlag:0];
          
          
          productItem *proItem = [[productItem alloc] init];
          proItem.price = tp;
          proItem.name = [dict valueForKey:[NSString stringWithFormat:@"%d",t]];
          
          [temp addObject:proItem];
      }
   
    return temp;
}
- (float)searchByDate:(NSString *)date withFlag:(int)flag {
    
    NSArray *dateArray = [[NSArray alloc] initWithArray:[date componentsSeparatedByString:@"-"]];
    
    if(flag == 2){//按日查询
        
        NSString *sql = [NSString stringWithFormat:@"SELECT SUM(price) AS totalValus FROM detailTable  WHERE year='%@' AND month='%@' AND day='%@'"
                         ,dateArray[0]
                         ,dateArray[1]
                         ,dateArray[2]];
        
        return [self fetchExecSum:sql];
    }
        
    NSString *sql = [NSString stringWithFormat:@"SELECT SUM(price) AS totalValus FROM detailTable  WHERE year='%@' AND month='%@'"
                         ,dateArray[0]
                         ,dateArray[1]];
        
    return [self fetchExecSum:sql];
}
- (float)searchByCata:(int)cata withDate:(NSString *)date andFlag:(int)flag {
    
    NSArray *dateArray = [[NSArray alloc] initWithArray:[date componentsSeparatedByString:@"-"]];
    
    if(flag == 1){//按月份查询
        
        NSString *sql = [NSString stringWithFormat:@"SELECT SUM(price) AS totalValus FROM detailTable  WHERE year='%@' AND month='%@' and type=%d"
                         ,dateArray[0]
                         ,dateArray[1]
                         ,cata];

        
        return [self fetchExecSum:sql];
    }
    //按年份
    
    NSString *sql = [NSString stringWithFormat:@"SELECT SUM(price) AS totalValus FROM detailTable WHERE year='%@' AND type=%d"
                     ,dateArray[0]
                     ,cata];
    
    return [self fetchExecSum:sql];
}
#pragma mark - Execute SQL
- (NSArray *) fetchExec:(NSString *)sql {
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:rowsPerPage];
    
    sqlite3_stmt *stmt;
    
    if (sqlite3_prepare_v2(dateBase,[sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            DBitem *item = [[DBitem alloc] init];
            
            item.ID = (float)sqlite3_column_int(stmt, 0);
            
            char* name = (char *)sqlite3_column_text(stmt, 1);
            item.name = [[NSString alloc] initWithUTF8String:name];
            
            item.price = (float)sqlite3_column_double(stmt, 2);
            
            item.counts = (float)sqlite3_column_int(stmt, 3);
            
            item.type = (float)sqlite3_column_int(stmt, 4);
            
            char* year = (char *)sqlite3_column_text(stmt, 5);
            item.year = [[NSString alloc] initWithUTF8String:year];
            
            char* month = (char *)sqlite3_column_text(stmt, 6);
            item.month = [[NSString alloc] initWithUTF8String:month];
            
            char* day = (char *)sqlite3_column_text(stmt, 7);
            item.day = [[NSString alloc] initWithUTF8String:day];
            
            char* typeString = (char *)sqlite3_column_text(stmt, 9);
            item.typeString = [[NSString alloc] initWithUTF8String:typeString];
            
            [array addObject:item];
        }
        
    }
    
   // NSLog(@"从%d开始，读取了%d行数据",rowsPerPage*page,rowsPerPage);
    
    return array;
}

- (float) fetchExecSum:(NSString *)sql {
    
    float value = 0.0f;
    
    sqlite3_stmt *stmt;
    
    if (sqlite3_prepare_v2(dateBase,[sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            value = (float)sqlite3_column_double(stmt, 0);
        }
        
    }
    
    // NSLog(@"从%d开始，读取了%d行数据",rowsPerPage*page,rowsPerPage);
    
    return value;
}

@end
