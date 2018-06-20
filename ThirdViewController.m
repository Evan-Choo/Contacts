//
//  ThirdViewController.m
//  Contacts
//
//  Created by Evan Choo on 6/18/18.
//  Copyright © 2018 Evan Choo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ThirdViewController.h"

@interface ThirdViewController () <UIWebViewDelegate>

@end

@implementation ThirdViewController

@synthesize yellowPageWeb = _yellowPageWeb;

- (void)updateButtons
{
    self.forwardButton.enabled = self.yellowPageWeb.canGoForward;
    self.backButton.enabled = self.yellowPageWeb.canGoBack;
    self.stopButton.enabled = self.yellowPageWeb.loading;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.yellowPageWeb.delegate = self;
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
