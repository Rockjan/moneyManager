//
//  ViewController.h
//  moneyManager
//
//  Created by ppnd on 14-7-5.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface ViewController : UIViewController<UITextFieldDelegate,ZBarReaderDelegate>
{
    BOOL typeFlag;
    int types;
}

@property (weak, nonatomic) IBOutlet UITextField *proName;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UILabel *nameTxt;
@property (weak, nonatomic) IBOutlet UILabel *priceTxt;
@property (weak, nonatomic) IBOutlet UILabel *amountTxt;
@property (weak, nonatomic) IBOutlet UIImageView *cataImg;
@property (weak, nonatomic) IBOutlet UIImageView *tuDing;
@property (weak, nonatomic) IBOutlet UIView *billView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImg;

- (IBAction)clearTF:(id)sender;
- (IBAction)clearBill:(id)sender;
- (IBAction)onOk:(id)sender;
- (IBAction)onClickTXM:(id)sender;
- (IBAction)onCanYin:(id)sender;
- (IBAction)onBook:(id)sender;
- (IBAction)onFangZu:(id)sender;
- (IBAction)onHuaFei:(id)sender;
- (IBAction)onWangGou:(id)sender;
- (IBAction)onFuShi:(id)sender;
- (IBAction)onJiaoTong:(id)sender;
- (IBAction)onQiTa:(id)sender;



@end
