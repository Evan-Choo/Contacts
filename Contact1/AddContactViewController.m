//
//  AddContactViewController.m
//  Contact1
//
//  Created by Evan Choo on 7/3/18.
//  Copyright © 2018 Evan Choo. All rights reserved.
//

#import "AddContactViewController.h"
#import "Database.h"

@interface AddContactViewController()<UITextViewDelegate>
{
    NSString *fname1;
    NSString *lname1;
    NSString *phnNum1;
    NSString *addr1;
    int gender1;
}
@end

@implementation AddContactViewController

@synthesize index;
@synthesize openRoute;

-(void)viewDidLoad
{
    self.fnameText.delegate = self;
    self.lnameText.delegate = self;
    self.numText.delegate = self;
    self.addrText.delegate = self;
    
    [self.genderSeg addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    //点击＋号(false)打开和点击tableCell(true)打开显示效果会不一样
    if(openRoute){
        NSLog(@"%ld", (long)index);
        
        sqlite3_stmt *result = [[Database defaultDb]selectSQLWithOrderBy:nil findStr:nil whereStr:[NSString stringWithFormat:@"id=%i", (int)index] limit:-1 tableName:@"contacts"];
        
        while(sqlite3_step(result)==SQLITE_ROW)
        {
            char *ID = (char*)sqlite3_column_text(result, 0);
            char *fname = (char*)sqlite3_column_text(result, 1);
            char *lname = (char*)sqlite3_column_text(result, 2);
            char *phnNum = (char*)sqlite3_column_text(result, 3);
            char *gender = (char*)sqlite3_column_text(result, 5);
            char *addr = (char*)sqlite3_column_text(result, 4);
            
            
            int ID1 = atoi(ID);
            gender1 = atoi(gender);
            
            fname1 = [NSString string];
            lname1 = [NSString string];
            phnNum1 = [NSString string];
            addr1 = [NSString string];
            
            if(fname!=NULL)
            {
                fname1 = [NSString stringWithUTF8String:fname];
            }
            else
            {
                fname1 = @"";
            }
            
            if(lname!=NULL)
            {
                lname1 = [NSString stringWithUTF8String:lname];
            }
            else
            {
                lname1 = @"";
            }
            
            if(phnNum!=NULL)
            {
                phnNum1 = [NSString stringWithUTF8String:phnNum];
            }
            else
            {
                phnNum1 = @"";
            }
            
            if(addr!=NULL)
            {
                addr1 = [NSString stringWithUTF8String:addr];
            }
            else
            {
                addr1 = @"";
            }
            
            NSString* gender2 = (gender1 == 0)?@"male":@"female";
            
            NSLog(@"result: %i|%@|%@|%@|%@|%@", ID1, fname1, lname1, phnNum1, addr1, gender2);
            
            self.fnameText.text = fname1;
            self.lnameText.text = lname1;
            self.numText.text = phnNum1;
            self.addrText.text = addr1;
            self.genderSeg.selectedSegmentIndex = gender1;
            
            if(gender1==0)
            {
                [self.avatar setImage:[UIImage imageNamed:@"male80.png"]];
            }
            else if(gender1==1)
            {
                [self.avatar setImage:[UIImage imageNamed:@"female80.png"]];
            }
        }
        
        sqlite3_finalize(result);
    }else{
        self.fnameText.text = @"";
        self.lnameText.text = @"";
        self.numText.text = @"";
        self.addrText.text = @"";
        self.genderSeg.selectedSegmentIndex = 0;
        [self.avatar setImage:[UIImage imageNamed:@"male80.png"]];
        
        [self.deleteBtn setEnabled:NO];
        [self.deleteBtn setUserInteractionEnabled:NO];
        [self.deleteBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{   /* 辞去第一响应者 */
    [textField resignFirstResponder]; return YES;
}

-(IBAction)clickShare:(id)sender
{
    //分享的标题
    NSString *textToShare = @"分享的标题";
    
    NSArray *activityItems = @[textToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"completed");
            //分享 成功
        } else  {
            NSLog(@"cancled");
            //分享 取消
        }
    };
}

-(IBAction)clickSave:(id)sender
{
    if(openRoute)
    {
        BOOL isChanged = false;
        
        if([self.fnameText.text compare:fname1]!=NSOrderedSame)
        {
            [[Database defaultDb]updateSQLWithNewColumnsKeyAndValue:[NSString stringWithFormat:@"fname = '%@'", self.fnameText.text] whereStr:[NSString stringWithFormat:@"id = %i", (int)index] tableName:@"contacts"];
            isChanged = true;
        }
        if([self.lnameText.text compare:lname1]!=NSOrderedSame)
        {
            [[Database defaultDb]updateSQLWithNewColumnsKeyAndValue:[NSString stringWithFormat:@"lname = '%@'", self.lnameText.text] whereStr:[NSString stringWithFormat:@"id = %i", (int)index] tableName:@"contacts"];
            isChanged = true;
        }
        if([self.numText.text compare:phnNum1]!=NSOrderedSame && [self.numText.text compare:@""]!=NSOrderedSame)
        {
            [[Database defaultDb]updateSQLWithNewColumnsKeyAndValue:[NSString stringWithFormat:@"phnNum = '%@'", self.numText.text] whereStr:[NSString stringWithFormat:@"id = %i", (int)index] tableName:@"contacts"];
            isChanged = true;
        }else if ([self.numText.text compare:@""]==NSOrderedSame)
        {
            UIAlertController* a = [UIAlertController alertControllerWithTitle:@"Failed" message:@"Number can't be empty!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [a addAction:action];
            [self presentViewController:a animated:YES completion:nil];
        }
        if([self.addrText.text compare:addr1]!=NSOrderedSame)
        {
            [[Database defaultDb]updateSQLWithNewColumnsKeyAndValue:[NSString stringWithFormat:@"addr = '%@'", self.addrText.text] whereStr:[NSString stringWithFormat:@"id = %i", (int)index] tableName:@"contacts"];
            isChanged = true;
        }
        if(self.genderSeg.selectedSegmentIndex!=gender1)
        {
            [[Database defaultDb]updateSQLWithNewColumnsKeyAndValue:[NSString stringWithFormat:@"gender = %i", (int)self.genderSeg.selectedSegmentIndex] whereStr:[NSString stringWithFormat:@"id = %i", (int)index] tableName:@"contacts"];
            isChanged = true;
        }
        
        if(isChanged)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            UIAlertController* a = [UIAlertController alertControllerWithTitle:@"Failed" message:@"No changes have been made" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [a addAction:action];
            [self presentViewController:a animated:YES completion:nil];
        }
    }
    else
    {
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
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

-(IBAction)clickDelete:(id)sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Confirmation"
                                                                   message:@"Do you want to delete this contact?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              NSLog(@"action = %@", action);
                                                              [[Database defaultDb]deleteSQLWithWhereStr:[NSString stringWithFormat:@"id=%i",(int)index] tableName:@"contacts"];
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             NSLog(@"action = %@", action);
                                                         }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - change for segmented control
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

@end
