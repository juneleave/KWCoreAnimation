//
//  KWSelectView.m
//  pwd
//
//  Created by WEISON on 16/12/3.
//  Copyright © 2016年 siso. All rights reserved.
//

#import "KWSelectView.h"

static NSInteger maxOption = 5;//默认最大5行
static CGFloat arrow_H = 8;//箭头高
static CGFloat arrow_W = 15;//箭头宽

typedef enum : NSUInteger {
    KWSelectViewEndShowTopLeft,//上左
    KWSelectViewEndShowTopRight,//上右
    
    KWSelectViewEndShowBottomLeft,//下左
    KWSelectViewEndShowBottomRight,//下右
    
    KWSelectViewEndShowLeftTop,//左上
    KWSelectViewEndShowLeftBottom,//左下
    
    KWSelectViewEndShowRightTop,//右上
    KWSelectViewEndShowRightBottom//右下
    
} KWSelectViewEndShow;

@interface KWSelectView ()<UITableViewDelegate,UITableViewDataSource>
{
    ///向下或者向上展开超出屏幕时偏移的距离
    CGFloat _start_offSetY;
    CGFloat _start_offSetX;
    //箭头的三个顶点坐标
    CGPoint arrow1;
    CGPoint arrow2;
    CGPoint arrow3;
    CAShapeLayer *arrow_layer;
    //弹出视图的origin
    CGPoint point;
    //弹出之后的宽高
    CGFloat viewHeight;
    CGFloat viewWidth;
    //弹出之后的起点
    CGPoint startPoint;
    //箭头高
    CGFloat arrowHeight;
    //显示时的行数
    CGFloat end_Line;
    //cell行高
    CGFloat cell_height;
    //是否有参照view
    UIView *_targetView;
    //是否翻转
    BOOL overturn;
}
///弹出朝向
@property (nonatomic, assign) KWSelectViewDirection diretionType;
///view
@property (nonatomic, strong) UIView *showView;
///背景层
@property (nonatomic, strong) UIView *cover;
///弹出时展示的方向
@property (nonatomic, assign) KWSelectViewEndShow endShowType;
@end
@implementation KWSelectView

#pragma mark - 初始化
- (instancetype)initOptionView {
    if (self = [super initWithFrame:CGRectZero style:UITableViewStylePlain]) {
        self.delegate = self;
        self.dataSource = self;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
//        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self initSetting];
    }
    return self;
}

#pragma mark - 默认设置
- (void)initSetting {
    _maxLine = maxOption;
    cell_height = 40.f;
    self.backColor = [UIColor whiteColor];
    _coverColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
}


- (void)setBackColor:(UIColor *)backColor {
    _backColor = backColor;
    self.backgroundColor = _backColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

#pragma mark - 计算弹出位置
+ (CGRect)targetView:(UIView *)targetView {
    CGRect rect = [KEYWINDOW convertRect:targetView.frame fromView:targetView.superview];
    return rect;
}

#pragma mark - 显示多少行
- (CGFloat)showLine {
    NSInteger row = _rowNumber?_rowNumber():0;
    NSInteger line = row > _maxLine ? _maxLine : row;
    return line;
}

#pragma mark - 弹出之前计算行数、高度等
- (void)beforeShow:(CGPoint)viewPoint
             width:(CGFloat)width
        targetView:(UIView *)targetView
         direction:(KWSelectViewDirection)directionType {
    
    _targetView = targetView;
    [self reloadData];
    
    //计算高度
    cell_height = _optionCellHeight?_optionCellHeight():cell_height;
    point = viewPoint;
    viewWidth = width;
    
    //添加视图
    [KEYWINDOW addSubview:self.cover];
    [self.showView addSubview:self];
    
    [self addConstraintToCover];
    //弹出方向和动画效果 改变
    _diretionType = directionType;
    
    //展开时为了，能够让展开视图更好的展示,可能会调整左右偏移的位置，如果弹出是围绕一块区域，就可以通过下方的数据进行适配调整上下左右展开的方式
    _start_offSetX = targetView?targetView.width:0;
    _start_offSetY = targetView?targetView.height:0;
    
    if (_optionType == KWSelectViewTypeArrow) {
        arrowHeight = arrow_H;
    } else {
        arrowHeight = 0;
    }
}


#pragma mark - 弹出的方法
- (void)showTapPoint:(CGPoint)tapPoint
           viewWidth:(CGFloat)width
           direction:(KWSelectViewDirection)directionType {
    //显示行数
    NSInteger line = [self showLine];
    if (line == 0) {
        return;
    }
    viewHeight = line * cell_height;
    [self beforeShow:CGPointZero width:width targetView:nil direction:directionType];
    point = tapPoint;
    overturn = NO;
    //调节显示
    switch (_diretionType) {
        case KWSelectViewBottom:
        case KWSelectViewTop: {
            if (point.x < width/2) {
                _arrow_offset = point.x / width;
            } else if (point.x > width/2 && point.x < (SCREEN_WIDTH - width/2)) {
                _arrow_offset = .5;
            } else {
                _arrow_offset = (1 - (SCREEN_WIDTH - point.x) / width);
            }
            
            if ((SCREEN_HEIGHT-point.y-arrowHeight) > viewHeight || SCREEN_HEIGHT/2 > point.y) {
                end_Line = (SCREEN_HEIGHT-point.y-arrowHeight)/cell_height;
                end_Line = end_Line>line?line:end_Line;
                viewHeight = end_Line * cell_height;
                
                _diretionType = KWSelectViewBottom;
                startPoint = CGPointMake(point.x - viewWidth * _arrow_offset, point.y + arrowHeight);
                self.showView.layer.anchorPoint = CGPointMake(_arrow_offset, 0);
            } else {
                end_Line = (point.y-arrowHeight)/cell_height;
                end_Line = end_Line>line?line:end_Line;
                viewHeight = end_Line * cell_height;
                
                _diretionType = KWSelectViewTop;
                startPoint = CGPointMake(point.x - viewWidth * _arrow_offset, point.y - arrowHeight - viewHeight);
                self.showView.layer.anchorPoint = CGPointMake(_arrow_offset, 1);
            }
        }
            break;
        case KWSelectViewLeft:
        case KWSelectViewRight: {
            
            if ((SCREEN_HEIGHT -point.y)>viewHeight || point.y<SCREEN_HEIGHT/2) {
                end_Line = (SCREEN_HEIGHT - point.y)/cell_height;
            } else {
                end_Line = point.y/cell_height;
            }
            end_Line = end_Line>line?line:end_Line;
            viewHeight = end_Line * cell_height;
            
            if (point.y < viewHeight/2) {
                _arrow_offset = point.y / viewHeight;
            } else if (point.y > viewHeight/2 && point.y < (SCREEN_HEIGHT - viewHeight/2)) {
                _arrow_offset = .5;
            } else {
                _arrow_offset = (1 - (SCREEN_HEIGHT - point.y) / viewHeight);
            }
            if ((point.x-arrowHeight) >viewWidth || point.x > SCREEN_WIDTH/2) {//左
                viewWidth = viewWidth < (point.x-arrowHeight) ? viewWidth : (point.x-arrowHeight);
                _diretionType = KWSelectViewLeft;
                startPoint = CGPointMake(tapPoint.x - arrowHeight - viewWidth, tapPoint.y - viewHeight * _arrow_offset);
                self.showView.layer.anchorPoint = CGPointMake(1, _arrow_offset);
            } else {
                viewWidth = viewWidth > (SCREEN_WIDTH - point.x-arrowHeight)?(SCREEN_WIDTH - point.x-arrowHeight):viewWidth;
                _diretionType = KWSelectViewRight;
                startPoint = CGPointMake(tapPoint.x + arrowHeight, tapPoint.y - viewHeight * _arrow_offset);
                self.showView.layer.anchorPoint = CGPointMake(0, _arrow_offset);
            }
        }
            break;
        default:
            break;
    }
    [self showAndDraw];
}

#pragma mark - 弹出的方法
- (void)showViewFromPoint:(CGPoint)viewPoint
                viewWidth:(CGFloat)width
               targetView:(UIView *)targetView
                direction:(KWSelectViewDirection)directionType {
    //显示行数
    NSInteger line = [self showLine];
    if (line == 0) {
        return;
    }
    viewHeight = line * cell_height;
    [self beforeShow:viewPoint width:width targetView:targetView direction:directionType];
    
    //调节显示,确定是否翻转和翻转后的展示方向
    switch (_diretionType) {
        case KWSelectViewBottom: {
            if ((SCREEN_HEIGHT-point.y-arrowHeight) > viewHeight || (SCREEN_HEIGHT-_start_offSetY)/2 > point.y) {
                overturn = NO;
                self.diretionType = KWSelectViewBottom;
            } else {
                overturn = YES;
                self.diretionType = KWSelectViewTop;
            }
        }
            break;
        case KWSelectViewTop: {
            if ((point.y-arrowHeight) > viewHeight || point.y > (SCREEN_HEIGHT-_start_offSetY)/2) {
                overturn = NO;
                self.diretionType = KWSelectViewTop;
            } else {
                overturn = YES;
                self.diretionType = KWSelectViewBottom;
            }
        }
            break;
        case KWSelectViewLeft: {
            if ((point.x-arrowHeight) >viewWidth || point.x > (SCREEN_WIDTH - _start_offSetX)/2) {//左
                overturn = NO;
                self.diretionType = KWSelectViewLeft;
            } else {
                overturn = YES;
                self.diretionType = KWSelectViewRight;
            }
        }
            break;
        case KWSelectViewRight: {
            if ((SCREEN_WIDTH-point.x-arrowHeight)>viewWidth || point.x < (SCREEN_WIDTH - _start_offSetX)/2) {
                overturn = NO;
                self.diretionType = KWSelectViewRight;
            } else {
                overturn = YES;
                self.diretionType = KWSelectViewLeft;
            }
        }
            break;
        default:
            break;
    }
    [self showAndDraw];
}

#pragma mark - 计算后的展示方向
- (void)setDiretionType:(KWSelectViewDirection)diretionType {
    _diretionType = diretionType;
    NSInteger line = [self showLine];
    switch (diretionType) {
        case KWSelectViewBottom: {
            //是否需要翻转
            if (overturn) {
                _start_offSetY = _targetView.height;
            } else {
                _start_offSetY = 0;
            }
            
            end_Line = (SCREEN_HEIGHT - point.y -_start_offSetY-arrowHeight)/cell_height;
            end_Line = end_Line>line?line:end_Line;
            viewHeight = end_Line * cell_height;
            
            if ((SCREEN_WIDTH-point.x)>viewWidth || point.x < (SCREEN_WIDTH - _start_offSetX)/2) {
                
                self.endShowType = KWSelectViewEndShowBottomRight;
                viewWidth = (SCREEN_WIDTH-point.x)>viewWidth?viewWidth:(SCREEN_WIDTH-point.x);
                startPoint = CGPointMake(point.x, point.y+_start_offSetY+arrowHeight);
            } else {
                self.endShowType = KWSelectViewEndShowBottomLeft;
                
                _arrow_offset = 1-_arrow_offset;
                viewWidth = (point.x+_start_offSetX)>viewWidth?viewWidth : point.x+_start_offSetX;
                
                startPoint = CGPointMake(point.x+_start_offSetX - viewWidth, point.y+_start_offSetY+arrowHeight);
            }
            self.showView.layer.anchorPoint = CGPointMake(_arrow_offset,0);
            
        }
            break;
        case KWSelectViewTop: {
            if (overturn) {
                _start_offSetY = _targetView.height;
            } else {
                _start_offSetY = 0;
            }
            end_Line = (point.y-_start_offSetY-arrowHeight)/cell_height;
            end_Line = end_Line>line?line:end_Line;
            viewHeight = end_Line * cell_height;
            
            if ((SCREEN_WIDTH-point.x)>viewWidth || point.x < (SCREEN_WIDTH - _start_offSetX)/2) {
                self.endShowType = KWSelectViewEndShowTopRight;
                viewWidth = (SCREEN_WIDTH-point.x)>viewWidth?viewWidth:(SCREEN_WIDTH-point.x);
                startPoint = CGPointMake(point.x, point.y-_start_offSetY-viewHeight-arrowHeight);
            } else {
                self.endShowType = KWSelectViewEndShowTopLeft;
                _arrow_offset = 1-_arrow_offset;
                viewWidth = (point.x+_start_offSetX)>viewWidth?viewWidth : point.x+_start_offSetX;
                startPoint = CGPointMake(point.x+_start_offSetX-viewWidth, point.y-_start_offSetY-viewHeight-arrowHeight);
            }
            self.showView.layer.anchorPoint = CGPointMake(_arrow_offset, 1);
            
        }
            break;
        case KWSelectViewLeft: {
            if (overturn) {
                _start_offSetX = _targetView.width;
            } else {
                _start_offSetX = 0;
            }
            viewWidth = viewWidth < (point.x-_start_offSetX-arrowHeight) ? viewWidth : (point.x-_start_offSetX-arrowHeight);
            if ((SCREEN_HEIGHT -point.y)>viewHeight || point.y<(SCREEN_HEIGHT -_start_offSetY)/2) {
                self.endShowType = KWSelectViewEndShowLeftBottom;
                end_Line = (SCREEN_HEIGHT - point.y)/cell_height;
                end_Line = end_Line>line?line:end_Line;
                viewHeight = end_Line * cell_height;
                
                startPoint = CGPointMake(point.x - _start_offSetX -viewWidth-arrowHeight, point.y);
            } else {
                self.endShowType = KWSelectViewEndShowLeftTop;
                _arrow_offset = 1-_arrow_offset;
                end_Line = point.y/cell_height;
                end_Line = end_Line>line?line:end_Line;
                viewHeight = end_Line * cell_height;
                
                startPoint = CGPointMake(point.x - _start_offSetX - viewWidth-arrowHeight, point.y+_start_offSetY-viewHeight);
            }
            self.showView.layer.anchorPoint = CGPointMake(1, _arrow_offset);
        }
            break;
        case KWSelectViewRight: {
            if (overturn) {
                _start_offSetX = _targetView.width;
            } else {
                _start_offSetX = 0;
            }
            viewWidth = viewWidth > (SCREEN_WIDTH - point.x-_start_offSetX-arrowHeight)?(SCREEN_WIDTH - point.x-arrowHeight):viewWidth;
            if ((SCREEN_HEIGHT -point.y)>viewHeight || point.y<(SCREEN_HEIGHT -_start_offSetY)/2) {
                self.endShowType = KWSelectViewEndShowRightBottom;
                end_Line = (SCREEN_HEIGHT - point.y)/cell_height;
                end_Line = end_Line>line?line:end_Line;
                viewHeight = end_Line * cell_height;
                
                startPoint = CGPointMake(point.x + _start_offSetX+arrowHeight, point.y);
            } else {
                self.endShowType = KWSelectViewEndShowRightTop;
                _arrow_offset = 1-_arrow_offset;
                end_Line = point.y/cell_height;
                end_Line = end_Line>line?line:end_Line;
                viewHeight = end_Line * cell_height;
                
                startPoint = CGPointMake(point.x + _start_offSetX+arrowHeight, point.y+_start_offSetY-viewHeight);
            }
            self.showView.layer.anchorPoint = CGPointMake(0, _arrow_offset);
        }
            break;
        default:
            break;
    }
}

#pragma mark - showAndDraw
- (void)showAndDraw {
    //startPoint计算是以self为准，此处变换为backView
    CGRect showFrame;
    switch (_diretionType) {
        case KWSelectViewTop: {
            showFrame = CGRectMake(startPoint.x, startPoint.y, viewWidth, viewHeight + arrowHeight);
            self.origin = CGPointZero;
        }
            break;
        case KWSelectViewBottom: {
            showFrame = CGRectMake(startPoint.x, startPoint.y - arrowHeight, viewWidth, viewHeight + arrowHeight);
            self.origin = CGPointMake(0, arrowHeight);
        }
            break;
        case KWSelectViewLeft: {
            showFrame = CGRectMake(startPoint.x, startPoint.y, viewWidth + arrowHeight, viewHeight);
            self.origin = CGPointZero;
        }
            break;
        case KWSelectViewRight: {
            showFrame = CGRectMake(startPoint.x - arrowHeight, startPoint.y, viewWidth + arrowHeight, viewHeight);
            self.origin = CGPointMake(arrowHeight, 0);
        }
            break;
        default:
            break;
    }
    self.showView.frame = showFrame;
    [KEYWINDOW addSubview:self.showView];
    
    self.size = CGSizeMake(viewWidth, viewHeight);
    
    if (_optionType == KWSelectViewTypeArrow) {
        [self drowArrow];
    } else {
        if (arrow_layer) {
            [arrow_layer removeFromSuperlayer];
            arrow_layer = nil;
        }
    }
    [self animation_show];
}



#pragma mark - showView
- (UIView *)showView {
    if (!_showView) {
        _showView = [[UIView alloc] init];
        _showView.backgroundColor = [UIColor clearColor];
    }
    return _showView;
}
#pragma mark - 画箭头
- (void)drowArrow {
    //根据锚点的位置画箭头
    switch (_diretionType) {
        case KWSelectViewBottom: {
            arrow1 = CGPointMake(self.x+self.width*_arrow_offset , self.y-arrow_H);
            arrow2 = CGPointMake(self.x+self.width*_arrow_offset + (arrow_W/2 > self.width*(1-_arrow_offset)?0:arrow_W/2), self.y);
            arrow3 = CGPointMake(self.x+self.width*_arrow_offset - (arrow_W/2 > self.width*_arrow_offset?0:arrow_W/2), self.y);
        }
            break;
        case KWSelectViewTop: {
            arrow1 = CGPointMake(self.x+self.width*_arrow_offset , self.y+self.height+arrow_H);
            arrow2 = CGPointMake(self.x+self.width*_arrow_offset + (arrow_W/2 > self.width*(1-_arrow_offset)?0:arrow_W/2), self.y + self.height);
            arrow3 = CGPointMake(self.x+self.width*_arrow_offset - (arrow_W/2 > self.width*_arrow_offset?0:arrow_W/2), self.y + self.height);
        }
            break;
        case KWSelectViewLeft: {
            arrow1 = CGPointMake(self.x+self.width+arrow_H, self.y+self.height*_arrow_offset);
            arrow2 = CGPointMake(self.x+self.width, self.y+self.height*_arrow_offset + (arrow_W/2 > self.height*(1-_arrow_offset)?0:arrow_W/2));
            arrow3 = CGPointMake(self.x+self.width, self.y+self.height*_arrow_offset - (arrow_W/2 > self.height*_arrow_offset?0:arrow_W/2));
        }
            break;
        case KWSelectViewRight: {
            arrow1 = CGPointMake(self.x-arrow_H, self.y+self.height*_arrow_offset);
            arrow2 = CGPointMake(self.x, self.y+self.height*_arrow_offset + (arrow_W/2 > self.height*(1-_arrow_offset)?0:arrow_W/2));
            arrow3 = CGPointMake(self.x, self.y+self.height*_arrow_offset - (arrow_W/2 > self.height*_arrow_offset?0:arrow_W/2));
        }
            break;
        default:
            break;
    }
    if (!arrow_layer) {
        arrow_layer = [[CAShapeLayer alloc] init];
        arrow_layer.fillColor = _backColor.CGColor;
        [self.showView.layer addSublayer:arrow_layer];
    }
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:arrow1];
    [arrowPath addLineToPoint:arrow2];
    [arrowPath addLineToPoint:arrow3];
    [arrowPath closePath];
    arrow_layer.path = arrowPath.CGPath;
}

#pragma mark - 动画
- (void)animation_show {
    [self zoomOrOn];
    [UIView animateWithDuration:.3 animations:^{
        self.cover.alpha = .3;
        self.showView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}


- (void)dismiss {
    [UIView animateWithDuration:.3 animations:^{
        [self zoomOrOn];
        self.cover.alpha = 0;
    } completion:^(BOOL finished) {
        self.showView.transform= CGAffineTransformIdentity;
        [self.showView removeFromSuperview];
        [self.cover removeFromSuperview];
    }];
}

#pragma mark - 是缩放或者展开
- (void)zoomOrOn {
    if (_vhShow) {
        if (_diretionType == KWSelectViewBottom || _diretionType==KWSelectViewTop) {
            self.showView.transform = CGAffineTransformMakeScale(1, 0.001);
        } else {
            self.showView.transform = CGAffineTransformMakeScale(0.001, 1);
        }
    } else {
        self.showView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    }
}

#pragma mark - cover
- (void)setCoverColor:(UIColor *)coverColor {
    _coverColor = coverColor;
    self.cover.backgroundColor = _coverColor;
}

- (void)addConstraintToCover {
    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:_cover attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:KEYWINDOW attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:_cover attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:KEYWINDOW attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:_cover attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:KEYWINDOW attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:_cover attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:KEYWINDOW attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    [KEYWINDOW addConstraints:@[leftConstraint, rightConstraint, topConstraint, bottomConstraint]];
}

- (UIView *)cover {
    if (!_cover) {
        _cover = [[UIView alloc] initWithFrame:KEYWINDOW.bounds];
        _cover.backgroundColor = _coverColor;
        _cover.alpha = 0;
        _cover.translatesAutoresizingMaskIntoConstraints = NO;
        __weak typeof(self) weakself = self;
        [_cover tapHandle:^{
            [weakself dismiss];
        }];
    }
    return _cover;
}

#pragma mark - table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rowNumber?_rowNumber():0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_cell) {
        UITableViewCell *cell = _cell(indexPath);
        cell.contentView.backgroundColor = _backColor;
        cell.backgroundColor = _backColor;
        cell.selectionStyle = 0;
        cell.preservesSuperviewLayoutMargins = NO;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
        return cell;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _optionCellHeight?_optionCellHeight():cell_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedOption) {
        self.selectedOption(indexPath);
    }
    if (!_multiSelect) {
        [self dismiss];
    }
}


@end
