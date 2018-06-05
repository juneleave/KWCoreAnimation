//
//  KWSelectView.h
//  pwd
//
//  Created by WEISON on 16/12/3.
//  Copyright © 2016年 siso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Category.h"
#import "UIView+FrameChange.h"

#define KEYWINDOW [UIApplication sharedApplication].keyWindow
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define WEAK(weaks,s)  __weak __typeof(&*s)weaks = s;

typedef enum : NSUInteger {
    KWSelectViewTypeCustom,//默认风格
    KWSelectViewTypeArrow,//带箭头的下拉框
} KWSelectViewType;


///弹出方向,左右上下的区别，只有在上下或者左右都显示不下时，优先考虑的方向
typedef enum : NSUInteger {
    KWSelectViewBottom,//下
    KWSelectViewTop,//上
    KWSelectViewLeft,//左
    KWSelectViewRight//右
} KWSelectViewDirection;

typedef void(^ActionBack)(NSIndexPath*);

@interface KWSelectView : UITableView
///设置Cell
@property (nonatomic, copy) UITableViewCell*(^cell)(NSIndexPath *);
@property (nonatomic, copy) NSInteger(^rowNumber)() ;
@property (nonatomic, copy) float(^optionCellHeight)();
///单击回调
@property (nonatomic, copy) ActionBack selectedOption;
///选择样式，是否开启多选,默认NO
@property (nonatomic, assign) BOOL multiSelect;
///圆角大小,默认5
@property (nonatomic, assign) CGFloat cornerRadius;
#pragma mark - 起点偏移
///最大显示行数，默认大于5行显示5行
@property (nonatomic, assign) NSInteger maxLine;
///风格
@property (nonatomic, assign) KWSelectViewType optionType;
///背景颜色
@property (nonatomic, strong) UIColor *backColor;
///背景层颜色
@property (nonatomic, strong) UIColor *coverColor;

#pragma mark - 重要：改变箭头顶点的位置和动画开始位置，有参照物时设置，没有参照物时，不需要设置
@property (nonatomic, assign) CGFloat arrow_offset;//(0 - 1之间)

///缩放 NO 竖直或水平展开 YES
@property (nonatomic, assign) BOOL vhShow;



#pragma mark - method
///init
- (instancetype)initOptionView;

/**
 *  计算一个view相对于其父视图在window上的frame，可以通过这个rect和弹出方向，来设置弹出的point
 *
 *  @param targetView 围绕展示的view
 *
 *  @return 相对其父视图在window上的frame
 */

+ (CGRect)targetView:(UIView *)targetView;

/**
 *  弹出视图
 *
 *  @param viewPoint     弹出后视图的原点
 *  @param width         能够显示的最大宽度
 *  @param targetView    弹出视图围绕显示的view
 *  @param directionType 弹出方向，在上下或者左右都能显示时，优先选择
 */
- (void)showViewFromPoint:(CGPoint)viewPoint
                viewWidth:(CGFloat)width
               targetView:(UIView *)targetView
                direction:(KWSelectViewDirection)directionType;

/**
 *  弹出视图
 *
 *  @param tapPoint      点击的点
 *  @param width         能够显示的最大宽度
 *  @param directionType 弹出方向，在上下或者左右都能显示时，优先选择
 */
- (void)showTapPoint:(CGPoint)tapPoint
           viewWidth:(CGFloat)width
           direction:(KWSelectViewDirection)directionType;

///消失
- (void)dismiss;
@end
