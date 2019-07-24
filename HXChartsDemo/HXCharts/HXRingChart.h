//
//  HXRingChart.h
//  移动巡检
//
//  Created by 韩旭 on 2018/4/27.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MarkViewDirection){
    MarkViewDirectionNone = 0,
    MarkViewDirectionTop,
    MarkViewDirectionBottom,
    MarkViewDirectionLeft,
    MarkViewDirectionRight
};

@interface HXRingChart : UIView

///中心文字
@property (nonatomic, copy) NSString *title;
@property (nonatomic, weak) UIColor *titleColor;
@property (nonatomic, weak) UIFont *titleFont;
///标注值
@property (nonatomic, weak) UIColor *valueColor;
@property (nonatomic, weak) UIFont *valueFont;
///颜色数组
@property (nonatomic, strong) NSArray *colorArray;
///值数组
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *valueArray;
///图表宽
@property (nonatomic, assign) CGFloat ringWidth;

/**
 初始化方法
 
 @param frame 图表frame
 @param markViewDirection 标注View在图表的方向 默认不显示标注View
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame markViewDirection:(MarkViewDirection)markViewDirection;

///开始绘图
- (void)drawChart;

@end
