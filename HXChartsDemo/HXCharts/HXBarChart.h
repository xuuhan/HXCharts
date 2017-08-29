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
    OrientationVertical = 1,///竖向
};

@interface HXBarChart : UIView


/**
 初始化方法

 @param frame frame
 @param markLabelCount 标注值个数
 @param type 柱状图方向
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame withMarkLabelCount:(int)markLabelCount withOrientationType:(OrientationType)type;

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
@property (nonatomic, weak) UIColor *markTextColor;
@property (nonatomic, weak) UIFont *markTextFont;
///背景线颜色
@property (nonatomic, weak) UIColor *backgroundLineColor;
@end
