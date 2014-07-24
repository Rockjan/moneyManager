//
//  dateChooseVC.h
//  moneyManager
//
//  Created by ppnd on 14-7-5.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol chartDateDelegate <NSObject>

@required
- (void)setDateStrBack:(NSString *)dateStr;

@end

@interface dateChooseVC : UIViewController
{
    NSDate *getDate;
}

@property (nonatomic,retain) NSString *dateType;
@property (weak, nonatomic) IBOutlet UILabel *labelF;
@property (weak, nonatomic) IBOutlet UILabel *labelL;

@property (nonatomic,weak)id<chartDateDelegate> delegate;

- (IBAction)doneAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)dateChange:(id)sender;

@end
