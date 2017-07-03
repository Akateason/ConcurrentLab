//
//  ViewController.m
//  ConcurrentLab
//
//  Created by teason23 on 2017/5/16.
//  Copyright © 2017年 teaason. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "RootTableCell.h"


@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *table ;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad] ;
    // Do any additional setup after loading the view, typically from a nib.
    self.table = ({
        UITableView *table = [UITableView new] ;
        table.frame = self.view.bounds ;
        table.delegate = self ;
        table.dataSource = self ;
        [self.view addSubview:table] ;
        table ;
    }) ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7 ; //
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RootTableCell *cell = [RootTableCell cellWithTable:tableView] ;
    cell.textLabel.text = [NSString stringWithFormat:@"Zample%ld",indexPath.row + 1] ;
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *clsName = [NSString stringWithFormat:@"Zample%dController",(int)indexPath.row + 1] ;
    Class ctrllerCls = objc_getRequiredClass([clsName UTF8String]) ;
    UIViewController *ctrller = [[ctrllerCls alloc] init] ;
    ctrller.title = clsName ;
    [self.navigationController pushViewController:ctrller animated:YES] ;
}








@end
