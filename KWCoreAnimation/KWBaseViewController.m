//
//  KWBaseViewController.m
//  KWCoreAnimation
//
//  Created by WEISON on 18/3/15.
//  Copyright © 2018年 siso. All rights reserved.
//

#import "KWBaseViewController.h"
#import "KWSelectView.h"

@interface KWBaseViewController ()
@property (strong, nonatomic) KWSelectView *selectView;
@end

@implementation KWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.rightButton setTitle:@"+" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightButton.frame = CGRectMake(0, 0, 30, 40);
    [self.rightButton addTarget:self action:@selector(rightButtonAction)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.selectView = [[KWSelectView alloc] initOptionView];
    self.selectView.backColor = [UIColor colorWithWhite:0 alpha:0.3];
}

- (void)rightButtonAction {
    WeakSelf
    [self defaultCell];
    self.selectView.arrow_offset = 0.9;
    self.selectView.optionType = KWSelectViewTypeArrow;
    [self.selectView showViewFromPoint:CGPointMake(SCREEN_WIDTH - 160, 64) viewWidth:150 targetView:nil direction:KWSelectViewBottom];
    //点击单行回调
    self.selectView.selectedOption = ^ (NSIndexPath *index) {
        if (weakSelf.KWBaseRightButtomBlock) {
            weakSelf.KWBaseRightButtomBlock (index.row);
        }
    };
    
    
}

- (void)defaultCell {
    [self.selectView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    __weak __typeof(&*self) weakSelf = self;
    self.selectView.cell = ^ (NSIndexPath *indexPath) {
        UITableViewCell *cell = [weakSelf.selectView dequeueReusableCellWithIdentifier:@"cell"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", weakSelf.rightTitles[indexPath.row]];
        return cell;
    };
    self.selectView.optionCellHeight = ^{
        return 40.f;
    };
    self.selectView.rowNumber = ^ (){
        return (NSInteger)weakSelf.rightTitles.count;
    };
}

//- (NSMutableArray *)rightTitles {
//    if (!_rightTitles) {
//        _rightTitles = [NSMutableArray array];
//    }
//    return _rightTitles;
//}

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
