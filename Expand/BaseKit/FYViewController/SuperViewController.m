//
//  SuperViewController.m
//  Project
//
//  Created by fy on 2018/12/28.
//  Copyright © 2018 CDJay. All rights reserved.
//

#import "SuperViewController.h"

@interface SuperViewController ()

@end

@implementation SuperViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = BaseColor;
}

- (void)removeAndBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
