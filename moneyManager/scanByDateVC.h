//
//  scanByDateVC.h
//  moneyManager
//
//  Created by ppnd on 14-7-9.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface scanByDateVC : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *theDate;
- (IBAction)goBack:(id)sender;
- (IBAction)searchByYear:(id)sender;
- (IBAction)searchByDate:(id)sender;
- (IBAction)searchByMonth:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *year;
@property (weak, nonatomic) IBOutlet UIButton *month;
@property (weak, nonatomic) IBOutlet UIButton *date;
- (IBAction)onDateChange:(id)sender;

@end
