//
//  HXCircleChart.m
//  移动运维
//
//  Created by 韩旭 on 2017/8/22.
//  Copyright © 2017年 韩旭. All rights reserved.
//

#import "HXCircleChart.h"
@interface HXCircleChart()
@property (nonatomic, weak) UILabel *valueLabel;

@property (nonatomic, assign) CGFloat value;

@property (nonatomic, assign) CGFloat maxValue;

@property (nonatomic, strong) CAGradientLayer *colorLayer;
@end

@implementation HXCircleChart

- (instancetype)initWithFrame:(CGRect)frame withMaxValue:(CGFloat)maxValue value:(CGFloat)value{

    self =  [super initWithFrame:frame];
    
    if (self) {
        NSLog(@"%f---%f",maxValue,value);
        
        if (maxValue < value) {
            maxValue = value;
        }
        
        _value = value;
        _maxValue = maxValue;
        
        [self drawArc];
    }
    return self;
}


-(void)drawArc
{
    
    ///计算中心点
    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    
    ///底层圆
    CGFloat radius = self.frame.size.width * 0.5 - 15;
    UIBezierPath* arcPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    shapelayer.lineWidth = 20.0;
    shapelayer.strokeColor = [self colorWithHexString:@"#33373c" alpha:1].CGColor;
    shapelayer.fillColor = [UIColor clearColor].CGColor;
    shapelayer.path = arcPath.CGPath;
    
    [self.layer addSublayer:shapelayer];
    
    ///顶层圆
    CGFloat insetRadius = radius;
    
    NSLog(@"value:%f---maxValue:%f",_value,_maxValue);
    
    UIBezierPath *insetArcPath = [UIBezierPath bezierPathWithArcCenter:center radius:insetRadius startAngle:-M_PI_2 endAngle:M_PI * 2 * (_value / _maxValue) - M_PI_2  clockwise:YES];
    
    CAShapeLayer *insetShapelayer = [CAShapeLayer layer];
    insetShapelayer.lineWidth = 20.0;
    insetShapelayer.strokeColor = [UIColor colorWithRed:51.0/255.0 green:55.0/255.0 blue:60.0/255.0 alpha:1].CGColor;
    insetShapelayer.fillColor = [UIColor clearColor].CGColor;
    insetShapelayer.path = insetArcPath.CGPath;
    
    [self.layer addSublayer:insetShapelayer];

    ///标注
    UILabel *valueLabel = [[UILabel alloc] init];
    
    [self addSubview:valueLabel];
    
    self.valueLabel = valueLabel;
    
    valueLabel.frame = CGRectMake(center.x - 50, center.y - 10, 100, 20);
    valueLabel.textColor = [UIColor whiteColor];
    valueLabel.font = [UIFont systemFontOfSize:24 weight:2];
    valueLabel.textAlignment = NSTextAlignmentCenter;

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:gradientLayer];
    
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    self.colorLayer = colorLayer;
    colorLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    colorLayer.locations = @[@0.1,@1.0];
    colorLayer.startPoint = CGPointMake(0, 0);
    colorLayer.endPoint = CGPointMake(1, 0);
    [gradientLayer addSublayer:colorLayer];
    
    
    CAShapeLayer *gressLayer = [CAShapeLayer layer];
    gressLayer.lineWidth = 20.0;
    gressLayer.strokeColor = [UIColor blueColor].CGColor;
    gressLayer.fillColor = [UIColor clearColor].CGColor;
    gressLayer.lineCap = @"bevel";
    gressLayer.path = insetArcPath.CGPath;
    gradientLayer.mask = gressLayer;
    
    CABasicAnimation *ani = [ CABasicAnimation animationWithKeyPath : NSStringFromSelector ( @selector (strokeEnd))];
    ani.fromValue = @0;
    ani.toValue = @1;
    ani.duration = 1.0;
    [gressLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
}

#pragma mark set
- (void)setValueTitle:(NSString *)valueTitle{
    _valueTitle = valueTitle;
    _valueLabel.text = valueTitle;
    
}

- (void)setColorArray:(NSArray *)colorArray{
    _colorArray = colorArray;
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (UIColor *color in colorArray) {
        [array addObject:(id)color.CGColor];
    }
    
    _colorLayer.colors = array.copy;
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
