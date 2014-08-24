//
//  allItemsVC.m
//  moneyManager
//
//  Created by ppnd on 14-7-10.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "allItemsVC.h"
#import "sqlDB.h"
#import "DBitem.h"
#import "itemEdit.h"

#define cellHeight 60
#define pageCapacity 20

@interface allItemsVC ()
{
    sqlDB *myDB;
    NSString *title;
}

@end

@implementation allItemsVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _scanType = 0;
        page = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataSouce = [[NSMutableArray alloc] initWithCapacity:pageCapacity];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:@"reloadData" object:nil];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    myDB = [[sqlDB alloc] init];
    
    [self getData];
    
    self.title = title;
    
}
- (void)reloadTable:(NSNotification *)noti {
    
    DBitem *newitem = (DBitem *)[[noti userInfo] valueForKey:@"newItem"];
    DBitem *olditem = (DBitem *)[[noti userInfo] valueForKey:@"oldItem"];
    [dataSouce removeObject:olditem];
    [dataSouce addObject:newitem];
    [self getData];
    [self.tableView reloadData];
}
- (void)getData {
    
    NSArray *array;
    [myDB openDB];
    switch (_scanType) {
        case 1:
            array = [[NSArray alloc] initWithArray:[myDB searchByDate:_finalDate WithPage:page++ withFlag:0]];
            title = _finalDate;
            break;
        case 2:
            array = [[NSArray alloc] initWithArray:[myDB searchByDate:_finalDate WithPage:page++ withFlag:1]];
            title = _finalDate;
            break;
        case 3:
            array = [[NSArray alloc] initWithArray:[myDB searchByDate:_finalDate WithPage:page++ withFlag:2]];
            title = _finalDate;
            break;
        case 4:
            array = [[NSArray alloc] initWithArray:[myDB searchByCata:_cate WithPage:page++]];
            title = _cateName;
            break;
        default:
            array = [[NSArray alloc] initWithArray:[myDB fetchAllWithPage:page++]];
            title = @"全部物品列表";
            break;
    }
    
    [myDB closeDB];
    
    for (DBitem *i in array) {
        [dataSouce addObject:i];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSouce count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = @"allItemsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }else {
        NSArray *array = [cell.contentView subviews];
        
        for (UIView *v in array) {
            [v removeFromSuperview];
        }
    }
   
    
    DBitem *item = (DBitem *)dataSouce[indexPath.row];
    
    UILabel *ln = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, 40)];
    ln.text =[NSString stringWithFormat:@"%@ ",item.name];
    ln.textColor = [UIColor blueColor];
    ln.font = [UIFont systemFontOfSize:15.0f];
    
    UILabel *lpc = [[UILabel alloc] initWithFrame:CGRectMake(115, 0, 70, 40)];
    lpc.text =[NSString stringWithFormat:@"￥%.1f",item.price];
    lpc.font = [UIFont systemFontOfSize:15.0f];
    
    UILabel *ld = [[UILabel alloc] initWithFrame:CGRectMake(205, 0, 100, 40)];
    ld.text =[NSString stringWithFormat:@"%@/%@/%@",item.year,item.month,item.day];
    ld.font = [UIFont systemFontOfSize:15.0f];
    
    //NSString *text = [NSString stringWithFormat:@"%@ %d*￥%.2f %@ %@//%@//%@",item.name,item.counts,item.price,item.typeString,item.year,item.month,item.day];
    //cell.textLabel.text = text;
    [cell.contentView addSubview:ln];
    [cell.contentView addSubview:lpc];
    [cell.contentView addSubview:ld];
    
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = backView;
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        DBitem *item = dataSouce[indexPath.row]
        ;
        [myDB openDB];
        BOOL suc = [myDB deleteItem:item.ID];
        [myDB closeDB];
        
        if (suc) {
            
            [dataSouce removeObjectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
      
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height))) {
        
        UIActivityIndicatorView *tableFooterActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(75.0f, 10.0f, 20.0f, 20.0f)];
        
        tableFooterActivityIndicator.backgroundColor = [UIColor redColor];
        
        [tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        
        [tableFooterActivityIndicator startAnimating];
        
        [self.tableView.tableFooterView addSubview:tableFooterActivityIndicator];
        [self createTableFooter];
    }
}
// 创建表格底部

- (void) createTableFooter

{
    
    self.tableView.tableFooterView = nil;
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 40.0f)];
    
    UILabel *loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 116.0f, 40.0f)];
    
    [loadMoreText setCenter:tableFooterView.center];
    
    [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    
    [loadMoreText setText:@"上拉显示更多数据"];
    
    [tableFooterView addSubview:loadMoreText];
    
    
    
    self.tableView.tableFooterView = tableFooterView;
    
    [self performSelector:@selector(closeFooter) withObject:self afterDelay:0.5];
    
}
- (void)closeFooter {
    
    [self getData];
    [self.tableView reloadData];
    
    [UIView beginAnimations:@"ani" context:nil];
    
    self.tableView.tableFooterView = nil;
    
    [UIView commitAnimations];
    

}
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    int index = [[self.tableView indexPathForSelectedRow] row];
    itemEdit *iEdit = segue.destinationViewController;
    iEdit.item = dataSouce[index];
    
}


- (IBAction)goBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
