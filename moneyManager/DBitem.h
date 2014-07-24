//
//  DBitem.h
//  moneyManager
//
//  Created by ppnd on 14-7-16.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBitem : NSObject

@property (nonatomic,assign) int ID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) float price;
@property (nonatomic,assign) int counts;
@property (nonatomic,assign) int type;
@property (nonatomic,copy) NSString *year;
@property (nonatomic,copy) NSString *month;
@property (nonatomic,copy) NSString *day;
@property (nonatomic,copy) NSString *typeString;
@end
