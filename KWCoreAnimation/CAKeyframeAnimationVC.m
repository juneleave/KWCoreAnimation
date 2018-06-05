//
//  CAKeyframeAnimationVC.m
//  KWCoreAnimation
//
//  Created by WEISON on 18/3/15.
//  Copyright © 2018年 siso. All rights reserved.
//

#import "CAKeyframeAnimationVC.h"
#import <WebKit/WebKit.h>

#define angle2Radian(angle)  ((angle)/180.0*M_PI)

@interface CAKeyframeAnimationVC ()<CAAnimationDelegate>
@property (nonatomic, strong) UIView *customView;
@end

@implementation CAKeyframeAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     - keyPath可以使用的key -
     #define angle2Radian(angle) ((angle)/180.0*M_PI)
     transform.rotation.x 围绕x轴翻转 参数：角度 angle2Radian(4)
     transform.rotation.y 围绕y轴翻转 参数：同上
     transform.rotation.z 围绕z轴翻转 参数：同上
     transform.rotation 默认围绕z轴
     transform.scale.x x方向缩放 参数：缩放比例 1.5
     transform.scale.y y方向缩放 参数：同上
     transform.scale.z z方向缩放 参数：同上
     transform.scale 所有方向缩放 参数：同上
     transform.translation.x x方向移动 参数：x轴上的坐标 100
     transform.translation.y x方向移动 参数：y轴上的坐标
     transform.translation.z x方向移动 参数：z轴上的坐标
     transform.translation 移动 参数：移动到的点 （100，100）
     opacity 透明度 参数：透明度 0.5
     backgroundColor 背景颜色 参数：颜色 (id)[[UIColor redColor] CGColor]
     cornerRadius 圆角 参数：圆角半径 5
     borderWidth 边框宽度 参数：边框宽度 5
     bounds 大小 参数：CGRect
     contents 内容 参数：CGImage
     contentsRect 可视内容 参数：CGRect 值是0～1之间的小数
     hidden 是否隐藏
     position 平移
     shadowColor
     shadowOffset
     shadowOpacity
     shadowRadius *
     
     */
    
    self.customView = [[UIView alloc]initWithFrame:CGRectMake(50, 100, 100, 100)];
    self.customView.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:self.customView];
    
    self.rightTitles = [NSMutableArray arrayWithArray:@[@"帧动画", @"指定路径移动", @"抖动效果"]];
    WeakSelf
    self.KWBaseRightButtomBlock = ^ (NSInteger index) {
        switch (index) {
            case 0:
                [weakSelf setAnimationForValue];
                break;
                
            case 1:
                [weakSelf setAnimationForPath];
                break;
                
            case 2:
                [weakSelf setAnimationForShake];
                break;
                
            default:
                break;
        }
    };
    
    NSString *svgPath = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"svg"];
    NSData *svgData = [NSData dataWithContentsOfFile:svgPath];
    NSString *reasourcePath = [[NSBundle mainBundle] resourcePath];
    NSURL *baseUrl = [[NSURL alloc] initFileURLWithPath:reasourcePath isDirectory:true];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [webView loadData:svgData MIMEType:@"image/svg+xml" characterEncodingName:@"UTF-8" baseURL:baseUrl];
    
    
//    NSString *svgName = @"svg名称";
//    NSString *svgPath = [[NSBundle mainBundle] pathForResource:svgName ofType:nil];
//    NSData *svgData = [NSData dataWithContentsOfFile:svgPath];
//    NSString *reasourcePath = [[NSBundle mainBundle] resourcePath];
//    NSURL *baseUrl = [[NSURL alloc] initFileURLWithPath:reasourcePath isDirectory:true];
//    UIWebView *webView = [[UIWebView alloc] init];
//    webView.frame = CGRectMake(0, 0, 100, 200);
//    [webView loadData:svgData MIMEType:@"image/svg+xml" textEncodingName:@"UTF-8" baseURL:baseUrl];
    
}


#pragma mark -通过指定点绘制动画
- (void)setAnimationForValue {
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath = @"position";
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(100, 100)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(200, 100)];
    NSValue *value3=[NSValue valueWithCGPoint:CGPointMake(200, 200)];
    NSValue *value4=[NSValue valueWithCGPoint:CGPointMake(100, 200)];
    NSValue *value5=[NSValue valueWithCGPoint:CGPointMake(100, 100)];
    keyAnima.values=@[value1,value2,value3,value4,value5];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=4.0;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [self.customView.layer addAnimation:keyAnima forKey:nil];
}


#pragma mark -通过路径设置动画
- (void)setAnimationForPath {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame  = CGRectMake(100, 300, 100, 40);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"停止动画" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath = @"position";
    //1.1告诉系统要执行什么动画
    //创建一条路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置一个圆的路径
    CGPathAddEllipseInRect(path, NULL, CGRectMake(150, 100, 100, 100));
    keyAnima.path=path;
    
    //有create就一定要有release
    CGPathRelease(path);
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=5.0;
    //1.5设置动画的节奏
    keyAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    //设置代理，开始—结束
    keyAnima.delegate=self;
    
    //2.添加核心动画
    [self.customView.layer addAnimation:keyAnima forKey:@"yuan"];
}

- (void)buttonClick {
    //停止self.customView.layer上名称标示为圆周运动的动画
    [self.customView.layer removeAnimationForKey:@"yuan"];
    NSLog(@"手动停止动画");
}


#pragma mark -设置图标抖动效果
- (void)setAnimationForShake {
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    keyAnima.keyPath = @"transform.rotation";
    //设置动画时间
    keyAnima.duration = 0.1;
    //设置图标抖动弧度
    //把度数转换为弧度  度数/180*M_PI
    keyAnima.values = @[@(-angle2Radian(4)),@(angle2Radian(4)),@(-angle2Radian(4))];
    //设置动画的重复次数(设置为最大值)
    keyAnima.repeatCount = MAXFLOAT;
    
    keyAnima.fillMode = kCAFillModeForwards;
    keyAnima.removedOnCompletion = NO;
    
    [self.customView.layer addAnimation:keyAnima forKey:nil];
}


-(void)animationDidStart:(CAAnimation *)anim {
    NSLog(@"开始动画");
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"结束动画");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
