//
//  WaveView.m
//  WaveAnimation
//
//  Created by Dustin on 17/4/1.
//  Copyright © 2017年 PicVision. All rights reserved.
//

#import "WaveView.h"

@interface WaveView()

@property (nonatomic, strong) CADisplayLink *waveDisplaylink;
@property (nonatomic, strong) CAShapeLayer *firstWaveLayer;
@property (nonatomic, strong) CAShapeLayer *secondWaveLayer;

@end

@implementation WaveView
{
    CGFloat waveA;//第一个波浪图层的水纹振幅A
    CGFloat waveB;//第二个波浪图层的水纹振幅B
    CGFloat waveW ;//水纹周期
    CGFloat offsetXA; //第一个波浪图层的位移A
    CGFloat offsetXB;//第二个波浪图层的位移B
    CGFloat currentK; //当前波浪高度Y
    CGFloat waveSpeedA;//第一个波浪图层的水纹速度A
    CGFloat waveSpeedB;//第二个波浪图层的水纹速度B
    CGFloat waterWaveWidth; //水纹宽度
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:223/255.0 green:22/255.0 blue:64/255.0 alpha:1];
        self.layer.masksToBounds  = YES;
        [self setUp];
    }
    
    return self;
}


-(void)setUp
{
    //设置波浪的宽度
    waterWaveWidth = self.frame.size.width;
    //设置周期影响参数，2π/waveW是一个周期
    waveW = 1/30.0;
    //设置波浪纵向位置
    currentK = self.frame.size.height*0.5;//屏幕居中
    
    /*
     *初始化第一个波纹图层
     */
    _firstWaveLayer = [CAShapeLayer layer];
    //设置填充颜色
    _firstWaveLayer.fillColor = [UIColor colorWithRed:52/255.0 green:98/255.0 blue:176/255.0 alpha:1.0].CGColor;
    //添加到view的layer上
    [self.layer addSublayer:_firstWaveLayer];
    //设置波纹流动速度
    waveSpeedA = 0.3;
    //设置波纹振幅
    waveA = 10;
    //初始化偏移量影响参数，平移的单位为offsetXA/waveW,而不是offsetXA
    offsetXA = 0;
    
    
    /*
     *初始化第二个波纹图层
     */
    //初始化
    _secondWaveLayer = [CAShapeLayer layer];
    //设置填充颜色
    _secondWaveLayer.fillColor = [UIColor colorWithRed:32/255.0 green:78/255.0 blue:156/255.0 alpha:1.0].CGColor;
    //添加到view的layer上
    [self.layer addSublayer:_secondWaveLayer];
    //设置波纹流动速度
    waveSpeedB = 0.2;
    //设置波纹振幅
    waveB = 10;
    //初始化偏移量影响参数，平移的单位为offsetXB/waveW,而不是offsetXB
    offsetXB = 1;
    
    
    /*
     *启动定时器
     */
    _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    _waveDisplaylink.frameInterval = 2;//设置定时器刷新的频率
    [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];//添加到RunLoop中
}

#pragma mark 实现波纹动画
-(void)getCurrentWave:(CADisplayLink *)displayLink
{
    //实时的位移
    offsetXA += waveSpeedA;
    offsetXB += waveSpeedB;
    [self setCurrentWaveLayerPath];
}

//重新绘制波浪图层
-(void)setCurrentWaveLayerPath
{
    //创建一个路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = currentK;
    //将点移动到 x=0,y=currentK的位置
    CGPathMoveToPoint(path, nil, 0, y);
    for (NSInteger x = 0.0f; x<=waterWaveWidth; x++) {
        //正玄波浪公式
        y = waveA * sin(waveW * x+ offsetXA)+currentK;
        //将点连成线
        CGPathAddLineToPoint(path, nil, x, y);
    }
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    _firstWaveLayer.path = path;
    
    //创建一个路径
    CGMutablePathRef path1 = CGPathCreateMutable();
    
    //将点移动到 x=offsetXB/waveW=30,y=currentK的位置
    CGPathMoveToPoint(path1, nil, 0, y);
    for (NSInteger x = 0.0f; x<=waterWaveWidth; x++) {
        //正玄波浪公式
        y = waveB * sin(waveW * x+ offsetXB)+currentK;
        //将点连成线
        CGPathAddLineToPoint(path1, nil, x, y);
    }
    CGPathAddLineToPoint(path1, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path1, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path1);
    _secondWaveLayer.path = path1;
    
    CGPathRelease(path1);
}

#pragma mark 销毁定时器
-(void)dealloc
{
    [_waveDisplaylink invalidate];
}


@end
