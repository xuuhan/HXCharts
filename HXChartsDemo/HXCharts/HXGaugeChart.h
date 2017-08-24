//
//  HXCircleChart.h
//  移动运维
//
//  Created by 韩旭 on 2017/8/18.
//  Copyright © 2017年 韩旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXGaugeChart : UIView

///初始化方法
- (instancetype)initWithFrame:(CGRect)frame withMaxValue:(CGFloat)maxValue value:(CGFloat)value;
///值相关
@property (nonatomic, copy) NSString *valueTitle;
@property (nonatomic, copy) UIColor *valueColor;
@property (nonatomic, copy) UIFont *valueFont;
///渐变色数组
@property (nonatomic, strong) NSArray *colorArray;
///渐变色数组所占位置 (比如@[@0.1,@0.3,@0.7])
@property (nonatomic, strong) NSArray *locations;
///要显示的标注个数
@property (nonatomic, assign) int markCount;
@end
