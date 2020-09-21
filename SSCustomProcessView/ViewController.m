//
//  ViewController.m
//  SSCustomProcessView
//
//  Created by 梅琰培 on 7/31/19.
//  Copyright © 2019 SunshineTeemo. All rights reserved.
//

#import "ViewController.h"
#import "SSCustomProgressView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadProgressView];
    // Do any additional setup after loading the view.
}


- (void)loadProgressView
{
    SSCustomProgressView *processView = [[SSCustomProgressView alloc]initWithFrame:CGRectMake(10+18,100+ 71,kScreenWidth - (10+18)*2,70)];
    processView.growUpValueArray = @[@0,@200,@500,@1000,@3000];
    processView.growUpTitleArray = @[@"等级一",@"等级二",@"等级三",@"等级四",@"等级五"];
    processView.currentGrowUpValue = 1500;
    
    [processView drawProcessValue];
    
    [self.view addSubview:processView];
    
}

@end
