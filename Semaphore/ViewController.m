//
//  ViewController.m
//  Semaphore
//
//  Created by zhangxing on 2017/7/14.
//  Copyright © 2017年 zhangxing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (IBAction)click:(id)sender {
    NSLog(@"==semaphore==");
    //创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //创建全局并行
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        NSLog(@"1start");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random()%5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_semaphore_signal(semaphore);
            NSLog(@"1end");
        });
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"2start");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random()%5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_semaphore_signal(semaphore);
            NSLog(@"2end");
        });
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"3start");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random()%5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_semaphore_signal(semaphore);
            NSLog(@"3end");
        });
    });
    
    dispatch_group_notify(group, queue, ^{
        //对应任务数量
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        //所有任务完成
        NSLog(@"all end");
    });
}

- (IBAction)group:(id)sender {
    NSLog(@"==group==");
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        NSLog(@"1start");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random()%5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_group_leave(group);
            NSLog(@"1end");
        });
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        NSLog(@"2start");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random()%5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_group_leave(group);
            NSLog(@"2end");
        });
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        NSLog(@"3start");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random()%5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_group_leave(group);
            NSLog(@"3end");
        });
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //所有任务完成
        NSLog(@"all end");
    });

    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
