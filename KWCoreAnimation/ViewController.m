//
//  ViewController.m
//  KWCoreAnimation
//
//  Created by WEISON on 18/3/14.
//  Copyright © 2018年 siso. All rights reserved.
//

#import "ViewController.h"
#import "CABaseAnimationVC.h"
#import "CAKeyframeAnimationVC.h"
#import "CAAnimationGroupVC.h"
#import "CATransitionVC.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray = [NSMutableArray arrayWithArray:@[@"CABaseAnimation", @"CAKeyframeAnimation", @"CAAnimationGroupVC", @"CATransition"]];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"celltest"];
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"celltest"];
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[CABaseAnimationVC new] animated:YES];
        
    }else if (indexPath.row == 1) {
        [self.navigationController pushViewController:[CAKeyframeAnimationVC new] animated:YES];
        
    }else if (indexPath.row == 2) {
        [self.navigationController pushViewController:[CAAnimationGroupVC new] animated:YES];
    }else if (indexPath.row == 3) {
        [self.navigationController pushViewController:[CATransitionVC new] animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
