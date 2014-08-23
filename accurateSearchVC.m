//
//  accurateSearchVC.m
//  moneyManager
//
//  Created by ppnd on 14-7-10.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "accurateSearchVC.h"
#import "sqlDB.h"
#import "DBitem.h"
#import "itemEdit.h"

@interface accurateSearchVC ()
{
    NSString *finalDate;
    NSString *name;
    DBitem *item;
}

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
    [self subViewLayout];


    // Do any additional setup after loading the view.
}
- (void)subViewLayout {
    self.title = @"精确查询";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    _contentView.delaysContentTouches = NO;
    
    _contentView.userInteractionEnabled = YES;

    NSDate *date = [NSDate date];
    [self getDate:date];
    
    CGRect frame = self.view.bounds;
    
    UIScreen *cs =[UIScreen mainScreen];
    
    _contentView.contentInset = UIEdgeInsetsMake(-80, 0, -100, 0);
    
    if (cs.applicationFrame.size.height > 480) {
        _contentView.scrollEnabled = NO;
    }
    _contentView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
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
    itemEdit *destination = segue.destinationViewController;
    destination.item = item;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onChangeDAte:(id)sender {
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSDate *date = datePicker.date;
    [self getDate:date];
}
- (void)getDate:(NSDate *)date {
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY年MM月dd日"];
    _dateLabel.text = [dateformatter stringFromDate:date];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    finalDate = [dateformatter stringFromDate:date];
    
}
- (IBAction)onSearchAccrurate:(id)sender {
    
    NSString *text = [_proNameText text];
    name = [text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if ([name isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了！"
                                                        message:@"请输入正确的查询物品名！"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    
    sqlDB *myDB = [sqlDB sharedInstance];
    item = [myDB accurateSearch:name withDate:finalDate];
    if (item == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没找到啊！"
                                                        message:@"请输入正确的查询物品名！"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"知道了", nil];
        [alert show];
    }else
    {
        _proNameText.text = @"";
        [self performSegueWithIdentifier:@"accruateSearch" sender:self];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_proNameText resignFirstResponder];
}
@end
