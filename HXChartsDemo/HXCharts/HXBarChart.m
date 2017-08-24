//
//  HXBarChart.m
//  移动运维
//
//  Created by 韩旭 on 2017/8/22.
//  Copyright © 2017年 韩旭. All rights reserved.
//

#import "HXBarChart.h"

@interface HXBarChart()
@property (nonatomic, strong) CAShapeLayer *lineLayer;

@property (nonatomic, strong) CAGradientLayer *colorLayer;

@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat titleWidth;
@property (nonatomic, assign) CGFloat maxChar;
@property (nonatomic, assign) int maxValue;
@property (nonatomic, assign) int valueLength;
@end

@implementation HXBarChart

- (instancetype)initWithFrame:(CGRect)frame{
    self =  [super initWithFrame:frame];
    
    if (self) {

        [self drawBar];
    }
    return self;
}


- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    
    if (titleArray.count == 0) {
        return;
    }
    
    _titleHeight = (_lineHeight - _margin - (titleArray.count - 1) * _margin) / titleArray.count;
    _titleWidth = _x - 10;
    
    for (int i = 0; i < titleArray.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _margin / 2 + i * (_titleHeight + _margin), _titleWidth, _titleHeight)];
        [self addSubview:titleLabel];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.text = titleArray[i];
        titleLabel.textAlignment = NSTextAlignmentRight;
    }
}

- (void)setValueArray:(NSArray *)valueArray{
    _valueArray = valueArray;

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
    
    
    CGFloat valueHeight = (_lineHeight - _margin - (valueArray.count - 1) * _margin) / valueArray.count;
    CGFloat valueWidth = _lineWidth;
    
    CGFloat labelWidth = _lineWidth / 10;
    
    for (int i = 0; i < 11; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * labelWidth + _x - labelWidth / 2, _lineHeight + 5, labelWidth, 15)];
        
        [self addSubview:label];
        
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            label.text = @"0";
        } else if(i == 10){
            label.text = [NSString stringWithFormat:@"%d",_maxValue];
        } else{
            if (_maxValue < 10) {
                label.text = [NSString stringWithFormat:@"%.1f",(float)_maxValue / 10 * i];
            } else{
                label.text = [NSString stringWithFormat:@"%d",_maxValue / 10 * i];
            }
        }
    }
    
    
    for (int i = 0; i < valueArray.count; i++) {
        //柱状图
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        shapeLayer.lineWidth= valueHeight;
        
        UIBezierPath *barPath = [UIBezierPath bezierPath];
        
        [barPath moveToPoint:CGPointMake(_x,_margin / 2 + _titleHeight / 2 + i * (_margin + valueHeight))];
        [barPath addLineToPoint:CGPointMake(_x + valueWidth * ([valueArray[i] floatValue] / _maxValue),_margin / 2 + _titleHeight / 2 + i * (_margin + valueHeight))];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_x + valueWidth * ([valueArray[i] floatValue] / _maxValue) + 5, _margin / 2 + _titleHeight / 2 + i * (_margin + valueHeight) - valueHeight / 2, 50, valueHeight)];
        
        [self addSubview:label];
        
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.text = [NSString stringWithFormat:@"%@",valueArray[i]];
        
        shapeLayer.path= barPath.CGPath;
        [self.layer addSublayer:shapeLayer];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        gradientLayer.backgroundColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:gradientLayer];
        
        CAGradientLayer *colorLayer = [CAGradientLayer layer];
        self.colorLayer = colorLayer;
        colorLayer.frame = CGRectMake(_x, 0, _lineWidth * ([valueArray[i] floatValue] / _maxValue) , self.frame.size.height);
        colorLayer.locations = @[@0.3,@0.7];
        colorLayer.startPoint = CGPointMake(0, 0);
        colorLayer.endPoint = CGPointMake(1, 0);
        [gradientLayer addSublayer:colorLayer];
        
        if ([_titleArray[i] isEqualToString:@"新建"]) {
            colorLayer.colors = @[(id)[self colorWithHexString:@"#07B2F6" alpha:1].CGColor,(id)[self colorWithHexString:@"#06A0DD" alpha:1].CGColor];
        } else if([_titleArray[i] isEqualToString:@"已解决"]){
            colorLayer.colors = @[(id)[self colorWithHexString:@"#2CCDCE" alpha:1].CGColor,(id)[self colorWithHexString:@"#27B8B9" alpha:1].CGColor];
        } else if([_titleArray[i] isEqualToString:@"等待"]){
            colorLayer.colors = @[(id)[self colorWithHexString:@"#FCC627" alpha:1].CGColor,(id)[self colorWithHexString:@"#E2B123" alpha:1].CGColor];
        } else if([_titleArray[i] isEqualToString:@"待分派"]){
            colorLayer.colors = @[(id)[self colorWithHexString:@"#FF8E1F" alpha:1].CGColor,(id)[self colorWithHexString:@"#E6801B" alpha:1].CGColor];
        } else if([_titleArray[i] isEqualToString:@"处理中"]){
            colorLayer.colors = @[(id)[self colorWithHexString:@"#606AED" alpha:1].CGColor,(id)[self colorWithHexString:@"#565FD5" alpha:1].CGColor];
        } else if([_titleArray[i] isEqualToString:@"已分派"]){
            colorLayer.colors = @[(id)[self colorWithHexString:@"#FC5592" alpha:1].CGColor,(id)[self colorWithHexString:@"#E34C83" alpha:1].CGColor];
        }

        CAShapeLayer *gressLayer = [CAShapeLayer layer];
        gressLayer.lineWidth = valueHeight;
        gressLayer.strokeColor = [UIColor blueColor].CGColor;
        gressLayer.fillColor = [UIColor clearColor].CGColor;
        gressLayer.lineCap = @"bevel";
        gressLayer.path = barPath.CGPath;
        gradientLayer.mask = gressLayer;
        
        CABasicAnimation *ani = [ CABasicAnimation animationWithKeyPath : NSStringFromSelector ( @selector (strokeEnd))];
        ani.fromValue = @0;
        ani.toValue = @1;
        ani.duration = 1.0;
        [gressLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
    }
}

- (void)drawBar{
    
    CAShapeLayer *lineLayer= [CAShapeLayer layer];
    _lineLayer = lineLayer;
    lineLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色为ClearColor
    lineLayer.lineWidth = 1.0f;
    lineLayer.strokeColor = [UIColor colorWithRed:71.0/255.0 green:74.0/255.0 blue:79.0/255.0 alpha:1].CGColor;
    
    _margin = 10.0;
    _x = 60;
    _height = self.frame.size.height;
    _width = self.frame.size.width;
    _lineWidth = _width - 60;
    _lineHeight = _height - 20;
    
    //参照线
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(_x,0)];
    [linePath addLineToPoint:CGPointMake(_x + _lineWidth,0)];
    [linePath addLineToPoint:CGPointMake(_x + _lineWidth,_lineHeight)];
    [linePath addLineToPoint:CGPointMake(_x,_lineHeight)];
    [linePath addLineToPoint:CGPointMake(_x,0)];
    
    for (int i = 1; i < 10; i++) {
        [linePath moveToPoint:CGPointMake(_x + _lineWidth / 10 * i, 0)];
        [linePath addLineToPoint:CGPointMake(_x + _lineWidth / 10 * i,_lineHeight)];
    }
    
    lineLayer.path = linePath.CGPath;
    [self.layer addSublayer:lineLayer];
    
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



//- (void)setColorArray:(NSArray *)colorArray{
//    _colorArray = colorArray;
//    
//    NSMutableArray *array = [NSMutableArray array];
//    
//    for (UIColor *color in colorArray) {
//        [array addObject:(id)color.CGColor];
//    }
//    
//    _colorLayer.colors = array.copy;
//}

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
