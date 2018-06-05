//
//  CATransitionVC.m
//  KWCoreAnimation
//
//  Created by WEISON on 18/3/15.
//  Copyright © 2018年 siso. All rights reserved.
//

#import "CATransitionVC.h"

@interface CATransitionVC ()
{
    int index;
    int typeIndex;
    UIImageView *imgView;
    NSMutableArray *typeArray;
}
@end

@implementation CATransitionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 100, 220, 330)];
    imgView.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:imgView];
    
    index = 1;
    typeIndex = 0;

    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame  = CGRectMake(120, 400, 100, 40);
    [button1 setTitle:@"下一张" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonClick1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    
    //系统私有的切换方式，使用了，app 就不能通过审核
    /** 私有API
     *  cube 立方体翻转效果
     *  oglFlip 翻转效果
     *  suckEffect 缩放
     *  rippleEffect 水滴波纹效果
     *  pageCur 向上翻页
     *  pageUnCurl 向下翻页
     *  cameralIrisHollowOpen 摄像头打开效果
     *  cameraIrisHollowClose 摄像头关闭效果
     */
    /**
     *  公开API
     *  fade  淡出  kCATransitionFadev
     *  movein 新视图移动到旧视图上 kCATransitionMoveIn
     *  push 新视图推出旧视图 kCATransitionPush
     *  reveal 移开旧视图显示新视图 kCATransitionReveal
     */

    typeArray = [NSMutableArray arrayWithArray:@[@"kCATransitionFadev",
                                                 @"kCATransitionMoveIn",
                                                 @"kCATransitionPush",
                                                 @"kCATransitionReveal",
                                                 @"cube",
                                                 @"oglFlip",
                                                 @"suckEffect",
                                                 @"rippleEffect",
                                                 @"pageCur",
                                                 @"pageUnCurl",
                                                 @"cameralIrisHollowOpen",
                                                 @"cameraIrisHollowClose"
                                                 ]];
}

- (void)buttonClick1 {
    
    index --;
    if (index < 1) {
        index = 3;
    }
    imgView.image=[UIImage imageNamed: [NSString stringWithFormat:@"%d.jpg",index]];
    
    //创建核心动画
    CATransition *ca = [CATransition animation];
    //设置过度效果
    ca.type = typeArray[typeIndex];
    //设置动画的过度方向（向左）
    ca.subtype = kCATransitionFromLeft;
    //设置动画的时间
    ca.duration = 2.0;
    //添加动画
    [imgView.layer addAnimation:ca forKey:nil];
    
    typeIndex ++;
    if (typeIndex >= typeArray.count) {
        typeIndex = 0;
    }
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
