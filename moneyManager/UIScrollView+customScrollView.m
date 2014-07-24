//
//  UIScrollView+customScrollView.m
//  moneyManager
//
//  Created by ppnd on 14-7-10.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "UIScrollView+customScrollView.h"

@implementation UIScrollView (customScrollView)
//触摸事件传递给下一个响应者
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
}
@end
