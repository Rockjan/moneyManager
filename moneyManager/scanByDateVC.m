//
//  scanByDateVC.m
//  moneyManager
//
//  Created by ppnd on 14-7-9.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "scanByDateVC.h"
#import "allItemsVC.h"

@interface scanByDateVC ()
{
    NSString *finalDate;
    int scanType;
}

@end

@implementation scanByDateVC

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
    
    self.title = @"按日期浏览";
    
    NSDate *nd = [NSDate date];
    [self getDate:nd];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    allItemsVC *destination = segue.destinationViewController;
    destination.scanType = scanType;
    destination.finalDate = finalDate;
}


- (IBAction)goBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)searchByYear:(id)sender {
    
    scanType = 1;
    [self performSegueWithIdentifier:@"dateSearch" sender:self];
}

- (IBAction)searchByDate:(id)sender {
    
    scanType = 3;
    [self performSegueWithIdentifier:@"dateSearch" sender:self];
}
- (IBAction)searchByMonth:(id)sender {
    
    scanType = 2;
    [self performSegueWithIdentifier:@"dateSearch" sender:self];
}
- (IBAction)onDateChange:(id)sender {
    
    UIDatePicker *sc = (UIDatePicker *)sender;
    NSDate *nd = [sc date];
    [self getDate:nd];
    
}

- (void)getDate:(NSDate *)nd {
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"年账单浏览-YYYY年"];
    
    [_year setTitle:[dateformatter stringFromDate:nd] forState:UIControlStateNormal];
    
    [dateformatter setDateFormat:@"月账单浏览-YYYY年MM月"];
    [_month setTitle:[dateformatter stringFromDate:nd] forState:UIControlStateNormal];
    
    [dateformatter setDateFormat:@"日账单浏览-YYYY年MM月dd日"];
    [_date setTitle:[dateformatter stringFromDate:nd] forState:UIControlStateNormal];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    finalDate = [dateformatter stringFromDate:nd];
}
@end
