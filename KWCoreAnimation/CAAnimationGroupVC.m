//
//  CAAnimationGroupVC.m
//  KWCoreAnimation
//
//  Created by WEISON on 18/3/15.
//  Copyright © 2018年 siso. All rights reserved.
//

#import "CAAnimationGroupVC.h"

@interface CAAnimationGroupVC ()
{
    UIView *customView;
}
@end

@implementation CAAnimationGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    customView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    customView.backgroundColor = [UIColor redColor];
    [self.view addSubview:customView];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 平移动画
    CABasicAnimation *a1 = [CABasicAnimation animation];
    a1.keyPath = @"transform.translation.y";
    a1.toValue = @(100);
    // 缩放动画
    CABasicAnimation *a2 = [CABasicAnimation animation];
    a2.keyPath = @"transform.scale";
    a2.toValue = @(0.0);
    // 旋转动画
    CABasicAnimation *a3 = [CABasicAnimation animation];
    a3.keyPath = @"transform.rotation";
    a3.toValue = @(M_PI_2);
    
    // 组动画
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    
    groupAnima.animations = @[a1, a2, a3];
    
    //设置组动画的时间
    groupAnima.duration = 2;
    groupAnima.fillMode = kCAFillModeForwards;
    groupAnima.removedOnCompletion = NO;
    
    [customView.layer addAnimation:groupAnima forKey:nil];
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
