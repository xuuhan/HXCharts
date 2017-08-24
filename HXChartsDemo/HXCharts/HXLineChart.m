//
//  HXLineChart.m
//  移动运维
//
//  Created by 韩旭 on 2017/8/23.
//  Copyright © 2017年 韩旭. All rights reserved.
//

#import "HXLineChart.h"
@interface HXLineChart()

@property(nonatomic,strong)NSArray* colors;
@property(nonatomic,assign)BOOL pathCurve;

@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) CAShapeLayer *xlineLayer;
@property (nonatomic, strong) CAShapeLayer *ylineLayer;

@property (nonatomic, strong) CAGradientLayer *colorLayer;

@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat titleWidth;
@property (nonatomic, assign) int titleCount;
@property (nonatomic, assign) CGFloat maxChar;
@property (nonatomic, assign) int maxValue;
@property (nonatomic, assign) int valueLength;
@end
@implementation HXLineChart

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self drawLine];
    }
    return self;
}

- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    
    if (titleArray.count == 0) {
        return;
    }
    
    _titleCount = (int)titleArray.count;
    
    CAShapeLayer *lineLayer= [self creatCAShapeLayer];
    _xlineLayer = lineLayer;
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    
    for (int i = 0; i < titleArray.count; i++) {
        [linePath moveToPoint:CGPointMake(_x + _margin + (_lineWidth - _margin * 2) / (titleArray.count - 1) * i, 0)];
        [linePath addLineToPoint:CGPointMake(_x + _margin + (_lineWidth - _margin * 2) / (titleArray.count - 1) * i, _lineHeight)];
    }
    
    lineLayer.path = linePath.CGPath;
    [self.layer addSublayer:lineLayer];
    
    
    _titleHeight = (_height - _lineHeight - 5);
    _titleWidth = (_lineWidth / titleArray.count);
    
    for (int i = 0; i < titleArray.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_x + _margin + (_lineWidth - _margin * 2) / (titleArray.count - 1) * i - _titleWidth / 2, _lineHeight + 5, _titleWidth, _titleHeight)];
        [self addSubview:titleLabel];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.text = titleArray[i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
    }
}


- (void)setValue:(NSArray *)valueArray withYLineCount:(int)count{
    
    if (valueArray.count == 0) {
        return;
    }
    
    int maxValueAtArray = [[valueArray valueForKeyPath:@"@max.intValue"] intValue];
    
    if (maxValueAtArray == 0) {
        return;
    }
    
    [self maxValue:maxValueAtArray];
    _maxValue = _maxChar + 1;
    
    for (int i = 0; i < _valueLength - 1; i++) {
        _maxValue = _maxValue * 10;
    }
    
    CAShapeLayer *lineLayer= [self creatCAShapeLayer];
    _ylineLayer = lineLayer;
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    for (int i = 1; i < count - 1; i++) {
        [linePath moveToPoint:CGPointMake(_x , _lineHeight / (count - 1) * i)];
        [linePath addLineToPoint:CGPointMake(_x + _lineWidth,_lineHeight / (count - 1) * i)];
    }
    
    lineLayer.path = linePath.CGPath;
    [self.layer addSublayer:lineLayer];

    CGFloat valueHeight = 20;
    CGFloat valueWidth = _x - 10;
    
    for (int i = 0; i < count; i++) {
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, i * (_lineHeight / (count - 1)) - valueHeight / 2, valueWidth, valueHeight)];
        [self addSubview:valueLabel];
        valueLabel.textColor = [UIColor whiteColor];
        valueLabel.font = [UIFont systemFontOfSize:12];
        valueLabel.textAlignment = NSTextAlignmentRight;
        
        if (i == 0) {
            valueLabel.text = [NSString stringWithFormat:@"%d",_maxValue];
        } else if(i == count - 1){
            valueLabel.text = @"0";
        } else{
            if (_maxValue < count - 1) {
                valueLabel.text = [NSString stringWithFormat:@"%.1f",(float)_maxValue / (count - 1) * (count - 1 - i)];
            } else{
                valueLabel.text = [NSString stringWithFormat:@"%d",_maxValue / (count - 1) * (count - 1 - i)];
            }
        }
    }
    
    ///折线图
    CAShapeLayer *lineChartLayer = [CAShapeLayer layer];
    lineChartLayer.fillColor= [UIColor clearColor].CGColor;
    lineChartLayer.strokeColor = [self colorWithHexString:@"#43befa" alpha:1].CGColor;
    lineChartLayer.lineWidth = 2;
    
    CAShapeLayer *fillChartLayer = [CAShapeLayer layer];
    fillChartLayer.fillColor= fillChartLayer.strokeColor = [self colorWithHexString:@"#2e3f53" alpha:0.5].CGColor;
    fillChartLayer.strokeColor = [UIColor clearColor].CGColor;
    fillChartLayer.lineWidth = 1;
    
    UIBezierPath *lPath = [UIBezierPath bezierPath];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    NSLog(@"value:%f-----maxvalue:%d",[valueArray[0] floatValue],_maxValue);
    
    [path moveToPoint:CGPointMake(_x, _lineHeight - _lineHeight * ([valueArray[0] floatValue] / _maxValue))];
    [lPath moveToPoint:CGPointMake(_x, _lineHeight - _lineHeight * ([valueArray[0] floatValue] / _maxValue))];
    [lPath addLineToPoint:CGPointMake(_x + _margin, _lineHeight - _lineHeight * ([valueArray[0] floatValue] / _maxValue))];
    [path addLineToPoint:CGPointMake(_x + _margin, _lineHeight - _lineHeight * ([valueArray[0] floatValue] / _maxValue))];
    
    for (int i = 1; i < valueArray.count ; i++) {
        [lPath addLineToPoint:CGPointMake(_x + _margin + (_lineWidth - _margin * 2) / (_titleCount - 1) * i,_lineHeight - _lineHeight * [valueArray[i] floatValue] / _maxValue)];
        
        [path addLineToPoint:CGPointMake(_x + _margin + (_lineWidth - _margin * 2) / (_titleCount - 1) * i,_lineHeight - _lineHeight * [valueArray[i] floatValue] / _maxValue)];
        
        if (i == valueArray.count - 1) {
        [lPath addLineToPoint:CGPointMake(_width,_lineHeight - _lineHeight * [valueArray[i] floatValue] / _maxValue)];
        [path addLineToPoint:CGPointMake(_width,_lineHeight - _lineHeight * [valueArray[i] floatValue] / _maxValue)];
        [path addLineToPoint:CGPointMake(_width,_lineHeight)];
        [path addLineToPoint:CGPointMake(_x,_lineHeight)];
        [path moveToPoint:CGPointMake(_x, _lineHeight - _lineHeight * ([valueArray[0] floatValue] / _maxValue))];
        }
    }
    
    lineChartLayer.path = lPath.CGPath;
    [self.layer addSublayer:lineChartLayer];
    fillChartLayer.path = path.CGPath;
//    [self.layer addSublayer:fillChartLayer];
    
    CABasicAnimation *ani = [ CABasicAnimation animationWithKeyPath : NSStringFromSelector ( @selector (strokeEnd))];
    ani.fromValue = @0;
    ani.toValue = @1;
    ani.duration = 1.0;
    [lineChartLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.layer addSublayer:fillChartLayer];
    });
}


-(void)drawLine
{
    CAShapeLayer *lineLayer= [self creatCAShapeLayer];
    _lineLayer = lineLayer;
    
    _margin = 20.0;
    _x = 60;
    _height = self.frame.size.height;
    _width = self.frame.size.width;
    _lineWidth = _width - _x;
    _lineHeight = _height - 20;
    
    //参照线
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(_x,0)];
    [linePath addLineToPoint:CGPointMake(_x + _lineWidth,0)];
    [linePath moveToPoint:CGPointMake(_x + _lineWidth,_lineHeight)];
    [linePath addLineToPoint:CGPointMake(_x,_lineHeight)];
    
    lineLayer.path = linePath.CGPath;
    [self.layer addSublayer:lineLayer];
}

- (CAShapeLayer *)creatCAShapeLayer{
    CAShapeLayer *lineLayer= [CAShapeLayer layer];
    lineLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色为ClearColor
    lineLayer.lineWidth = 1.0f;
    lineLayer.strokeColor = [self colorWithHexString:@"#4b4e52" alpha:1].CGColor;
    
    return lineLayer;
}

- (void)maxValue:(int)value{
    _valueLength ++;
    
    if (value < 10) {
        _maxChar = value;
        return;
    }
    
    int v = value / 10;
    
    [self maxValue:v];
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
