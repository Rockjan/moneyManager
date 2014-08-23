//
//  scanByCata.h
//  moneyManager
//
//  Created by ppnd on 14-7-9.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface scanByCataVC : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)goBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *byFood;
@property (weak, nonatomic) IBOutlet UIButton *byWangG;
@property (weak, nonatomic) IBOutlet UIButton *byFuZ;
@property (weak, nonatomic) IBOutlet UIButton *byJiaoT;
- (IBAction)searchByfood:(id)sender;
- (IBAction)searchByBook:(id)sender;
- (IBAction)searchByFangZu:(id)sender;
- (IBAction)searchByFuZhuang:(id)sender;
- (IBAction)searchByJiaoTong:(id)sender;
- (IBAction)searchByHuaFei:(id)sender;
- (IBAction)searchByWangGou:(id)sender;
- (IBAction)searchByOther:(id)sender;

@end
