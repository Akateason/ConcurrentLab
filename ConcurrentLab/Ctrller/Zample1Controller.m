//
//  Zample1Controller.m
//  ConcurrentLab
//
//  Created by teason23 on 2017/5/16.
//  Copyright © 2017年 teaason. All rights reserved.
//

#import "Zample1Controller.h"
#import "Masonry.h"
#import <objc/runtime.h>
#import <objc/message.h>


@interface Zample1Controller ()
@property (nonatomic,strong) UIButton *btNormal ;

@end

@implementation Zample1Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    self.title = @"group notify" ;
    
    self.btNormal = ({
        UIButton *button = [UIButton new] ;
        [button setTitle:@"normal" forState:0] ;
        button.backgroundColor = [UIColor grayColor] ;
        button.titleLabel.textColor = [UIColor whiteColor] ;
        [button addTarget:self action:@selector(btOnClick:) forControlEvents:UIControlEventTouchUpInside] ;
        [self.view addSubview:button] ;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 40)) ;
            make.top.mas_equalTo(5) ;
            make.centerX.equalTo(self.view) ;
        }] ;
        button ;
    }) ;
}


- (void)btOnClick:(UIButton *)sender
{
    NSString *strButtonName = [sender.titleLabel.text stringByAppendingString:@"Action"] ;
    SEL methodSel = NSSelectorFromString(strButtonName) ;
    ((void (*)(id, SEL, id))objc_msgSend)(self, methodSel, nil) ;
}

- (void)normalAction
{
    dispatch_group_t group = dispatch_group_create();
    
    for (int i = 1; i <= 10; i++) {
        [self simulationReqWithName:i
                              group:group] ;
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"任务均完成，刷新界面") ;
    }) ;
}

- (void)simulationReqWithName:(int)name
                        group:(dispatch_group_t)group
{
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1) ;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",[NSString stringWithFormat:@"req%d go",name]) ;
        }) ;
    }) ;
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
