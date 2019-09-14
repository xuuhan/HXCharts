//
//  HXBarChart.h
//  移动运维
//
//  Created by 韩旭 on 2017/8/22.
//  Copyright © 2017年 韩旭. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OrientationType) {
    OrientationHorizontal = 0,///横向
    OrientationVertical = 1,///垂直
};

typedef NS_ENUM(NSInteger, GradientType) {
    GradientHorizontal = 0,///横向渐变
    GradientVertical = 1,///垂直渐变
};

@interface HXBarChart : UIView

///文字数组
@property (nonatomic, strong) NSArray *titleArray;
///数值数组
@property (nonatomic, strong) NSArray *valueArray;
///渐变色数组
@property (nonatomic, strong) NSArray *colorArray;
///渐变色数组所占位置
@property (nonatomic, strong) NSArray *locations;
///单色数组
@property (nonatomic, strong) NSArray *singleColorArray;
///标注值
@property (nonatomic, strong) UIColor *markTextColor;
@property (nonatomic, strong) UIFont *markTextFont;
///参照线颜色
@property (nonatomic, strong) UIColor *xlineColor;
///设置标注值Label的旋转角度，效果原因只在竖直柱状图时有效
@property (nonatomic, assign) CGFloat labelRotation;

///如果要图表可以滑动设置的偏移值，横向柱状图时为水平滑动，竖向柱状图时为垂直滑动
///不需要滑动则不设置即可
@property (nonatomic, assign) CGFloat contentValue;
///默认会自动计算柱状图宽度和间隔 如果要设置 请两个属性一起设置
///单个柱宽度
@property (nonatomic, assign) CGFloat barWidth;
///间距
@property (nonatomic, assign) CGFloat margin;

///可滑动时默认显示的初始偏移距离，默认不偏移
@property (nonatomic, assign) CGPoint contentOffset;

///渐变的方向，默认垂直
@property (nonatomic, assign) GradientType gradientType;

/**
 初始化方法
 
 @param frame frame
 @param markLabelCount 标注值个数
 @param type 柱状图方向
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame withMarkLabelCount:(int)markLabelCount withOrientationType:(OrientationType)type;

///开始绘图
- (void)drawChart;

@end
