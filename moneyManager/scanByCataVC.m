//
//  scanByCata.m
//  moneyManager
//
//  Created by ppnd on 14-7-9.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "scanByCataVC.h"
#import "allItemsVC.h"

@interface scanByCataVC ()
{
    int cate;
}

@end

@implementation scanByCataVC

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
    _scrollView.delaysContentTouches = NO;
    
    self.title = @"按类别浏览";
    
    
    CGRect frame = self.view.bounds;
    
    UIScreen *cs =[UIScreen mainScreen];
    
    _scrollView.contentInset = UIEdgeInsetsMake(20, 0, -80, 0);
    
    if (cs.applicationFrame.size.height > 480) {
        _scrollView.contentInset = UIEdgeInsetsMake(-40, 0, -80, 0);
    }
    _scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
    
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
    destination.cate = cate;
    destination.scanType = 4;
    NSDictionary *dict = @{@"0":@"餐饮",@"1":@"书籍",@"2":@"房租",@"3":@"话费",@"4":@"网购",@"5":@"服饰",@"6":@"交通",@"7":@"其他"};
    destination.cateName = [dict objectForKey:[NSString stringWithFormat:@"%d",cate]];
}


- (IBAction)goBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)searchByfood:(id)sender {
    cate = 0;
    [self performSegueWithIdentifier:@"cataSearch" sender:self];
}

- (IBAction)searchByBook:(id)sender {
    cate = 1;
    [self performSegueWithIdentifier:@"cataSearch" sender:self];
}

- (IBAction)searchByFangZu:(id)sender {
    cate = 2;
    [self performSegueWithIdentifier:@"cataSearch" sender:self];
}

- (IBAction)searchByFuZhuang:(id)sender {
    cate = 5;
    [self performSegueWithIdentifier:@"cataSearch" sender:self];
}

- (IBAction)searchByJiaoTong:(id)sender {
    cate = 6;
    [self performSegueWithIdentifier:@"cataSearch" sender:self];
}

- (IBAction)searchByHuaFei:(id)sender {
    cate = 3;
    [self performSegueWithIdentifier:@"cataSearch" sender:self];
}

- (IBAction)searchByWangGou:(id)sender {
    cate = 4;
    [self performSegueWithIdentifier:@"cataSearch" sender:self];
}

- (IBAction)searchByOther:(id)sender {
    cate = 7;
    [self performSegueWithIdentifier:@"cataSearch" sender:self];
}
@end
