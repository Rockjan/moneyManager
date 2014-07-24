//
//  drawRect.h
//  drawLineDemo
//
//  Created by ppnd on 14-6-18.
//  Copyright (c) 2014年 zy_PC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface drawRect : UIView
{
    float totalCount;
    float maxValue;
    
    int maxPercent;
    
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
    
    int hCount;
    int vCount;
    
    NSMutableArray *tempData;
}
@property (nonatomic,retain) NSMutableArray *datas;

@end
