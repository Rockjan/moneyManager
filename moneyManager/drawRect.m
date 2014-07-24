//
//  drawRect.m
//  drawLineDemo
//
//  Created by ppnd on 14-6-18.
//  Copyright (c) 2014年 zy_PC. All rights reserved.
//

#import "drawRect.h"
#import "productItem.h"

#define spaceWidthX 40
#define spaceWidthY 30

@implementation drawRect

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        hCount = 10;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [self initData];
    [self drawCoordinate];
    [self drawArea];
}

- (void)initData
{
    //左上角点
    x = self.bounds.origin.x + spaceWidthX;
    y = self.bounds.origin.y + spaceWidthY;
    
    //右上角点
    ox = x + self.bounds.size.width - x*1.5;
    oy = y;
    
    
    //左下角点
    ex = x;
    ey = y + self.bounds.size.height - y*2;
    
    //整个坐标系长宽
    coorHeight = ey - y;
    coorWidth = ox - x;
    
    vCount = _datas.count;//[_datas count];
    
    totalCount = 0.0;
    maxValue = 0.0;
    
    
    //每个格子的长宽
    stepWidthH = coorWidth/(hCount*1.0);
    stepWidthV = coorHeight/(vCount*1.0);
    
    for (int i = 0; i < _datas.count ; i++) {
        
        productItem *item = _datas[i];
    
        
        totalCount += item.price;

        if (item.price > maxValue) {
            
            maxValue = item.price;
        }
        
      //  item = nil;
      //  [item release];
    }
    
    //sort the data
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:_datas.count];

    
    int tempCount = _datas.count;
    
    for (int j = 0 ; j < tempCount; j++) {
        
        int indexs = 0;
        float errors = 0.0;
        
        for (int i = 0 ; i < _datas.count ; i++) {
            
            productItem *item = _datas[i];
            
            if(item.price > errors){
                indexs = i;
                errors = item.price;
            }
        }
        [tempArray addObject:[_datas objectAtIndex:indexs]];
        [_datas removeObjectAtIndex:indexs];
    }

    _datas = tempArray;
    
    maxPercent = (maxValue/totalCount)*100;
  //  NSLog(@"before : %d and total:%.2f",maxPercent,totalCount);
    maxPercent = (maxPercent/10 + 1)*10;
    maxPercent = (maxPercent > 100 ? 100 : maxPercent);
  //  NSLog(@"after : %d",maxPercent);
    
}
- (void) drawCoordinate
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //开始画坐标轴
    
    CGContextSetLineCap(context, kCGLineCapSquare);
    
    //直线宽度
    
    CGContextSetLineWidth(context,1.0);
    
    //设置颜色
    
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    
    //开始绘制
    
    CGContextBeginPath(context);
    
    //右上角点
    
    CGContextMoveToPoint(context, ox, oy); //-2 突出一点
    
    //左上角点
    
    CGContextAddLineToPoint(context, x, y);
    
    //左下角点
    
    CGContextAddLineToPoint(context, ex, ey);//+2 突出一点
    
    //绘制完成
    
    CGContextStrokePath(context);
    
    
    //开始填充坐标系
    
    CGContextSetLineWidth(context, 0.3);
    
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.6);
    
    float lengths[] = {5,5};
    
    CGContextSetLineDash(context, 0, lengths,2);
    
    int stepWidth = maxPercent/hCount;
    
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    
    //填充水平方向虚线
    for (int i = 1; i <= vCount; i++) {
        
        
        CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.6);
        
        CGContextBeginPath(context);
        
        CGContextMoveToPoint(context, x, y + i*(stepWidthV));
        CGContextAddLineToPoint(context, ox , y + i*(stepWidthV));
        
        CGContextStrokePath(context);
        
        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    }
    
    
    [@"0%" drawInRect:CGRectMake(x - 10, y - 15, 20, 10) withFont:[UIFont systemFontOfSize:8.5f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    
    //填充垂直方向虚线
    
    for (int i = 1; i <= hCount; i++) {
        
        CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.6);
        
        CGContextBeginPath(context);
        
        CGContextMoveToPoint(context, x + i*(stepWidthH) , y);
        CGContextAddLineToPoint(context, x + i*(stepWidthH) , ey);
        
        CGContextStrokePath(context);
        
        
        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
        
        NSString *str = [NSString stringWithFormat:@"%d%%",i*stepWidth];
    
        [str drawInRect:CGRectMake(x + i*(stepWidthH) - 10, y - 15 , 25, 10) withFont:[UIFont systemFontOfSize:8.5f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    }
    
    CGContextSetLineDash (context, 0, 0, 0); //相当于取消画虚线状态
}
- (void) drawArea
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    for (int i = 0 ; i <_datas.count ; i++) {
    
        productItem *item = (productItem *)_datas[i];
        
        float width = coorWidth*((item.price/totalCount)*100/maxPercent);
        
        CGContextSetRGBFillColor(context, 1.0 - 0.125*i, 0.125*i, 0, 1.0);
        CGContextFillRect(context, CGRectMake(x, y + i*stepWidthV, width, stepWidthV));
        CGContextStrokePath(context);
       // NSLog(@"%@",item);
        
        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
        
        NSString *name = [NSString stringWithFormat:@"%@",item.name];
        [name drawInRect:CGRectMake(x - 35, y + i*stepWidthV + 5, 30, 10) withFont:[UIFont systemFontOfSize:8.5f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
        
        NSString *percentage = [NSString stringWithFormat:@"%.1f%%",(item.price/totalCount)*100];
        [percentage drawInRect:CGRectMake(x + width + 5, y + i*stepWidthV + 5, 50, 10) withFont:[UIFont systemFontOfSize:8.5f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
      //  item = nil;
      //  [item release];
    }
    //处理横坐标
    CGContextSetLineWidth(context,1.0);
    
    CGContextSetRGBStrokeColor(context, 0.0, 0, 0, 1.0);
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context,x, y);
    
    CGContextAddLineToPoint(context, ox, oy);
    
    CGContextStrokePath(context);
    
}
- (void)dealloc
{
}
@end
