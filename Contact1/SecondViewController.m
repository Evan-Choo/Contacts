//
//  SecondViewController.m
//  Contacts
//
//  Created by Evan Choo on 6/14/18.
//  Copyright © 2018 Evan Choo. All rights reserved.
//

#import "SecondViewController.h"
#import "DialerAddViewController.h"
#import "AddContactViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
{
    NSMutableString *display;
}
@synthesize phoneNumLable;

//process digit
-(void)processDigit:(int)digit
{
    // !!!: appendString should be used here instead of stringByAppendingString
    [display appendString:[NSString stringWithFormat:@"%i", digit]];
    
    [phoneNumLable setText:display];
}

-(IBAction)clickDigit:(UIButton *)sender
{
    int digit = (int)sender.tag;
    
    NSLog(@"%i is pressed", digit);
    
    [self processDigit: digit];
}

//click asterisk
-(IBAction)clickAsterisk:(UIButton *)sender
{
    NSLog(@"* is pressed");
    [self processChar:0];
}

//click well
-(IBAction)clickWell:(UIButton *)sender
{
    NSLog(@"# is pressed");
    [self processChar:1];
}

-(void)processChar:(int)flag
{
    switch (flag) {
        case 0:
            [display appendString:@"*"];
            [phoneNumLable setText:display];
            break;
            
        case 1:
            [display appendString:@"#"];
            [phoneNumLable setText:display];
            break;
    }
}

//TODO: implement this method
//process dial
-(IBAction)clickDial:(UIButton *)sender
{
    UIWebView *callWebView = [[UIWebView alloc]init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[phoneNumLable text]]]]];
    
    [[UIApplication sharedApplication].keyWindow addSubview:callWebView];
}

//delete digit
-(IBAction)clickDelete:(UIButton*)sender
{
    NSLog(@"-%@-", phoneNumLable.text);
    
    if([phoneNumLable.text compare:@""]!=NSOrderedSame)
    {
        NSRange range;
        range.location = display.length-1;
        range.length = 1;
        [display deleteCharactersInRange:range];
        [phoneNumLable setText:display];
    }
}

//all clear
-(IBAction)clickAllClear:(UIButton *)sender
{
    display = [NSMutableString stringWithString:@""];
    [phoneNumLable setText:display];
}

//TODO: implement this method
//save as contact
-(IBAction)clickSave:(UIButton *)sender
{
    DialerAddViewController *c = [self.storyboard instantiateViewControllerWithIdentifier:@"DialerAddContact"];
    
    c.input = self.phoneNumLable.text;
    NSLog(@"[dialerAdd] input: %@", c.input);
    
    [self presentViewController:c animated:YES completion:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    display = [NSMutableString stringWithCapacity:100];
    //NSLog(@"initialized");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
