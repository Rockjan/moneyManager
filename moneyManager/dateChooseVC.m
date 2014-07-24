//
//  dateChooseVC.m
//  moneyManager
//
//  Created by ppnd on 14-7-5.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "dateChooseVC.h"

@interface dateChooseVC ()

@end

@implementation dateChooseVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    
    if ([_dateType isEqualToString:@"月"]) {
        self.title = @"更改月份";
        [dateformatter setDateFormat:@"MM月"];
        _labelL.text = [dateformatter stringFromDate:senddate];
    }else
    {
        self.title = @"更改年份";
        [dateformatter setDateFormat:@"YYYY年"];
        _labelL.text = [dateformatter stringFromDate:senddate];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneAction:(id)sender {
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"YYYY-MM-DD"];
    NSString *str = [formater stringFromDate:getDate];
    
    [_delegate setDateStrBack:str];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dateChange:(id)sender {
    
    UIDatePicker *p = (UIDatePicker *)sender;
    
    getDate=[p date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    
    if([_dateType isEqualToString:@"月"]){
        [dateformatter setDateFormat:@"MM月"];
    }else{
        [dateformatter setDateFormat:@"YYYY年"];
    }
    
    _labelL.text = [dateformatter stringFromDate:getDate];
}

@end
