//
//  drawLine.h
//  drawLineDemo
//
//  Created by zy_PC on 14-6-8.
//  Copyright (c) 2014年 zy_PC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface drawLine : UIView
{
    int x;
    int y;
    
    int ox;
    int oy;
    
    int ex;
    int ey;
    
    int coorHeight;
    int coorWidth;
    
    float stepWidthV;
    float stepWidthH;
    
    float avgValue;
    
    int maxValue;
}
@property (nonatomic,assign) int hCount; //水平方向 坐标点个数（10 or 12个）
@property (nonatomic,assign) int vCount; //垂直方向 坐标点个数 （个数不限）
@property (nonatomic,retain) NSArray *datas;
@end
