//
//  Zample2Controller.m
//  ConcurrentLab
//
//  Created by teason23 on 2017/6/30.
//  Copyright © 2017年 teaason. All rights reserved.
//

#import "Zample2Controller.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface Zample2Controller ()

@end

@implementation Zample2Controller

- (void)viewDidLoad {
    [super viewDidLoad] ;
    // Do any additional setup after loading the view.
    
    self.title = @"semaphore" ;
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"Zample2" owner:self options:nil] firstObject] ;
    view.frame = self.view.frame ;
    self.view = view ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onclickAction:(UIButton *)sender
{
    NSString *strButtonName = sender.titleLabel.text ;
    SEL methodSel = NSSelectorFromString(strButtonName) ;
    ((void (*)(id, SEL, id))objc_msgSend)(self, methodSel, nil) ;
}


- (void)onlyOnce
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0) ;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1) ;
    NSMutableArray *array = [NSMutableArray array] ;
    
    for (int index = 0; index < 10 ; index++) {
        dispatch_async(queue, ^() {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) ;
            NSLog(@"add :%d", index) ;
            [array addObject:[NSNumber numberWithInt:index]] ;
            dispatch_semaphore_signal(semaphore) ;
        }) ;
    }
}

- (void)maxConcurrentCount
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 100; i++)
    {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, queue, ^{
            NSLog(@"%i",i);
            sleep(2);
            dispatch_semaphore_signal(semaphore);
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

- (void)demo1
{
    dispatch_semaphore_t signal = dispatch_semaphore_create(1) ;
    __block long x = 0;
    
    NSLog(@"0_x:%ld",x);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        sleep(1);
        NSLog(@"1");
        x = dispatch_semaphore_signal(signal);
        NSLog(@"1_x:%ld",x);
        
        sleep(2);
        NSLog(@"2");
        x = dispatch_semaphore_signal(signal);
        NSLog(@"2_x:%ld",x);
        
        sleep(3);
        NSLog(@"3");
        x = dispatch_semaphore_signal(signal);
        NSLog(@"3_x:%ld",x);
    });
    
    x = dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    NSLog(@"wait 1");
    NSLog(@"4_x:%ld",x);
    
    x = dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    NSLog(@"wait 2");
    NSLog(@"5_x:%ld",x);
    
    x = dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    NSLog(@"wait 3");
    NSLog(@"6_x:%ld",x);
}


- (void)demo2
{
    

}

- (void)ProductiveAndConsumption
{
    __block int product = 0 ;
    dispatch_semaphore_t sem = dispatch_semaphore_create(0) ;
    
    //消费者队列
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1) {
            long r = dispatch_semaphore_wait(sem, dispatch_time(DISPATCH_TIME_NOW, DISPATCH_TIME_FOREVER)) ;
            if (r == 0) {
            //非 0的时候,就是成功的timeout了,这里判断就是没有timeout   成功的时候是 0
                NSLog(@"消费%d产品",product);
                product--;
            };
        }
    });
    
    //生产者队列
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1) {
            sleep(1); //wait for a while
            product++;
            NSLog(@"生产%d产品",product);
            dispatch_semaphore_signal(sem);
        }
    });
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
