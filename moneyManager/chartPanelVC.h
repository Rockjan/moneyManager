//
//  chartPanelVC.h
//  moneyManager
//
//  Created by ppnd on 14-7-5.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"
#import "dateChooseVC.h"

@interface chartPanelVC : TableViewController <chartDateDelegate>
{
    NSArray *chartData1;
    NSArray *chartData2;
    BOOL isEmpty;
}

@property (nonatomic,retain)NSString *chartType;
@property (nonatomic,retain)NSString *dateStr;

@end
