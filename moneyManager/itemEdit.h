//
//  itemEdit.h
//  moneyManager
//
//  Created by ppnd on 14-8-23.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DBitem;

@interface itemEdit : UIViewController

@property (assign,nonatomic) DBitem *item;

@property (weak, nonatomic) IBOutlet UIScrollView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *priceText;
@property (weak, nonatomic) IBOutlet UITextField *countText;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *datelabel;
- (IBAction)goback:(id)sender;
- (IBAction)onSave:(id)sender;

- (IBAction)onDateChange:(id)sender;
- (IBAction)countChanged:(id)sender;

@end
