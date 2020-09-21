//
//  MemberGradeCenterGrowUpProgressView.m
//  Business
//
//  Created by SunshineTeemo on 7/29/19.
//  Copyright © 2019 prince. All rights reserved.
//

#import "SSCustomProgressView.h"


#import "Masonry.h"
#define HKColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]




@interface SSCustomProgressView ()

//进度条的红色部分
@property(nonatomic,strong) CAShapeLayer *redLayer;
//粉色部分
@property(nonatomic,strong) CAShapeLayer *pinkLayer;
//黄色底色
@property(nonatomic,strong) CAShapeLayer *yellowLayer;





/**
 图标所占大小 这部分是不计入成长值比例计算的
 */
@property(nonatomic,assign) NSInteger iconPlaceHolderPT;


/**
 每个平行四边形的宽度
 */
@property(nonatomic,assign) NSInteger singleSquareWidth;


/**
 每个平行四边形的高度
 */
@property(nonatomic,assign) NSInteger singleSquareHeight;


/**
 每个平行四边形的偏移量 上边比下边的
 */
@property(nonatomic,assign) NSInteger singleSquareOffset;


/**
 成长值所在的等级数
 */
@property(nonatomic,assign) NSInteger index;

/**
 进度条总长度
 */
@property(nonatomic,assign) CGFloat lineWidth;

/**
 被图标分割开的各个进度条的宽度
 */
@property(nonatomic,assign) CGFloat singleLineWidth;
//进度条宽度
@property(nonatomic,assign) CGFloat processLayerWidth;

//本地图标数组
@property(nonatomic,copy) NSArray *iconArray;

// 标志进度到哪的图标
@property(nonatomic,strong) UIImageView *locationImageView;


@property(nonatomic,assign) CGFloat layerTop;
@property(nonatomic,assign) CGFloat layerLeft;


@end
@implementation SSCustomProgressView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        
//        self.backgroundColor = HKColor(255, 237, 209, 1);
        self.iconPlaceHolderPT = 40;

        self.lineWidth = frame.size.width - _iconPlaceHolderPT;
        


        
    }
    return self;
}



- (void)drawProcessValue
{
    [self loadGrowUpValue];
    
    [self loadProcessLayer];
    [self loadIconImageView];
    [self loadLocationImageView];
}

- (void)loadGrowUpValue
{
    
    self.iconArray = @[@"IconImage",@"IconImage",@"IconImage",@"IconImage",@"IconImage"];
    self.singleSquareWidth = 8;
    self.singleSquareOffset = 6;
    self.singleSquareHeight = 6;

    self.layerTop = _iconPlaceHolderPT/2 - _singleSquareHeight/2;
    self.layerLeft = _iconPlaceHolderPT/2;

    
    
    self.singleLineWidth = (_lineWidth - self.iconPlaceHolderPT*(self.growUpValueArray.count -1))/(self.growUpValueArray.count -1);
    
    
    if (self.currentGrowUpValue == [[self.growUpValueArray firstObject] integerValue]) {
        self.index = 0;
        return;
    }
    for (NSInteger i = 0;i<self.growUpValueArray.count ; i++) {
        NSInteger indexValue = [self.growUpValueArray[i] integerValue];
        
        
        if (self.currentGrowUpValue >= indexValue) {
            self.index = i;
        }else{
            return;
        }
        
        
    }
    
    
    
}
- (void)loadLocationImageView
{
    [self addSubview:self.locationImageView];
    
    [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10.5, 13.5));
        make.bottom.offset(-(70+4));
        make.left.offset(self.processLayerWidth - 8/2 + self.layerLeft);
    }];
}
- (void)loadProcessLayer
{

    
    [self loadProgresslayer];
    
}

- (void)loadIconImageView
{
    for (int i = 0; i < self.growUpValueArray.count ; i++) {
        UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString *iconString = _iconArray[i];
        [iconButton setBackgroundImage:[UIImage imageNamed:iconString] forState:UIControlStateNormal];
        [iconButton setBackgroundImage:[UIImage imageNamed:iconString] forState:UIControlStateSelected];
        iconButton.frame = CGRectMake(self.singleLineWidth*i + self.iconPlaceHolderPT*i,0, _iconPlaceHolderPT, _iconPlaceHolderPT);
        [iconButton addTarget:self action:@selector(iconTapSelector:) forControlEvents:UIControlEventTouchUpInside];
        iconButton.tag = 21000 +i;
        [self addSubview:iconButton];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = self.growUpTitleArray[i];
        titleLabel.textColor = HKColor(138, 143, 150, 1);
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(iconButton.mas_centerX).offset(0);
            make.width.mas_equalTo(50);
            make.top.equalTo(iconButton.mas_bottom).offset(0);
        }];
        
        UILabel *valueLabel = [[UILabel alloc]init];
        valueLabel.text = [NSString stringWithFormat:@"%@",self.growUpValueArray[i]] ;
        valueLabel.textColor = HKColor(252, 85, 108, 1);
        valueLabel.font = [UIFont systemFontOfSize:12];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:valueLabel];
        
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(iconButton.mas_centerX).offset(0);
            make.width.mas_equalTo(80);
            make.top.equalTo(titleLabel.mas_bottom).offset(0);
        }];

        
    }
}

- (void)loadProgresslayer
{
    
    [self.layer addSublayer:self.yellowLayer];
    
    
//    return;
    
    
    
    [self.layer addSublayer:self.redLayer];
    [self.layer addSublayer:self.pinkLayer];
    
    
    
    UIBezierPath *redPath = [UIBezierPath bezierPath];
    UIBezierPath *pinkPath = [UIBezierPath bezierPath];

    
    if (self.index == self.growUpValueArray.count - 1) {
        
        self.processLayerWidth = _lineWidth;
    }else if (self.currentGrowUpValue == [[self.growUpValueArray firstObject] integerValue])
    {
        self.processLayerWidth = 0;
        
        return;
    }
    else{
        
        CGFloat lastScale = (CGFloat)(self.currentGrowUpValue - [self.growUpValueArray[self.index] integerValue])/(CGFloat)([self.growUpValueArray[self.index+1] integerValue]- [self.growUpValueArray[self.index] integerValue]);
        self.processLayerWidth = (self.singleLineWidth + self.iconPlaceHolderPT)*self.index + self.singleLineWidth*lastScale+self.iconPlaceHolderPT/2 - (lastScale == 0? self.iconPlaceHolderPT/2:0);
    }

    
    NSInteger singleCount = _processLayerWidth/self.singleSquareWidth;
    
    for (NSInteger i = 0; i < singleCount; i++) {
        
        if (i == 0) {
            [redPath moveToPoint:CGPointMake(_layerLeft, _singleSquareHeight+_layerTop)];
            [redPath addLineToPoint:CGPointMake(_layerLeft,_layerTop)];
            [redPath addLineToPoint:CGPointMake(_layerLeft+_singleSquareOffset, _layerTop)];
            [redPath addLineToPoint:CGPointMake(_layerLeft, _singleSquareHeight+_layerTop)];
            [redPath addArcWithCenter:CGPointMake(_layerLeft, _singleSquareHeight/2+_layerTop) radius:_singleSquareHeight/2 startAngle:M_PI_2 endAngle:M_PI_2*3 clockwise:YES];

            
        }else{
            
            UIBezierPath *path = redPath;
            
            if (i%2 != 0) {
                path = pinkPath;
            }else{
                path = redPath;

            }
            [path moveToPoint:CGPointMake(_layerLeft+_singleSquareWidth*(i-1), _singleSquareHeight+_layerTop)];
            [path addLineToPoint:CGPointMake(_layerLeft+_singleSquareOffset+_singleSquareWidth*(i-1), _layerTop)];
            [path addLineToPoint:CGPointMake(_layerLeft+_singleSquareOffset+_singleSquareWidth*(i-1)+_singleSquareWidth,+_layerTop)];
            [path addLineToPoint:CGPointMake(_layerLeft+_singleSquareWidth+_singleSquareWidth*(i-1),_singleSquareHeight+_layerTop)];
            [path addLineToPoint:CGPointMake(_layerLeft+_singleSquareWidth*(i-1), _singleSquareHeight+_layerTop)];
            
        }
        
        
        
        
    }
    
    UIBezierPath *path = redPath;
    
    if (singleCount%2 != 0) {
        path = pinkPath;
    }else{
        path = redPath;
        
    }
    
    [path moveToPoint:CGPointMake(_layerLeft+(singleCount-1)*self.singleSquareWidth + self.singleSquareOffset, +_layerTop)];
    [path addLineToPoint:CGPointMake(_layerLeft+_processLayerWidth, +_layerTop)];
    [path addArcWithCenter:CGPointMake(_layerLeft+_processLayerWidth, _singleSquareHeight/2+_layerTop) radius:_singleSquareHeight/2 startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:YES];
    
    [path addLineToPoint:CGPointMake(_layerLeft+(singleCount-1)*self.singleSquareWidth, _singleSquareHeight+_layerTop)];
    

    self.redLayer.path = redPath.CGPath;
    self.pinkLayer.path = pinkPath.CGPath;
    

}

- (void)loadPinkLayer
{
    
    [self.layer addSublayer:self.pinkLayer];

}


- (void)iconTapSelector:(UIButton *)button
{
    if (self.selectedBlock) {
        self.selectedBlock(button.tag - 21000,button.frame.origin.x + _iconPlaceHolderPT/2 + _iconPlaceHolderPT);
    }
}


#pragma mark - lazy loading

- (UIImageView *)locationImageView
{
    if (!_locationImageView) {
        _locationImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Location"]];
        
    }
    return _locationImageView;
}

- (CAShapeLayer *)redLayer
{
    if (!_redLayer) {
        _redLayer = [CAShapeLayer layer];
        _redLayer.fillColor = HKColor(252, 85, 108, 1).CGColor;
        _redLayer.strokeColor = HKColor(255, 153, 167, 1).CGColor;

        _redLayer.lineWidth = 1;
        
    }
    return _redLayer;
}

- (CAShapeLayer *)pinkLayer
{
    if (!_pinkLayer) {
        _pinkLayer = [CAShapeLayer layer];
        _pinkLayer.fillColor = HKColor(255, 153, 167, 1).CGColor;
        _pinkLayer.strokeColor = HKColor(255, 153, 167, 1).CGColor;
        _pinkLayer.lineWidth = 1;


    }
    return _pinkLayer;
}

- (CAShapeLayer *)yellowLayer
{
    if (!_yellowLayer) {
        _yellowLayer = [CAShapeLayer layer];
//        _yellowLayer.fillColor = HKColor(255, 237, 209, 1).CGColor;
        _yellowLayer.strokeColor = HKColor(255, 237, 209, 1).CGColor;

        _yellowLayer.lineWidth = 6;
        
        
        UIBezierPath *yellowPath = [UIBezierPath bezierPath];
        
        [yellowPath moveToPoint:CGPointMake(_iconPlaceHolderPT/2, _iconPlaceHolderPT/2)];
        
        [yellowPath addLineToPoint:CGPointMake(_lineWidth+_iconPlaceHolderPT/2, _iconPlaceHolderPT/2)];
        
        _yellowLayer.path = yellowPath.CGPath;
    }
    
    
    return _yellowLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
