# HXCharts

HXCharts包括了仪表盘、柱状图、圆形图、折线图等四种绘图。

仪表盘、柱状图、圆形图支持渐变色或单色，折线图只支持单色

柱状图支持水平和竖直两种方向。

折线图支持负数。

仪表盘、柱状图、折线图可以自定义标注值的数量。

下面是在项目中使用HXCharts的实际效果:

![image](https://github.com/xuuhan/HXCharts/blob/master/xx.gif)

# 语言

* Objective-C

# 安装

* 下载demo，将HXcharts文件夹拖入到自己项目中

# 版本 1.1

* 版本更新说明:折线图支持负数，当出现负数时，会自动计算Y轴标注值个数，初始化自定义y轴个数参数将失效。

# 使用

![image](https://github.com/xuuhan/HXCharts/blob/master/xx1.gif)

* 导入头文件

```
#import "HXCharts.h"
```

## 仪表盘

* 用初始化方法并传入最大值与实际值
* 传入颜色
* 传入要显示标注值的数量
```
        HXGaugeChart *gauge = [[HXGaugeChart alloc] initWithFrame:CGRectMake(x, y, chartWidth, chartWidth) withMaxValue:300 value:225];
        
        gauge.valueTitle = @"225";
        gauge.colorArray = @[[self colorWithHexString:@"#33d24e" alpha:1],
                             [self colorWithHexString:@"#f8e71c" alpha:1],
                             [self colorWithHexString:@"#ff9500" alpha:1],
                             [self colorWithHexString:@"#ff4e65" alpha:1]];
        gauge.locations = @[@0.15,@0.4,@0.65,@0.8];
        gauge.markLabelCount = 5;
        
        [self.view addSubview:gauge];
```

## 圆形图

* 用初始化方法并传入最大值与实际值
* 传入颜色

```
        HXCircleChart *circle = [[HXCircleChart alloc] initWithFrame:CGRectMake(x, y, chartWidth, chartWidth) withMaxValue:100 value:85];
         
        circle.valueTitle = @"85%";
        
        circle.colorArray = @[[self colorWithHexString:@"#00fec7" alpha:1],[self colorWithHexString:@"#00d8fe" alpha:1]];
        
        circle.locations = @[@0.15,@0.85];
        
        [self.view addSubview:circle];
```

## 柱状图

* 用初始化方法传入标注值的个数与绘图方向
* 传入文字数组
* 传入对应值数组
* 传入柱子颜色数组与背景线颜色(默认灰色)
* 要修改柱子的宽度需要去.m文件中修改_margin(柱子间间距)的值

```
        HXBarChart *bar = [[HXBarChart alloc] initWithFrame:CGRectMake(barChartX, barChartY, barChartWidth, barChartHeight) withMarkLabelCount:6 withOrientationType:OrientationHorizontal];
        
        bar.titleArray = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月"];
        
        bar.valueArray = @[@"34",@"72",@"260",@"44",@"180",@"53"];
        
        bar.colorArray = @[color1,color2,color3,color4,color5,color6];
        
        bar.locations = @[@0.15,@.85];
        
        bar.backgroundLineColor = [self colorWithHexString:@"#4b4e52" alpha:1];
        
        [self.view addSubview:bar];
```

## 折线图

* 初始化
* 传入文字数组
* 传入对应值数组
* 传入画线颜色、填充颜色与背景线颜色(默认灰色)

```
HXLineChart *line = [[HXLineChart alloc] initWithFrame:CGRectMake(lineChartX, lineChartY, lineChartWidth, lineChartHeight)];
        
        [line setTitleArray:@[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"]];
        
        [line setValue:@[@11,@44,@193,@57,@66,@144,@156] withYLineCount:6];
        
        line.lineColor = [self colorWithHexString:@"#43befa" alpha:1];
        
        line.fillColor = [self colorWithHexString:@"#2e3f53" alpha:0.5];
        
        line.backgroundLineColor = [self colorWithHexString:@"#4b4e52" alpha:1];
        
        [self.view addSubview:line];
```

# 说明

demo中颜色使用的是渐变色，也可以选择单色，更多属性请去.h文件里看

demo中内附16进制颜色转三原色方法 

小伙伴有优化建议、功能拓展的想法或者什么问题的话请加QQ群620105128 我们一起讨论

整理了一些使用介绍：http://www.jianshu.com/p/e478636d7718 

手里有新活 每天都很忙 11月之前不做功能更新 现有版本出现bug请提Issues


