//
//  HXCircleChart.h
//  移动运维
//
//  Created by 韩旭 on 2017/8/22.
//  Copyright © 2017年 韩旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXCircleChart : UIView

///初始化方法
- (instancetype)initWithFrame:(CGRect)frame withMaxValue:(CGFloat)maxValue value:(CGFloat)value;

///值
@property (nonatomic, copy) NSString *valueTitle;
///渐变色数组
@property (nonatomic, strong) NSArray *colorArray;

@end
