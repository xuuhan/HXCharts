//
//  demoViewController.m
//  HXChartsDemo
//
//  Created by 韩旭 on 2017/8/23.
//  Copyright © 2017年 韩旭. All rights reserved.
//

#import "demoViewController.h"
#import "HXCharts.h"

@interface demoViewController ()

@end

@implementation demoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [self colorWithHexString:@"#272b30" alpha:1];
}

- (void)setIndex:(NSInteger)index{
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGFloat chartWidth = self.view.frame.size.width * 0.7;
    CGFloat x = (width - chartWidth) / 2;
    CGFloat y = (height - chartWidth) / 2;
    
    if (index == 0) {///仪表盘
        
        
        HXGaugeChart *gauge = [[HXGaugeChart alloc] initWithFrame:CGRectMake(x, y, chartWidth, chartWidth) withMaxValue:300 value:225];
        
        gauge.valueTitle = @"225";
        gauge.colorArray = @[[self colorWithHexString:@"#33d24e" alpha:1],
                             [self colorWithHexString:@"#f8e71c" alpha:1],
                             [self colorWithHexString:@"#ff9500" alpha:1],
                             [self colorWithHexString:@"#ff4e65" alpha:1]];
        gauge.locations = @[@0.15,@0.4,@0.65,@0.8];
        gauge.markLabelCount = 5;
        
        [self.view addSubview:gauge];
    } else if (index == 1){///圆形图
        
        HXCircleChart *circle = [[HXCircleChart alloc] initWithFrame:CGRectMake(x, y, chartWidth, chartWidth) withMaxValue:100 value:85];
         
        circle.valueTitle = @"85%";
        
        circle.colorArray = @[[self colorWithHexString:@"#00fec7" alpha:1],[self colorWithHexString:@"#00d8fe" alpha:1]];
        
        circle.locations = @[@0.15,@0.85];
        
        [self.view addSubview:circle];
        
    } else if (index == 2){///柱状图
        CGFloat barChartWidth = self.view.frame.size.width * 0.8;
        CGFloat barChartHeight = self.view.frame.size.height * 0.4;
        
        CGFloat barChartX = (width - barChartWidth) / 2;
        CGFloat barChartY = (height - barChartHeight) / 2;
        
        ///渐变色
        NSArray *color1 = @[[self colorWithHexString:@"#07B2F6" alpha:1],[self colorWithHexString:@"#06A0DD" alpha:1]];
        NSArray *color2 = @[[self colorWithHexString:@"#2CCDCE" alpha:1],[self colorWithHexString:@"#27B8B9" alpha:1]];
        NSArray *color3 = @[[self colorWithHexString:@"#FCC627" alpha:1],[self colorWithHexString:@"#E2B123" alpha:1]];
        NSArray *color4 = @[[self colorWithHexString:@"#FF8E1F" alpha:1],[self colorWithHexString:@"#E6801B" alpha:1]];
        NSArray *color5 = @[[self colorWithHexString:@"#606AED" alpha:1],[self colorWithHexString:@"#565FD5" alpha:1]];
        NSArray *color6 = @[[self colorWithHexString:@"#FC5592" alpha:1],[self colorWithHexString:@"#E34C83" alpha:1]];
        
        
        HXBarChart *bar = [[HXBarChart alloc] initWithFrame:CGRectMake(barChartX, barChartY, barChartWidth, barChartHeight) withMarkLabelCount:6 withOrientationType:OrientationHorizontal];
        
        bar.titleArray = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月"];
        
        bar.valueArray = @[@"34",@"72",@"260",@"44",@"180",@"53"];
        
        bar.colorArray = @[color1,color2,color3,color4,color5,color6];
        
        bar.locations = @[@0.15,@.85];
        
        bar.backgroundLineColor = [self colorWithHexString:@"#4b4e52" alpha:1];
        
        [self.view addSubview:bar];
        
    } else if (index == 3){///折线图
        CGFloat lineChartWidth = self.view.frame.size.width * 0.95;
        CGFloat lineChartHeight = self.view.frame.size.height * 0.3;
        
        CGFloat lineChartX = (width - lineChartWidth) / 2 - 20;
        CGFloat lineChartY = (height - lineChartHeight) / 2;
        
        HXLineChart *line = [[HXLineChart alloc] initWithFrame:CGRectMake(lineChartX, lineChartY, lineChartWidth, lineChartHeight)];
        
        [line setTitleArray:@[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"]];
        
        [line setValue:@[@11,@44,@193,@57,@66,@144,@156] withYLineCount:6];
        
        line.lineColor = [self colorWithHexString:@"#43befa" alpha:1];
        
        line.fillColor = [self colorWithHexString:@"#2e3f53" alpha:0.5];
        
        line.backgroundLineColor = [self colorWithHexString:@"#4b4e52" alpha:1];
        
        [self.view addSubview:line];
    }
}

#pragma mark 设置16进制颜色
- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}


@end
