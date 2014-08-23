//
//  chartPanelVC.m
//  moneyManager
//
//  Created by ppnd on 14-7-5.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "chartPanelVC.h"
#import "drawRect.h"
#import "productItem.h"
#import "drawLine.h"
#import "sqlDB.h"

#define cellHeight 60.0

@interface chartPanelVC ()
{
    int cellTag;
}
@end

@implementation chartPanelVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        cellTag = 100;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = back;
    
    self.title = [NSString stringWithFormat:@"%@消费统计",_chartType];
    [self initDB];
}
- (void)initDB {
    
    sqlDB *myDB = [sqlDB sharedInstance];
    
    if (_dateStr.length<=0) {
        NSDate *nd = [NSDate date];
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"YYYY-MM-DD"];
        _dateStr = [formater stringFromDate:nd];
    }
    
    if ([_chartType isEqualToString:@"年"]) {
        chartData1 = [myDB getChartDataByDate:_dateStr withFlag:0];
        chartData2 = [myDB getChartDataByCata:_dateStr withFlag:0];
    }else{
        chartData1 = [myDB getChartDataByDate:_dateStr withFlag:1];
        chartData2 = [myDB getChartDataByCata:_dateStr withFlag:1];
    }
    float total = 0.0;
    for (productItem *item in chartData2) {
        total += item.price;
    }
    isEmpty = NO;
    
    if (total <= 0.0) {
        isEmpty = YES;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initDB];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 3) {
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = @"chartPanelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }else {
        
        NSArray *views = [[NSArray alloc] initWithArray:[cell.contentView subviews]];
        
        for (UIView *v in views) {
            [v removeFromSuperview];
        }
    }

    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = backView;
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
    [self getTheCustomCell:cell andIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    float height = cellHeight;
    
    switch (indexPath.section) {
        case 1:
        case 2:
            height = 5*cellHeight;
            break;
    }

    return height;
}
- (void)getTheCustomCell:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 40)];
    label.backgroundColor = [UIColor clearColor];
    CGRect frame =[self.tableView bounds];
    if (indexPath.section == 0) {
        
        NSArray *dateComp = [_dateStr componentsSeparatedByString:@"-"];
        
        if ([_chartType isEqualToString:@"年"]) {
            
            label.text = [NSString stringWithFormat:@"%@年",(NSString *)dateComp[0]];
            
        }else{
            
            label.text = [NSString stringWithFormat:@"%@年%@月",(NSString *)dateComp[0],(NSString *)dateComp[1]];
        }
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20];
        
        cellTag = cell.tag;
        
        if (cellTag == 0) {
            cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        [cell.contentView addSubview:label];
        
    }else if (indexPath.section == 2) {
        
        if (isEmpty) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,2*cellHeight ,frame.size.width,40)];
            label.text = @"没有符合条件的数据！";
            label.textAlignment = 1;
            [cell.contentView addSubview:label];
            return;
        }
        
        drawRect *myRect = [[drawRect alloc] initWithFrame:CGRectMake(frame.origin.x+20,0,frame.size.width-40,5*cellHeight)];
        myRect.datas = [chartData2 mutableCopy];
        myRect.backgroundColor = [UIColor clearColor];
        
        // cell.customView.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview:myRect];
        
        //cell.title.text = @"";
        cell.userInteractionEnabled = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
       // [cell setFrame:CGRectMake(0, 0,frame.size.width,frame.size.height/1.5)];
        
    }else if(indexPath.section == 1){
        if (isEmpty) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,2*cellHeight ,frame.size.width,40)];
            label.text = @"没有符合条件的数据！";
            label.textAlignment = 1;
            [cell.contentView addSubview:label];
            return;
        }
        drawLine *myLine = [[drawLine alloc] initWithFrame:CGRectMake(frame.origin.x+20,0,frame.size.width-40,5*cellHeight)];
        
        myLine.vCount = 10;
        if ([_chartType isEqualToString:@"年"]) {
            
            myLine.hCount = 11; //按月份显示 设置为10 按年份显示 设置为11
        }else{
            myLine.hCount = 10; //按月份显示 设置为10 按年份显示 设置为11
        }
        
        myLine.datas = [chartData1 mutableCopy];
        myLine.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview:myLine];
        
        cell.userInteractionEnabled = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
      //  [cell setFrame:CGRectMake(0, 0,frame.size.width,5*cellHeight)];
        
    }else if(indexPath.section == 3) {
        
        NSString *str;
        
        float total = 0.0;
        float avg = 0.0;
        
        if ([_chartType isEqualToString:@"年"]) {
            for (productItem *proc in chartData2) {
                total += proc.price;
            }
            avg = total/12.0;
            str = @"月";
        }else{
            for (productItem *proc in chartData2) {
                total += proc.price;
            }
            avg = total/31.0;
            str = @"日";
        }
        

        if (indexPath.row == 0) {
            label.text = [NSString stringWithFormat:@"%@消费总额:%.2f",_chartType,total];

        }else {
            label.text = [NSString stringWithFormat:@"%@消费均额:%.2f",str,avg];
        }
        
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18];
        [cell.contentView addSubview:label];
        
        cell.userInteractionEnabled = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
      //  [cell setFrame:CGRectMake(0, 0,frame.size.width,label.frame.size.height)];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    dateChooseVC *vc = segue.destinationViewController;
    vc.dateType = _chartType;
    vc.delegate = self;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - custom Delegate

- (void)setDateStrBack:(NSString *)dateStr {
    _dateStr = dateStr;
}

@end
