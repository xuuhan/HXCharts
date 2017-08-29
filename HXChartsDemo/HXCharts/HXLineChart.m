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

@property (nonatomic, strong) CAShapeLayer *colorLayer;
@property (nonatomic, strong) CAShapeLayer *fillLayer;

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

@property (nonatomic, strong) NSMutableArray *markLabelArray;
@property (nonatomic, strong) NSMutableArray *lineLayerArray;
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
        [self.markLabelArray addObject:titleLabel];
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
        [self.markLabelArray addObject:valueLabel];
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
    _colorLayer = lineChartLayer;
    lineChartLayer.fillColor= [UIColor clearColor].CGColor;
    lineChartLayer.strokeColor = [UIColor blackColor].CGColor;
    lineChartLayer.lineWidth = 2;
    
    CAShapeLayer *fillChartLayer = [CAShapeLayer layer];
    _fillLayer = fillChartLayer;
    fillChartLayer.fillColor= fillChartLayer.strokeColor = [UIColor clearColor].CGColor;
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
    [self.lineLayerArray addObject:lineLayer];
    
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
    [self.lineLayerArray addObject:lineLayer];
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.lineWidth = 1.0f;
    lineLayer.strokeColor = [UIColor grayColor].CGColor;
    
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

- (void)setMarkTextFont:(UIFont *)markTextFont{
    for (UILabel *label in _markLabelArray) {
        label.font = markTextFont;
    }
}

- (void)setMarkTextColor:(UIColor *)markTextColor{
    for (UILabel *label in _markLabelArray) {
        label.textColor = markTextColor;
    }
}

- (void)setLineColor:(UIColor *)lineColor{
    _colorLayer.strokeColor = lineColor.CGColor;
}

-(void)setFillColor:(UIColor *)fillColor{
    _fillLayer.fillColor = fillColor.CGColor;
}

-(void)setBackgroundLineColor:(UIColor *)backgroundLineColor{
    for (CAShapeLayer *layer in _lineLayerArray) {
        layer.strokeColor = backgroundLineColor.CGColor;
    }
}


- (NSMutableArray *)markLabelArray{
    if (!_markLabelArray) {
        _markLabelArray = [NSMutableArray array];
    }
    return _markLabelArray;
}

- (NSMutableArray *)lineLayerArray{
    if (!_lineLayerArray) {
        _lineLayerArray = [NSMutableArray array];
    }
    return _lineLayerArray;
}


@end
