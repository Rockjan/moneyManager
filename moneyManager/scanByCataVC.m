//
//  scanByCata.m
//  moneyManager
//
//  Created by ppnd on 14-7-9.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "scanByCataVC.h"

@interface scanByCataVC ()

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
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
