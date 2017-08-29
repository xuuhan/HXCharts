# HXCharts

HXCharts包括了仪表盘、柱状图、圆形图、折线图等四种绘图。

仪表盘、柱状图、圆形图支持渐变色或单色。

柱状图支持水平和竖直两种方向。

仪表盘、柱状图、折线图可以自定义标注值的数量。

下面是在项目中使用HXCharts的实际效果:

![image](https://github.com/xuuhan/HXCharts/blob/master/xx.gif)

# 语言

* Objective-C

# 安装

* 下载demo，将HXcharts文件夹拖入到自己项目中

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




