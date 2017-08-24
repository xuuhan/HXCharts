//
//  ViewController.m
//  HXChartsDemo
//
//  Created by 韩旭 on 2017/8/23.
//  Copyright © 2017年 韩旭. All rights reserved.
//

#import "ViewController.h"
#import "demoViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Demo列表";
    
    UITableView *tv = [[UITableView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:tv];
    
    tv.delegate = self;
    tv.dataSource = self;
}


#pragma mark UITableViewDataSource UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"仪表盘";
            break;
            
        case 1:
            cell.textLabel.text = @"圆形图";
            break;
            
        case 2:
            cell.textLabel.text = @"柱状图";
            break;
            
        case 3:
            cell.textLabel.text = @"折线图";
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    demoViewController *demo = [[demoViewController alloc] init];
    
    demo.index = indexPath.row;
    
    [self.navigationController pushViewController:demo animated:YES];

}

@end
