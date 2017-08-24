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
        HXGaugeChart *gauge = [[HXGaugeChart alloc] initWithFrame:CGRectMake(x, y, chartWidth, chartWidth) withMaxValue:300 value:280];
        
        [self.view addSubview:gauge];
        
        gauge.valueTitle = @"280";
        
        gauge.colorArray = @[[self colorWithHexString:@"#33d24e" alpha:1],
                             [self colorWithHexString:@"#f8e71c" alpha:1],
                             [self colorWithHexString:@"#ff9500" alpha:1],
                             [self colorWithHexString:@"#ff4e65" alpha:1]];
        gauge.locations = @[@0.15,@0.4,@0.65,@0.8];
        
        gauge.markCount = 7;
        
    } else if (index == 1){///圆形图
    
    } else if (index == 2){///柱状图
        
    } else if (index == 3){///折线图
        
    }
//    tools.iPadHomeColor1 = [tools colorWithHexString:@"#ff4e65" alpha:1];
//    tools.iPadHomeColor2 = [tools colorWithHexString:@"#ff9500" alpha:1];
//    tools.iPadHomeColor3 = [tools colorWithHexString:@"#f8e71c" alpha:1];
//    tools.iPadHomeColor4 = [tools colorWithHexString:@"#33d24e" alpha:1];
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
