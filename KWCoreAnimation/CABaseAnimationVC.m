//
//  CABaseAnimationVC.m
//  KWCoreAnimation
//
//  Created by WEISON on 18/3/15.
//  Copyright © 2018年 siso. All rights reserved.
//

#import "CABaseAnimationVC.h"

@interface CABaseAnimationVC ()<CAAnimationDelegate>
@property (nonatomic, strong) CALayer *myLayer;
@end

@implementation CABaseAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightTitles = [NSMutableArray arrayWithArray:@[@"平移", @"缩放", @"3d旋转", @"3d平移"]];
    
    //创建layer
    self.myLayer = [CALayer layer];
    //设置layer的属性
    self.myLayer.bounds = CGRectMake(100, 200, 100, 100);
    self.myLayer.backgroundColor = [UIColor redColor].CGColor;
    self.myLayer.position = CGPointMake(50, 50);
    self.myLayer.anchorPoint = CGPointMake(0, 0);
    self.myLayer.cornerRadius = 20;
    //添加layer
    [self.view.layer addSublayer:self.myLayer];
    
    //
    UIImageView *rotationImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"round"]];
    rotationImgView.bounds = CGRectMake(0, 0, 100, 100);
    rotationImgView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self.view addSubview:rotationImgView];
    
    
//    [self rotation:rotationImgView andDuration:10];
//    [self rotate360DegreeWithImageView:rotationImgView];
    
//    CAKeyframeAnimation *path = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    //矩形的中心就是圆心
//    CGRect rect = CGRectMake(100, 100, 1, 1);
//    path.duration = 20;
//    //绕此圆中心转
//    path.path = CFAutorelease(CGPathCreateWithEllipseInRect(rect, NULL));
//    path.calculationMode = kCAAnimationPaced;
//    path.rotationMode = kCAAnimationRotateAuto;
//    [rotationImgView.layer addAnimation:path forKey:@"round"];
    
    
    WeakSelf
    self.KWBaseRightButtomBlock = ^ (NSInteger index) {
        //1.创建核心动画
        //CABasicAnimation *anima=[CABasicAnimation animationWithKeyPath:<#(NSString *)#>]
        CABasicAnimation *anima = [CABasicAnimation animation];
   
        //1.2设置动画执行完毕之后不删除动画
        anima.removedOnCompletion = NO;
        //1.3设置保存动画的最新状态
        anima.fillMode = kCAFillModeForwards;
        
        //设置动画的代理
        anima.delegate = weakSelf;
        
        switch (index) {
            case 0:
            {
                //平移动画
                //告诉系统要执行什么样的动画
                anima.keyPath = @"position";
                //设置通过动画，将layer从哪儿移动到哪儿
                anima.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
                anima.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 300)];
            }
                break;
            case 1:
            {
                //缩放动画
                //告诉系统要执行什么样的动画
                anima.keyPath = @"bounds";
                //修改属性值,这里的位置是无效的
                anima.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 100, 100)];
              
            }
                break;
            case 2:
            {
                //旋转动画
                anima.keyPath = @"transform";
                //1.1设置动画执行时间
                anima.duration = 2.0;
                //1.2修改属性，执行动画
                //提示：如果要让图形以2D的方式旋转，只需要把CATransform3DMakeRotation在z方向上的值改为1即可。
                anima.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1, 1, 1)];
            }
                break;
            case 3:
            {
                //可以通过transform（KVC）的方式来进行设置。
                
                anima.keyPath = @"transform";
                anima.duration = 2.0;
                anima.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 100, 1)];
            }
                break;
            default:
                break;
        }
        
        //打印
        NSString *str = NSStringFromCGPoint(weakSelf.myLayer.position);
        NSLog(@"执行前的坐标：%@",str);
        
        //添加核心动画到layer
        [weakSelf.myLayer addAnimation:anima forKey:nil];
    };
    
}


-(void)animationDidStart:(CAAnimation *)anim {
    NSLog(@"开始执行动画");
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    //    如果fillMode=kCAFillModeForwards和removedOnComletion=NO，那么在动画执行完毕后，图层会保持显示动画执行后的状态。但在实质上，图层的属性值还是动画执行前的初始值，并没有真正被改变
    
    //动画执行完毕，打印执行完毕后的position值
    NSString *str = NSStringFromCGPoint(self.myLayer.position);
    NSLog(@"执行后的位置：%@",str);
    
    //添加动画给动画设置key-value对
    //[positionAnima setValue:@"PositionAnima" forKey:@"AnimationKey"];
    //根据key中不同的值来进行区分不同的动画
    //    if ([[anim valueForKey:@"AnimationKey"]isEqualToString:@"PositionAnima"]) {
    //        NSLog(@"位置移动动画执行结束");
    //    }
}

- (UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView{
    
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 0.5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = 1000;
    
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    [imageView.image drawInRect:CGRectMake(1,1,imageView.frame.size.width-2,imageView.frame.size.height-2)];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageView.layer addAnimation:animation forKey:nil];
    return imageView;
}

//旋转刷新动画
- (void)rotation:(UIView *)view andDuration:(CGFloat)duration {
    
    CABasicAnimation * rotationAnimation;
    
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    
    rotationAnimation.duration = duration;
    
    rotationAnimation.cumulative = YES;
    
    //    rotationAnimation.autoreverses = NO;
    //
    //    rotationAnimation.fillMode = kCAFillModeForwards;
    
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    
}

- (void)endRotation:(UIView *)view{
    [view.layer removeAnimationForKey:@"rotationAnimation"];
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
