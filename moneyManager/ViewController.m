//
//  ViewController.m
//  moneyManager
//
//  Created by ppnd on 14-7-5.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "ViewController.h"
#import "sqlDB.h"
#import "DBitem.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDB];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.delaysContentTouches = NO;
    
    self.title = @"新建账单";
    
    CGRect frame = self.view.bounds;
    
    UIScreen *cs =[UIScreen mainScreen];
    
    _contentView.contentInset = UIEdgeInsetsMake(-40, 0, 120, 0);
    
    if (cs.applicationFrame.size.height > 480) {
        _contentView.contentInset = UIEdgeInsetsMake(-40, 0, 40, 0);
    }
    _contentView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
    
    _billView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bill"]];
    _tuDing.backgroundColor = [UIColor clearColor];
    
    //设置代理，防止textfield被键盘遮挡
    _proName.delegate = self;
    _price.delegate = self;
    _amount.delegate = self;
    
    [_proName addTarget:self action:@selector(onEditingName) forControlEvents:UIControlEventEditingChanged];
    [_price addTarget:self action:@selector(onEditingPrice) forControlEvents:UIControlEventEditingChanged];
    [_amount addTarget:self action:@selector(onEditingAmount) forControlEvents:UIControlEventEditingChanged];
}
- (void)initDB {
    NSString *sql = @"CREATE TABLE IF NOT EXISTS detailTable (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price FLOAT, counts INTEGER, type INTEGER, year TEXT, month TEXT, day TEXT)";
    
    sqlDB *myDB = [sqlDB sharedInstance];
    [myDB openDB];
    [myDB createDBWithString:sql];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}
-(void)animateTextField:(UITextField *)textField up:(BOOL)up
{
    const int movementDistance = 80;
    const float movementDuration = 0.3f;
    int movement = (up?-movementDistance:movementDistance);
    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //点击空白处 收回键盘
    [_proName resignFirstResponder];
    [_price resignFirstResponder];
    [_amount resignFirstResponder];
}
- (void)onEditingName {
  
    _nameTxt.text = _proName.text;
    _nameTxt.font = [UIFont systemFontOfSize:20.0f];
    _nameTxt.textColor = [UIColor colorWithRed:0.1 green:0.6 blue:0.8 alpha:1];
    _tuDing.image = nil;
    
}
- (void)onEditingPrice {
    
    _priceTxt.text = _price.text;
    _priceTxt.font = [UIFont systemFontOfSize:18.0f];
    _priceTxt.textColor = [UIColor colorWithRed:0.1 green:0.6 blue:0.8 alpha:1];
    _tuDing.image = nil;
    
}
- (void)onEditingAmount {
    
    _amountTxt.text = _amount.text;
    _amountTxt.font = [UIFont systemFontOfSize:18.0f];
    _amountTxt.textColor = [UIColor colorWithRed:0.1 green:0.6 blue:0.8 alpha:1];
    _tuDing.image = nil;
    
}
- (IBAction)clearTF:(id)sender {
    
    _price.text = @"";
    _amount.text = @"";
    _proName.text = @"";
    
}
- (BOOL) isNum:(NSString *)str {
    
    if ([[str stringByTrimmingCharactersInSet: [NSCharacterSet decimalDigitCharacterSet]]stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]].length >0) {
        return YES;
    }else{
        return NO;
    }
    return NO;
}

- (IBAction)clearBill:(id)sender {
    
    _nameTxt.text = @"";
    _amountTxt.text = @"";
    _priceTxt.text = @"";
    
    _tuDing.image = nil;
    _typeImg.image = [UIImage imageNamed:@"tar@2x"];
    typeFlag = NO;
    
}

- (IBAction)onOk:(id)sender {
    
    NSString *msg = @"账单新建成功！";
    NSString *at = @"好了!";
    BOOL flag = NO;
    
    if ([_proName.text isEqualToString:@""]) {
        msg = @"请输入正确的物品名称！";
        at = @"出错了！";
        flag = YES;
    }else if ([_priceTxt.text isEqualToString:@""] || [self isNum:_priceTxt.text]){
        msg = @"请输入正确的价格！（最好是数字~）";
        at = @"出错了！";
        flag = YES;
    }else if ([_amount.text isEqualToString:@""] || [self isNum:_amount.text]){
        msg = @"请输入正确的数量！（最好是数字~）";
        at = @"出错了！";
        flag = YES;
    }else if (!typeFlag){
        msg = @"请选择物品类别！";
        at = @"出错了！";
        flag = YES;
    }

    
    if (!flag) {
        DBitem *item = [[DBitem alloc] init];
        NSDate *nd = [NSDate date];
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        
        NSArray *array =[[dateformatter stringFromDate:nd] componentsSeparatedByString:@"-"];
        
        item.name = _nameTxt.text;
        item.price = [_priceTxt.text floatValue];
        item.counts = [_amountTxt.text intValue];
        item.type = types;
        item.year = array[0];
        item.month = array[1];
        item.day = array[2];
        
        _price.text = @"";
        _amount.text = @"";
        _proName.text = @"";
        _tuDing.image = [UIImage imageNamed:@"ding"];
        
       
        sqlDB *myDB = [sqlDB sharedInstance];
        [myDB openDB];
        BOOL isSuc = [myDB insertARow:item];
        if (isSuc) {
            NSLog(@"charuchenggong!");
        }
        
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:at
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"知道了", nil];
    [alert show];
}
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    
    NSLog(@"info=%@",info);
    // 得到条形码结果
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // 将获得到条形码显示到我们的界面上
    //_resultText.text = symbol.data;
    
    // 扫描时的图片显示到我们的界面上
    //_resultImage.image =
    //[info objectForKey: UIImagePickerControllerOriginalImage];
    
    // 扫描界面退出
    [reader dismissModalViewControllerAnimated: YES];
}

- (IBAction)onClickTXM:(id)sender {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentModalViewController: reader animated: YES];
}

- (IBAction)onCanYin:(id)sender {
    _typeImg.image = [UIImage imageNamed:@"tarFood@2x"];
    typeFlag = YES;
    types = 0;
}
- (IBAction)onBook:(id)sender {
    _typeImg.image = [UIImage imageNamed:@"tarBook@2x"];
    typeFlag = YES;
    types = 1;
}

- (IBAction)onFangZu:(id)sender {
    _typeImg.image = [UIImage imageNamed:@"tarFZ@2x"];
    typeFlag = YES;
    types = 2;
}

- (IBAction)onHuaFei:(id)sender {
    _typeImg.image = [UIImage imageNamed:@"tarHF@2x"];
    typeFlag = YES;
    types = 3;
}

- (IBAction)onWangGou:(id)sender {
    _typeImg.image = [UIImage imageNamed:@"tarWG@2x"];
    typeFlag = YES;
    types = 4;
}

- (IBAction)onFuShi:(id)sender {
    _typeImg.image = [UIImage imageNamed:@"tarYF@2x"];
    typeFlag = YES;
    types = 5;
}

- (IBAction)onJiaoTong:(id)sender {
    _typeImg.image = [UIImage imageNamed:@"tarGJ@2x"];
    typeFlag = YES;
    types = 6;
}

- (IBAction)onQiTa:(id)sender {
    _typeImg.image = [UIImage imageNamed:@"tarQther@2x"];
    typeFlag = YES;
    types = 7;
}
@end
