//
//  allItemsVC.h
//  moneyManager
//
//  Created by ppnd on 14-7-10.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"

@interface allItemsVC : TableViewController
{
    NSMutableArray *dataSouce;
    NSArray *newData;
    int page;
}

@property (assign,nonatomic)int counts;
@property (assign,nonatomic)int scanType;
@property (assign,nonatomic)NSString *finalDate;
@property (assign,nonatomic)int cate;
@property (assign,nonatomic) NSString *cateName;

- (IBAction)goBack:(id)sender;

@end
