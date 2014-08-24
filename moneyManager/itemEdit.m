//
//  itemEdit.m
//  moneyManager
//
//  Created by ppnd on 14-8-23.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "itemEdit.h"
#import "DBitem.h"
#import "sqlDB.h"

@interface itemEdit ()
@end

@implementation itemEdit

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
    
    _countText.enabled = NO;
    _stepper.minimumValue = 1;
    _stepper.value = _item.counts;
    _countText.text = [NSString stringWithFormat:@"%d",_item.counts];
    
    
    [self subViewLayout];
    // Do any additional setup after loading the view.
}
- (void)subViewLayout {
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.delaysContentTouches = NO;
    
    self.title = @"编辑";
    
    _nameText.text = _item.name;
    _priceText.text = [NSString stringWithFormat:@"%.2f",_item.price];
    _stepper.value = _item.counts;
    _datelabel.text = [NSString stringWithFormat:@"%@年%@月%@日",_item.year,_item.month,_item.day];
    
    CGRect frame = self.view.bounds;
    
    UIScreen *cs =[UIScreen mainScreen];
    
    _contentView.contentInset = UIEdgeInsetsMake(-40, 0, 120, 0);
    
    if (cs.applicationFrame.size.height > 480) {
        _contentView.contentInset = UIEdgeInsetsMake(-40, 0, 40, 0);
    }
    _contentView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
    
    //UIStepper 固定住
    _stepper.frame = CGRectMake(190, 200, 10, 10);
    [_contentView addSubview:_stepper];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL) isNum:(NSString *)str {
    
    NSString *result =[[str stringByTrimmingCharactersInSet: [NSCharacterSet decimalDigitCharacterSet]]stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if (result.length == 0) {
        return YES;
    }else if(result.length == 1) {
        NSRange range = [result rangeOfString:@"."];
        return (range.length > 0 ? YES : NO);
    }
    
    return NO;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_nameText resignFirstResponder];
    [_priceText resignFirstResponder];
    [_countText resignFirstResponder];
}
- (IBAction)onSave:(id)sender {
    
    NSString *msg = @"账单修改成功！";
    NSString *at = @"好了!";
    BOOL isWrong = NO;
    
    DBitem *newItem = [[DBitem alloc] init];
    
    NSString *tn = [_nameText.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSString *tp = [_priceText.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSString *ta = [_countText.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if ([tn isEqualToString:@""]) {
        msg = @"请输入正确的物品名称！";
        at = @"出错了！";
        isWrong = YES;
    }else if ([tp isEqualToString:@""] || ![self isNum:tp]){
        msg = @"请输入正确的价格！（最好是数字~）";
        at = @"出错了！";
        isWrong = YES;
    }else if ([ta isEqualToString:@""] || ![self isNum:ta]){
        msg = @"请输入正确的数量！（最好是数字~）";
        at = @"出错了！";
        isWrong = YES;
    }else
        isWrong = NO;
    
    if (!isWrong) {
        newItem.ID = _item.ID;
        newItem.name = tn;
        newItem.price = [tp floatValue];
        newItem.counts = [ta intValue];
        newItem.year = _item.year;
        newItem.month = _item.month;
        newItem.day = _item.day;
        
        sqlDB *myDB = [[sqlDB alloc] init];
        
        [myDB openDB];
        BOOL suc =[myDB updateItem:newItem];
        [myDB closeDB];
        
        if (!suc) {
            msg = @"物品信息更新失败！";
            at = @"出错！";
        }else {
            NSDictionary *dict = @{@"newItem":newItem,@"oldItem":_item};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self userInfo:dict];
        }
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:at
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"知道了", nil];
    [alert show];
    
}

- (IBAction)onDateChange:(id)sender {
    
    UIDatePicker *sc = (UIDatePicker *)sender;
    NSDate *nd = [sc date];
    [self getDate:nd];
    
}

- (IBAction)countChanged:(id)sender {
    UIStepper *stepper = (UIStepper *)sender;
    _countText.text = [NSString stringWithFormat:@"%d",(int)stepper.value];
}
- (void)getDate:(NSDate *)date {
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY年MM月dd日"];
    _datelabel.text = [dateformatter stringFromDate:date];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *finalDate = [dateformatter stringFromDate:date];
    
    NSArray *array = [finalDate componentsSeparatedByString:@"-"];
    
    _item.year = array[0];
    _item.month = array[1];
    _item.day = array[2];
    
}
@end
