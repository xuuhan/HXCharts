//
//  HXLineChart.h
//  移动运维
//
//  Created by 韩旭 on 2017/8/23.
//  Copyright © 2017年 韩旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXLineChart : UIView

- (void)setValue:(NSArray *)valueArray withYLineCount:(int)count;

@property (nonatomic, strong) NSArray *titleArray;
@end
