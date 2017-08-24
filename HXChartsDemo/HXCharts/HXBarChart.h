//
//  HXBarChart.h
//  移动运维
//
//  Created by 韩旭 on 2017/8/22.
//  Copyright © 2017年 韩旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXBarChart : UIView

///文字数组
@property (nonatomic, strong) NSArray *titleArray;
///数值数组
@property (nonatomic, strong) NSArray *valueArray;
///渐变色数组
@property (nonatomic, strong) NSArray *colorArray;

@end
