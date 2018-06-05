//
//  UIView+Category.h
//  pwd
//
//  Created by WEISON on 16/12/3.
//  Copyright © 2016年 siso. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TapAction)();

@interface UIView (Category)

- (void)tapHandle:(TapAction)block;
- (void)shakeView;
- (void)shakeRotation:(CGFloat)rotation;

@end
