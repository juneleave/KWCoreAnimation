//
//  KWBaseViewController.h
//  KWCoreAnimation
//
//  Created by WEISON on 18/3/15.
//  Copyright © 2018年 siso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KWBaseViewController : UIViewController
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, copy) void(^KWBaseRightButtomBlock)(NSInteger index);

@property (nonatomic, strong) NSMutableArray *rightTitles;
@end
