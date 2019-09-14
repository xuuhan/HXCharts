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

@property (nonatomic, strong) NSMutableArray *colorLayerArray;
@property (nonatomic, strong) NSMutableArray *markLabelArray;
@property (nonatomic, strong) NSMutableArray *gradientLayerArray;
@property (nonatomic, strong) NSMutableArray *singleColorLayer;

@property (nonatomic, strong) UIScrollView *scroll;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat titleWidth;
@property (nonatomic, assign) CGFloat maxChar;
@property (nonatomic, assign) int maxValue;
@property (nonatomic, assign) int valueLength;
@property (nonatomic, assign) int markLabelCount;
@property (nonatomic, assign) CGFloat barMargin;///柱子间间距

@property (nonatomic,assign) OrientationType type;
@end

@implementation HXBarChart


- (instancetype)initWithFrame:(CGRect)frame withMarkLabelCount:(int)markLabelCount withOrientationType:(OrientationType)type{
    self = [super initWithFrame:frame];
    
    if (self) {
        _markLabelCount = markLabelCount - 1;
        _gradientType = 1;
        _type = type;
        
        [self drawLine];
    }
    
    return self;
}

- (void)drawLine{
    
    CAShapeLayer *lineLayer= [CAShapeLayer layer];
    _lineLayer = lineLayer;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.lineWidth = 1.0f;
    lineLayer.strokeColor = [UIColor grayColor].CGColor;
    
    _height = self.frame.size.height;
    _width = self.frame.size.width;
    _barMargin = 20.0;
    _lineHeight = _height - 20;
    if (_type == OrientationHorizontal) {
        _x = 60;
        _y = 0;
        _lineWidth = _width - _x - 20;
    } else{
        _x = 40;
        _y = 20;
        _lineWidth = _width - _x;
    }
    
    //参照线
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    
    [linePath moveToPoint:CGPointMake(_x,_y)];
    [linePath addLineToPoint:CGPointMake(_x + _lineWidth,_y)];
    [linePath addLineToPoint:CGPointMake(_x + _lineWidth,_lineHeight)];
    [linePath addLineToPoint:CGPointMake(_x,_lineHeight)];
    [linePath addLineToPoint:CGPointMake(_x,_y)];
    if (_type == OrientationHorizontal) {
        for (int i = 1; i < _markLabelCount; i++) {
            [linePath moveToPoint:CGPointMake(_x + _lineWidth / _markLabelCount * i, 0)];
            [linePath addLineToPoint:CGPointMake(_x + _lineWidth / _markLabelCount * i,_lineHeight)];
        }
    } else{
        
        for (int i = 1; i < _markLabelCount; i++) {
            [linePath moveToPoint:CGPointMake(_x, (_lineHeight - _y) / _markLabelCount * i +_y)];
            [linePath addLineToPoint:CGPointMake(_x + _lineWidth,(_lineHeight - _y) / _markLabelCount * i + _y)];
        }
    }
    
    
    lineLayer.path = linePath.CGPath;
    [self.layer addSublayer:lineLayer];
    
}

- (void)drawChart{
    [self setScroll];
    [self setXlineColor];
    [self setTitle];
    [self setValue];
    [self setColor];
    [self setSingleColorArray];
    [self setMarkText];
}

#pragma mark set

- (void)setScroll{
    if (self.type == OrientationHorizontal) {
        _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 20)];
    } else{
        _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(_x, 0, self.width - _x, self.height)];
    }
    [self addSubview:_scroll];
    
    if (self.type == OrientationHorizontal) {
        _scroll.contentSize = CGSizeMake(0, _contentValue);
    } else{
        _scroll.contentSize = CGSizeMake(_contentValue, 0);
    }
    _scroll.contentOffset = self.contentOffset;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.showsHorizontalScrollIndicator = NO;
}

- (void)setTitle{
    
    if (_titleArray.count == 0) {
        return;
    }
    
    if (_margin > 0) {
        _barMargin = _margin;
    }
    
    if (_type == OrientationHorizontal) {
        _titleHeight = (_lineHeight - _barMargin - (_titleArray.count - 1) * _barMargin) / _titleArray.count;
        if (_barWidth > 0) {
            _titleHeight = _barWidth;
        }
        _titleWidth = _x - 10;
        
        for (int i = 0; i < _titleArray.count; i++) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_barMargin / 2 + i * (_titleHeight + _barMargin), _titleWidth, _titleHeight)];
            [self.scroll addSubview:titleLabel];
            [self.markLabelArray addObject:titleLabel];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.text = _titleArray[i];
            titleLabel.textAlignment = NSTextAlignmentRight;
        }
    } else{
        
        _titleHeight = (_lineHeight - _y - _barMargin - (_titleArray.count - 1) * _barMargin) / _titleArray.count;
        
        CGFloat labelWidth = 0;
        if (_barWidth <= 0) {
            labelWidth = _lineWidth / _titleArray.count;
        } else{
            labelWidth = _barWidth;
        }
        
        if (_margin > 0) {
            labelWidth += _margin;
        }
        
        for (int i = 0; i < _titleArray.count; i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * labelWidth,  _lineHeight + 5, labelWidth, 15)];
            
            [self.scroll addSubview:label];
            [self.markLabelArray addObject:label];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = _titleArray[i];
        }
    }
}

- (void)setValue{
    if (_valueArray.count == 0) {
        return;
    }
    
    int maxValueAtArray = [[_valueArray valueForKeyPath:@"@max.intValue"] intValue];
    
    if (maxValueAtArray == 0) {
        return;
    }
    
    [self maxValue:maxValueAtArray];
    _maxValue = _maxChar + 1;
    
    for (int i = 0; i < _valueLength - 1; i++) {
        _maxValue = _maxValue * 10;
    }
    
    CGFloat valueHeight = 0;
    CGFloat valueWidth = 0;
    CGFloat labelWidth = 0;
    CGFloat height = 15;
    
    if (_type == OrientationHorizontal) {
        
        valueHeight = (_lineHeight - _barMargin - (_valueArray.count - 1) * _barMargin) / _valueArray.count;
        
        valueWidth = _lineWidth;
        
        labelWidth = _lineWidth / _markLabelCount;
        
        if (self.barWidth > 0) {
            valueHeight = self.barWidth;
        }
        
        for (int i = 0; i < (_markLabelCount + 1); i ++) {
            if (self.barWidth > 0) {
                height = self.barWidth;
            }
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * labelWidth + _x - labelWidth / 2, _lineHeight + 5 + _y, labelWidth, height)];
            
            [self addSubview:label];
            [self.markLabelArray addObject:label];
            
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            if (i == 0) {
                label.text = @"0";
            } else if(i == _markLabelCount){
                label.text = [NSString stringWithFormat:@"%d",_maxValue];
            } else{
                if (_maxValue < _markLabelCount) {
                    label.text = [NSString stringWithFormat:@"%.1f",(float)_maxValue / _markLabelCount * i];
                } else{
                    
                    label.text = [NSString stringWithFormat:@"%d",_maxValue / _markLabelCount * i];
                }
            }
        }
    } else{
        
        valueHeight = (_lineHeight - _y) / _markLabelCount;
        
        valueWidth = _x - 10;
        labelWidth = (_lineWidth - _barMargin - ((_titleArray.count - 1) *_barMargin)) / _titleArray.count ;
        
        if (_barWidth > 0) {
            labelWidth = _barWidth;
        }
        
        
        for (int i = 0; i < (_markLabelCount + 1); i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,_lineHeight - (valueHeight / 2 + i * valueHeight), valueWidth, valueHeight)];
            
            [self addSubview:label];
            [self.markLabelArray addObject:label];
            
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            
            if (i == 0) {
                label.text = @"0";
            } else if(i == _markLabelCount){
                label.text = [NSString stringWithFormat:@"%d",_maxValue];
            } else{
                if (_maxValue < _markLabelCount) {
                    label.text = [NSString stringWithFormat:@"%.1f",(float)_maxValue / _markLabelCount * i];
                } else{
                    label.text = [NSString stringWithFormat:@"%d",_maxValue / _markLabelCount * i];
                }
            }
        }
    }
    
    for (int i = 0; i < _valueArray.count; i++) {
        //柱状图
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [self.singleColorLayer addObject:shapeLayer];
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        
        UILabel *label = [[UILabel alloc] init];
        [self.markLabelArray addObject:label];
        
        UIBezierPath *barPath = [UIBezierPath bezierPath];
        
        CGFloat drawWidth = self.bounds.size.width;
        CGFloat drawHeight = self.bounds.size.height;
        
        if (_type == OrientationHorizontal) {
            if (self.contentValue > 0) {
                drawHeight = self.contentValue;
            }
            
            if (self.barWidth > 0) {
                height = self.barWidth;
            }
            
            shapeLayer.lineWidth = height;
            
            [barPath moveToPoint:CGPointMake(_x,_barMargin / 2 + _titleHeight / 2 + i * (_barMargin + valueHeight))];
            [barPath addLineToPoint:CGPointMake(_x + valueWidth * ([_valueArray[i] floatValue] / _maxValue),_barMargin / 2 + _titleHeight / 2 + i * (_barMargin + valueHeight))];
            
            label.frame = CGRectMake(_x + valueWidth * ([_valueArray[i] floatValue] / _maxValue) + 5, _barMargin / 2 + _titleHeight / 2 + i * (_barMargin + valueHeight) - valueHeight / 2, 50, valueHeight);
            label.textAlignment = NSTextAlignmentLeft;
            
        } else{
            if (self.contentValue > 0) {
                drawWidth = self.contentValue;
            }
            
            shapeLayer.lineWidth = labelWidth;
            
            [barPath moveToPoint:CGPointMake(_barMargin / 2 + labelWidth / 2 + i * (_barMargin + labelWidth) ,_lineHeight)];
            [barPath addLineToPoint:CGPointMake(_barMargin / 2 + labelWidth / 2 + i * (_barMargin + labelWidth) ,_lineHeight - (_lineHeight - _y) * ([_valueArray[i] floatValue] / _maxValue))];
            
            label.frame = CGRectMake(_barMargin / 2 + labelWidth / 2 + i * (_barMargin + labelWidth) - 25, _lineHeight - (_lineHeight - _y) * ([_valueArray[i] floatValue] / _maxValue) - _y, 50, 20);
            label.textAlignment = NSTextAlignmentCenter;
            if (self.labelRotation) {
                label.transform = CGAffineTransformMakeRotation(self.labelRotation);
            }
        }
        
        [self.scroll addSubview:label];
        label.hidden = YES;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.text = [NSString stringWithFormat:@"%@",_valueArray[i]];
        
        shapeLayer.path= barPath.CGPath;
        [self.scroll.layer addSublayer:shapeLayer];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        [self.gradientLayerArray addObject:gradientLayer];
        gradientLayer.frame = CGRectMake(0, 0, drawWidth, drawHeight);
        gradientLayer.backgroundColor = [UIColor clearColor].CGColor;
        [self.scroll.layer addSublayer:gradientLayer];
        
        CAGradientLayer *colorLayer = [CAGradientLayer layer];
        [self.colorLayerArray addObject:colorLayer];
        colorLayer.frame = CGRectMake(0, 0, drawWidth, drawHeight);
        [gradientLayer addSublayer:colorLayer];
        
        CAShapeLayer *gressLayer = [CAShapeLayer layer];
        if (_type == OrientationHorizontal) {
            gressLayer.lineWidth = valueHeight;
        } else{
            gressLayer.lineWidth = labelWidth;
        }
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UILabel *label in self.markLabelArray) {
            label.hidden = NO;
        }
    });
}

- (void)setColor{
    if (self.colorArray.count == 0 ) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < _colorArray.count; i ++) {
        NSArray *color = _colorArray[i];
        for (UIColor *c in color) {
            [array addObject:(id)c.CGColor];
        }
        CAGradientLayer *layer = _colorLayerArray[i];
        layer.colors = array.copy;
        [array removeAllObjects];
    }
    
    [self setLocations];
}

- (void)setGradientType{
    
    for (CAGradientLayer *layer in self.colorLayerArray) {
        if (_gradientType == GradientHorizontal) {
            layer.startPoint = CGPointMake(1, 0);
            layer.endPoint = CGPointMake(0, 0);
        } else{
            layer.startPoint = CGPointMake(0, 1);
            layer.endPoint = CGPointMake(0, 0);
        }
    }
}

- (void)setLocations{
    if (_locations.count == 0) {
        return;
    }
    [self setGradientType];
    
    for (CAGradientLayer *layer in self.colorLayerArray) {
        layer.locations = _locations;
    }
}

- (void)setSingleColorArray{
    if (_singleColorArray.count == 0) {
        return;
    }
    
    for (CAGradientLayer *layer in _gradientLayerArray) {
        [layer removeFromSuperlayer];
    }
    
    for (int i = 0; i < _singleColorArray.count; i ++) {
        CAShapeLayer *layer = _singleColorLayer[i];
        UIColor *color = _singleColorArray[i];
        layer.strokeColor = color.CGColor;
        
        CABasicAnimation *ani = [ CABasicAnimation animationWithKeyPath : NSStringFromSelector ( @selector (strokeEnd))];
        ani.fromValue = @0;
        ani.toValue = @1;
        ani.duration = 1.0;
        [layer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
    }
}

- (void)setXlineColor{
    _lineLayer.strokeColor = _xlineColor.CGColor;
}

- (void)setMarkText{
    [self setMarkTextColor];
    [self setMarkTextFont];
}

- (void)setMarkTextColor{
    for (UILabel *label in self.markLabelArray) {
        label.textColor = _markTextColor;
    }
}

- (void)setMarkTextFont{
    for (UILabel *label in self.markLabelArray) {
        label.font = _markTextFont;
    }
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

- (NSMutableArray *)colorLayerArray{
    if (!_colorLayerArray) {
        _colorLayerArray = [NSMutableArray array];
    }
    return _colorLayerArray;
}


- (NSMutableArray *)markLabelArray{
    if (!_markLabelArray) {
        _markLabelArray = [NSMutableArray array];
    }
    return _markLabelArray;
}

- (NSMutableArray *)gradientLayerArray{
    if (!_gradientLayerArray) {
        _gradientLayerArray = [NSMutableArray array];
    }
    return _gradientLayerArray;
}

- (NSMutableArray *)singleColorLayer{
    if (!_singleColorLayer) {
        _singleColorLayer = [NSMutableArray array];
    }
    return _singleColorLayer;
}

@end
