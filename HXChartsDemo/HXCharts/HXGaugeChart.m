//
//  HXCircleChart.m
//  移动运维
//
//  Created by 韩旭 on 2017/8/18.
//  Copyright © 2017年 韩旭. All rights reserved.
//

#import "HXGaugeChart.h"

@interface HXGaugeChart()

@property (nonatomic, weak) UILabel *valueLabel;

@property (nonatomic, assign) CGFloat value;

@property (nonatomic, assign) CGFloat maxValue;

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, strong) CAGradientLayer *colorLayer;

@property (nonatomic, strong) NSMutableArray *markLabelArray;

@property (nonatomic, strong) CAShapeLayer *circleLayer;

@end

@implementation HXGaugeChart

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
    NSLog(@"%f",_value / _maxValue);

    _width = self.frame.size.width;
    
    ///计算中心点
    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    
    ///外圆
    CGFloat radius = self.frame.size.width * 0.5 - 15;
    _radius = radius;
    UIBezierPath* arcPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:M_PI endAngle:0 clockwise:YES];
    
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    shapelayer.lineWidth = 3.0;
    shapelayer.strokeColor = [UIColor colorWithRed:51.0/255.0 green:55.0/255.0 blue:60.0/255.0 alpha:1].CGColor;
    shapelayer.fillColor = [UIColor clearColor].CGColor;
    shapelayer.path = arcPath.CGPath;
   
    [self.layer addSublayer:shapelayer];
    
    ///内圆
    CGFloat insetRadius = radius - 20;
   
    UIBezierPath *insetArcPath = [UIBezierPath bezierPathWithArcCenter:center radius:insetRadius startAngle:M_PI endAngle:M_PI * 2 * (_value / _maxValue) clockwise:YES];
    
    CAShapeLayer *insetShapelayer = [CAShapeLayer layer];
    insetShapelayer.lineWidth = 20.0;
    insetShapelayer.strokeColor = [UIColor clearColor].CGColor;
    insetShapelayer.fillColor = [UIColor clearColor].CGColor;
    insetShapelayer.path = insetArcPath.CGPath;
    
    [self.layer addSublayer:insetShapelayer];
    
    ///标注值
    UILabel *valueLabel = [[UILabel alloc] init];
    
    [self addSubview:valueLabel];
    
    self.valueLabel = valueLabel;
    
    valueLabel.frame = CGRectMake(center.x - 50, center.y - 20, 100, 20);
    valueLabel.textColor = [UIColor whiteColor];
    valueLabel.font = [UIFont systemFontOfSize:20 weight:2];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:gradientLayer];
    
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    self.colorLayer = colorLayer;
    colorLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
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
    _valueLabel.text = valueTitle;
}

- (void)setValueFont:(UIFont *)valueFont{
    _valueLabel.font = valueFont;
}

-(void)setValueColor:(UIColor *)valueColor{
    _valueLabel.textColor = valueColor;
}

- (void)setColorArray:(NSArray *)colorArray{
    NSMutableArray *array = [NSMutableArray array];
    for (UIColor *color in colorArray) {
        [array addObject:(id)color.CGColor];
    }
    _colorLayer.colors = array.copy;
}

- (void)setLocations:(NSArray *)locations{
    _colorLayer.locations = locations;
}

- (void)setCircleColor:(UIColor *)circleColor{
    _circleLayer.strokeColor = circleColor.CGColor;
    [self.layer addSublayer:_circleLayer];
}

- (void)setMarkCount:(int)markCount{
    
    for (int i = 0; i < markCount; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        [self addSubview:label];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        CGFloat centerX = 0.0;
        CGFloat centerY = 0.0;
        CGFloat margin = 0.0;
        CGFloat half = label.frame.size.width / 2;
        CGFloat firstLCX = (_width - _radius * 2) / 2 - 5 - half;
        
        margin = i * ((_radius * 2 + 5 * 2 + half * 2) / (markCount - 1));
        centerX = firstLCX + margin;
        centerY = 0;
        
        label.center = CGPointMake(centerX, 200);
    }
}

- (NSMutableArray *)markLabelArray{
    if (!_markLabelArray) {
        _markLabelArray = [NSMutableArray array];
    }
    return _markLabelArray;
}

@end
