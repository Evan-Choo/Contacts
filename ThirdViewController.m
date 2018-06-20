//
//  ThirdViewController.m
//  Contacts
//
//  Created by Evan Choo on 6/18/18.
//  Copyright © 2018 Evan Choo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

@synthesize yellowPageWeb = _yellowPageWeb;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *path = @"https://www.baidu.com";
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    [_yellowPageWeb loadRequest: request];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
