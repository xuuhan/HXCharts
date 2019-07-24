//
//  HXCircleChart.h
//  移动运维
//
//  Created by 韩旭 on 2017/8/18.
//  Copyright © 2017年 韩旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXGaugeChart : UIView

///值相关
@property (nonatomic, copy) NSString *valueTitle;
@property (nonatomic, weak) UIColor *valueColor;
@property (nonatomic, weak) UIFont *valueFont;
///渐变色数组
@property (nonatomic, strong) NSArray *colorArray;
///渐变色数组所占位置
@property (nonatomic, strong) NSArray *locations;
///要显示的标注个数
@property (nonatomic, assign) int markLabelCount;
@property (nonatomic, weak) UIColor *markTextColor;
@property (nonatomic, weak) UIFont *markTextFont;
///外圆颜色
@property (nonatomic, strong) UIColor *outerCircleColor;
///外圆线宽
@property (nonatomic, assign) CGFloat outerCircleWidth;
///单色
@property (nonatomic, strong) UIColor *singleColor;

///初始化方法
- (instancetype)initWithFrame:(CGRect)frame withMaxValue:(CGFloat)maxValue value:(CGFloat)value;
@end
