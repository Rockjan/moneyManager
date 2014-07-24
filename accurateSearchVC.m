//
//  accurateSearchVC.m
//  moneyManager
//
//  Created by ppnd on 14-7-10.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "accurateSearchVC.h"

@interface accurateSearchVC ()

@end

@implementation accurateSearchVC

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
    
    self.title = @"精确查询";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    _contentView.delaysContentTouches = NO;
    
    _contentView.userInteractionEnabled = YES;
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [dateformatter setDateFormat:@"YYYY年MM月dd日"];
    
    // [dateformatter setDateFormat:@"YYYY年"];
    
    _dateLabel.text = [dateformatter stringFromDate:date];
    
    CGRect frame = self.view.bounds;
    
    UIScreen *cs =[UIScreen mainScreen];
    
    _contentView.contentInset = UIEdgeInsetsMake(-80, 0, -100, 0);
    
    if (cs.applicationFrame.size.height > 480) {
        _contentView.scrollEnabled = NO;
    }
     _contentView.contentSize = CGSizeMake(frame.size.width, frame.size.height);

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

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onChangeDAte:(id)sender {
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    NSDate *date = datePicker.date;
    [dateformatter setDateFormat:@"YYYY年MM月dd日"];
    
   // [dateformatter setDateFormat:@"YYYY年"];

    _dateLabel.text = [dateformatter stringFromDate:date];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_proNameText resignFirstResponder];
}
@end
