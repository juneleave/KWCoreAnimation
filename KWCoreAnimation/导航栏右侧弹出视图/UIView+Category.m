//
//  UIView+Category.m
//  pwd
//
//  Created by WEISON on 16/12/3.
//  Copyright © 2016年 siso. All rights reserved.
//

#import "UIView+Category.h"
#import <objc/runtime.h>

static char tapKey;
@implementation UIView (Category)

#pragma mark - 添加单击手势
- (void)tapHandle:(TapAction)block {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    objc_setAssociatedObject(self, &tapKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    TapAction blcok = objc_getAssociatedObject(self, &tapKey);
    if (blcok) {
        blcok();
    }
}

#pragma mark 抖动
- (void)shakeView {
    //view抖动
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    anim.repeatCount = 1;
    anim.values = @[@-4,@4,@-4,@4];
    [self.layer addAnimation:anim forKey:nil];
    
}

- (void)shakeRotation:(CGFloat)rotation {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    anim.repeatCount = 2;
    anim.duration = .2;
    anim.values = @[@0,@(rotation),@0,@(-rotation),@0];
    [self.layer addAnimation:anim forKey:nil];
}
@end
