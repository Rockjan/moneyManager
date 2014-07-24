//
//  drawLine.m
//  drawLineDemo
//
//  Created by zy_PC on 14-6-8.
//  Copyright (c) 2014年 zy_PC. All rights reserved.
//

#import "drawLine.h"

#define spaceWidthX 40
#define spaceWidthY 40

@implementation drawLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    [self initData];
    
    [self drawCoordinate];
    
    [self drawArea];
}

- (void)initData
{
    
    //注意ios屏幕坐标原点位置！！！！
    
    x = self.bounds.origin.x + spaceWidthX;
    y = self.bounds.origin.y + spaceWidthY;
    
    ox = x;
    oy = y + self.bounds.size.height - y*2;
    
    ex = x + self.bounds.size.width - x*1.5;
    ey = oy;
    
    coorHeight = oy - y;
    coorWidth = ex - ox;
    
    stepWidthH = coorWidth/(_hCount*1.0);
    stepWidthV = coorHeight/(_vCount*1.0);
    
    avgValue = [self getMaxValue];
   // NSLog(@"avg:%f",avgValue);
    
}

- (void)drawCoordinate
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //开始画坐标轴
    
    CGContextSetLineCap(context, kCGLineCapSquare);
    
    //直线宽度
    
    CGContextSetLineWidth(context,1.0);
    
    //设置颜色
    
    CGContextSetRGBStrokeColor(context, 0.0, 0, 0, 1.0);
    
    //开始绘制
    
    CGContextBeginPath(context);
    
    //左上角点
    
    CGContextMoveToPoint(context, x, y - 2); //-2 突出一点
    
    //左下角点
    
    CGContextAddLineToPoint(context, ox, oy);
    
    //右下角点
    
    CGContextAddLineToPoint(context, ex + 2, ey);//+2 突出一点
    
    //绘制完成
    
    CGContextStrokePath(context);
    
    
    [@"金额￥" drawInRect:CGRectMake(x - 20, y - 25, 40, 20) withFont:[UIFont systemFontOfSize:8.5f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    [@"日期" drawInRect:CGRectMake(ex - 30, ey + 20, 30, 20) withFont:[UIFont systemFontOfSize:8.5f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
    
    NSString *avgStr = [NSString stringWithFormat:@"平均消费线：￥%.2f",avgValue];
    [avgStr drawInRect:CGRectMake(x+35, ey + 20, coorWidth/2, 20) withFont:[UIFont systemFontOfSize:8.5f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
    
    //开始填充坐标系
    
    CGContextSetLineWidth(context, 0.5);
    
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.6);
    
    float lengths[] = {5,5};

    CGContextSetLineDash(context, 0, lengths,2);
    
    int stepWidth = maxValue/_vCount;
    
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    
    [@"0" drawInRect:CGRectMake(5, ey - 10, 30, 10) withFont:[UIFont systemFontOfSize:8.5f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
    
    //填充水平方向虚线
    for (int i = 1; i <= _vCount; i++) {

        
        CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.6);
        
        CGContextBeginPath(context);
        
        CGContextMoveToPoint(context, x, ey - i*(stepWidthV));
        CGContextAddLineToPoint(context, ex , ey - i*(stepWidthV));
        
        CGContextStrokePath(context);
        
        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
        
        NSString *str = [NSString stringWithFormat:@"%d",(i)*stepWidth];
        
        //[str drawInRect:CGRectMake(5, ey - i*(stepWidthV) - 10, 40, 20) withFont:[UIFont boldSystemFontOfSize:12.0f]];
        [str drawInRect:CGRectMake(5, ey - i*(stepWidthV) - 10, 30, 10) withFont:[UIFont systemFontOfSize:8.5f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
    }
    
    //画平均值直线
    
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, x, coorHeight + spaceWidthY - avgValue*coorHeight/(maxValue*1.0));
    CGContextAddLineToPoint(context, ex ,coorHeight + spaceWidthY - avgValue*coorHeight/(maxValue*1.0));
    
    CGContextStrokePath(context);
    
    //画图例 红色平均线
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, x, ey + 25);
    CGContextAddLineToPoint(context, x+35 ,ey + 25);
    
    CGContextStrokePath(context);
    
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    
    [@"1" drawInRect:CGRectMake(x - 10, ey + 5, 20, 10) withFont:[UIFont systemFontOfSize:8.5f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    
    //填充垂直方向虚线
    
    int indx = 4;
    
    for (int i = 1; i <= _hCount; i++) {
        
        CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.6);
        
        CGContextBeginPath(context);
        
        CGContextMoveToPoint(context, x + i*(stepWidthH) , y);
        CGContextAddLineToPoint(context, x + i*(stepWidthH) , ey);
        
        CGContextStrokePath(context);
        
        
        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
        
        NSString *str = [NSString stringWithFormat:@"%d",(_hCount == 10 ?(indx):(i+1))];
        
        //[str drawInRect:CGRectMake(x + i*(stepWidthH) - 10, ey + 5, 20, 20) withFont:[UIFont boldSystemFontOfSize:12.0f] ];
        [str drawInRect:CGRectMake(x + i*(stepWidthH) - 10, ey + 5, 20, 10) withFont:[UIFont systemFontOfSize:8.5f] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        indx += 3;
    }
    
    CGContextSetLineDash (context, 0, 0, 0); //相当于取消画虚线状态

}
- (void) drawArea
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.2, 1.0);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.1);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 0.8);
    CGContextSetLineCap(context, kCGLineCapSquare);
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    /* do something with pathRef. For example:*/
    
    CGPathMoveToPoint(pathRef, NULL, ox, oy);
    for (int i = 0 ; i <_datas.count ; i++) {
        
        float position = i*coorWidth/((_datas.count-1)*1.0);
        float height = [_datas[i] floatValue]*coorHeight/(maxValue*1.0);
        
        CGPathAddLineToPoint(pathRef, NULL, ox + position,coorHeight + spaceWidthY - height);
    }
    CGPathAddLineToPoint(pathRef, NULL, ex, ey);
    CGPathCloseSubpath(pathRef);
    
    CGContextAddPath(context, pathRef);
    CGContextFillPath(context);
    
    CGContextAddPath(context, pathRef);
    CGContextStrokePath(context);
    
    CGPathRelease(pathRef);
    
    //处理横坐标
    CGContextSetLineWidth(context,1.2);
    
    CGContextSetRGBStrokeColor(context, 0.0, 0, 0, 1.0);
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context,ox, oy);
    
    CGContextAddLineToPoint(context, ex, ey);
    
    CGContextStrokePath(context);

}
- (float) getMaxValue
{
    int value = 0;
    float total = .0;
    
    for (int i = 0 ; i < _datas.count ; i++) {
        
        int temp = (int)[_datas[i] floatValue];
        total += [_datas[i] floatValue];
        
        if (temp > value) {
            value = temp;
        }
    }
    maxValue = value*1.2;
    return total/(_datas.count*1.0);
}
@end
