//
//  HXCircleChart.h
//  移动运维
//
//  Created by 韩旭 on 2017/8/22.
//  Copyright © 2017年 韩旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXCircleChart : UIView

///值相关
@property (nonatomic, copy) NSString *valueTitle;
@property (nonatomic, weak) UIColor *valueColor;
@property (nonatomic, weak) UIFont *valueFont;
///渐变色数组
@property (nonatomic, strong) NSArray *colorArray;
///渐变色数组所占位置
@property (nonatomic, strong) NSArray *locations;
///底圆颜色
@property (nonatomic, strong) UIColor *insideCircleColor;
///单色
@property (nonatomic, strong) UIColor *singleColor;

///初始化方法
- (instancetype)initWithFrame:(CGRect)frame withMaxValue:(CGFloat)maxValue value:(CGFloat)value;

@end
