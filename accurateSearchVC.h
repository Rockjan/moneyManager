//
//  accurateSearchVC.h
//  moneyManager
//
//  Created by ppnd on 14-7-10.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface accurateSearchVC : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *proNameText;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (IBAction)goBack:(id)sender;
- (IBAction)onChangeDAte:(id)sender;

@end
