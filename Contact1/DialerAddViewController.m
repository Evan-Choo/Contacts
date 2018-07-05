//
//  DialerAddViewController.m
//  Contact1
//
//  Created by Evan Choo on 6/29/18.
//  Copyright © 2018 Evan Choo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DialerAddViewController.h"
#import "Database.h"

@interface DialerAddViewController()
{
    
}
@end

@implementation DialerAddViewController

@synthesize input;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.numText setText:input];
    [self.avatar setImage:[UIImage imageNamed:@"male80.png"]];
    
    [self.genderSeg addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    self.fnameText.delegate = self;
    self.lnameText.delegate = self;
    self.numText.delegate = self;
    self.addrText.delegate = self;
}

-(IBAction)clickCancle:(id)sender
{

    NSLog(@"[dialerAddView] click cancle");
    [self.presentingViewController dismissViewControllerAnimated: YES completion:nil];
}

-(IBAction)clickSave:(id)sender
{
    NSLog(@"click save");
    
    int count = [[Database defaultDb]getCount:nil];
    Boolean isSuccessful = NO;
    
    NSString *columnValue = [NSString string];
    
    columnValue = [columnValue stringByAppendingString:[NSString stringWithFormat:@"%i, ", count]];
    
    //textfiled为空
    if([self.fnameText.text compare:@""]==NSOrderedSame)
    {
        columnValue = [columnValue stringByAppendingString:@"null, "];
    }
    else
    {
        columnValue = [columnValue stringByAppendingString:[NSString stringWithFormat:@"'%@', ", self.fnameText.text]];
    }
    
    //textfield为空
    if([self.lnameText.text compare:@""]==NSOrderedSame)
    {
        columnValue = [columnValue stringByAppendingString:@"null, "];
    }
    else
    {
        columnValue = [columnValue stringByAppendingString:[NSString stringWithFormat:@"'%@', ", self.lnameText.text]];
    }
    
    //textfield为空
    if([self.numText.text compare:@""]==NSOrderedSame)
    {
        columnValue = [columnValue stringByAppendingString:@"null, "];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Failed" message:@"Number can't be empty!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler: nil];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        columnValue = [columnValue stringByAppendingString:[NSString stringWithFormat:@"'%@', ", self.numText.text]];
        isSuccessful = YES;
    }
    
    //segmented control
    if(self.genderSeg.selectedSegmentIndex==0)
    {
        columnValue = [columnValue stringByAppendingString:@"0, "];
    }
    else
    {
        columnValue = [columnValue stringByAppendingString:@"1, "];
    }
    
    //textfield为空
    if([self.addrText.text compare:@""]==NSOrderedSame)
    {
        columnValue = [columnValue stringByAppendingString:@"null"];
    }
    else
    {
        columnValue = [columnValue stringByAppendingString:[NSString stringWithFormat:@"'%@'", self.addrText.text]];
    }
    
    if(isSuccessful)
    {
        NSLog(@"%@", columnValue);
        [[Database defaultDb] insertSQLWithColumnName:@"id, fname, lname, phnNum, gender, addr" columnValue:columnValue tableName:@"contacts"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)change:(UISegmentedControl*)sender
{
    if(sender.selectedSegmentIndex==0)
    {
        NSLog(@"[segmentedControl] male selected");
        [self.avatar setImage:[UIImage imageNamed:@"male80.png"]];
    }
    else
    {
        NSLog(@"[segmentedcontrol] female selected");
        [self.avatar setImage:[UIImage imageNamed:@"female80.png"]];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{   /* 辞去第一响应者 */
    [textField resignFirstResponder]; return YES;
}

@end

