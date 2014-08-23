//
//  ViewController.m
//  moneyManager
//
//  Created by ppnd on 14-7-5.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "ViewController.h"
#import<SystemConfiguration/SystemConfiguration.h>
#import<netdb.h>
#import "sqlDB.h"
#import "DBitem.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self subViewLayout];
    
    //设置代理，防止textfield被键盘遮挡
    _proName.delegate = self;
    _price.delegate = self;
    _amount.delegate = self;
    
    [_proName addTarget:self action:@selector(onEditingName) forControlEvents:UIControlEventEditingChanged];
    [_price addTarget:self action:@selector(onEditingPrice) forControlEvents:UIControlEventEditingChanged];
    [_amount addTarget:self action:@selector(onEditingAmount) forControlEvents:UIControlEventEditingChanged];
}
- (void)subViewLayout {
    
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
    
    NSString *result =[[str stringByTrimmingCharactersInSet: [NSCharacterSet decimalDigitCharacterSet]]stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if (result.length == 0) {
        return YES;
    }else if(result.length == 1) {
        NSRange range = [result rangeOfString:@"."];
        return (range.length > 0 ? YES : NO);
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
    BOOL isWrong = NO;
    //[_nameTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]
    
    NSString *tn = [_nameTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSString *tp = [_priceTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSString *ta = [_amountTxt.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
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
    }else if (!typeFlag){
        msg = @"请选择物品类别！";
        at = @"出错了！";
        isWrong = YES;
    }else
        isWrong = NO;

    
    if (!isWrong) {
        DBitem *item = [[DBitem alloc] init];
        NSDate *nd = [NSDate date];
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        
        NSArray *array =[[dateformatter stringFromDate:nd] componentsSeparatedByString:@"-"];
        
        item.name = tn;
        item.price = [tp floatValue];
        item.counts = [ta intValue];
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
    
    //把数据传给网络函数
    [self getJson:symbol.data];
    
    // 扫描界面退出
    [reader dismissModalViewControllerAnimated: YES];
}

- (void)getJson:(NSString *)str {
    
    NSString *newStr = @"https://api.douban.com/v2/book/isbn/";
    newStr = [newStr stringByAppendingString:str];
    
    NSLog(@"%@",newStr);
    
    NSURL *url = [NSURL URLWithString:[newStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:15];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse* response, NSData* data, NSError* error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (json != nil) {
                if ([json isKindOfClass:[NSDictionary class]]) {
                    
                    _nameTxt.text = [json objectForKey:@"title"];
                    
                    _amountTxt.text = @"1";
                    
                    NSString *price = [json objectForKey:@"price"];
                    _priceTxt.text = [[price substringToIndex:price.length-2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    _typeImg.image = [UIImage imageNamed:@"tarBook@2x"];
                    typeFlag = YES;
                    types = 1;
                }
            }else{
                
                NSString *msg = @"还是手动输入这本书吧！";
                NSString *at = @"没找到啊!";
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:at
                                                                message:msg
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"知道了", nil];
                [alert show];
            }
        });
        
    }];
    

}
- (IBAction)onClickTXM:(id)sender {

    if ([self isConnectedToNetWork]) {
        ZBarReaderViewController *reader = [ZBarReaderViewController new];
        reader.readerDelegate = self;
        ZBarImageScanner *scanner = reader.scanner;
        
        [scanner setSymbology: ZBAR_I25
                       config: ZBAR_CFG_ENABLE
                           to: 0];
        
        [self presentModalViewController: reader animated: YES];
    }
    else {
        NSString *msg = @"请确保网络通畅！";
        NSString *at = @"失败!";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:at
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"知道了", nil];
        [alert show];
    }
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
- (BOOL) isConnectedToNetWork
{
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    /**
     * SCNetworkReachabilityRef: 用来保存创建测试连接返回的引用
     *
     * SCNetworkReachabilityCreateWithAddress: 根据传入的地址测试连接.
     * 第一个参数可以为NULL或kCFAllocatorDefault
     * 第二个参数为需要测试连接的IP地址，当为0.0.0.0时则可以查询本机的网络连接状态
     * 同时返回一个引用必须在用完后释放
     * PS: SCNetworkReachabilityCreateWithName: 这是个根据传入的网络测试连接，
     * 第二个参数比如为“www.apple.com”，其他和上一个一样
     *
     * SCNetworkReachabilityGetFlags：这个函数用来获得测试连接的状态，
     * 第一个参数为之前建立的测试连接的引用，
     * 第二个参数用来保存获得的状态，
     * 如果能获得状态则返回TRUE，否则返回FALSE。
     *
     */
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        printf("Error. Could not recover network reachability flags");
        return NO;
    }
    
    /**
     *  kSCNetworkReachabilityFlagsReachable: 能够连接网络
     *  kSCNetworkReachabilityFlagsConnectionRequired: 能够连接网络，但是首先得建立连接过程
     *  kSCNetworkReachabilityFlagsIsWWAN: 判断是否通过蜂窝网覆盖的连接，
     *  比如EDGE，GPRS或者目前的3G.主要是区别通过WiFi的连接
     */
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
    
    return (isReachable && !needsConnection) ? YES : NO;
}

@end
