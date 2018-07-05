//
//  FirstViewController.m
//  Contacts
//
//  Created by Evan Choo on 6/14/18.
//  Copyright © 2018 Evan Choo. All rights reserved.
//

#import "FirstViewController.h"
#import "Database.h"
#import "AddContactViewController.h"
#import "Person.h"

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@end

@implementation FirstViewController

@synthesize results;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    results = [[NSMutableArray alloc]init];
    
    [[Database defaultDb] openDb:@"contacts"];
    
    [[Database defaultDb] createTable:@"contacts"];
    
    /*int count = [[Database defaultDb] getCount:nil];
    [[Database defaultDb] insertSQLWithColumnName:@"id, fname, lname, phnNum, gender, addr" columnValue:[NSString stringWithFormat:@"%i, 'Leeham', null, '15629102010', 1, 'Japan'", count] tableName:@"contacts"];
    
    count = [[Database defaultDb]getCount:nil];
    [[Database defaultDb] insertSQLWithColumnName:@"id, fname, lname, phnNum, gender, addr" columnValue:[NSString stringWithFormat:@"%i, 'Evan', null, '15629102090', 1, 'China'", count] tableName:@"contacts"];*/
    
    sqlite3_stmt *result = [[Database defaultDb]selectSQLWithOrderBy:nil findStr:nil whereStr:nil limit:-1 tableName:@"contacts"];
    
    while(sqlite3_step(result)==SQLITE_ROW)
    {
        char *ID = (char*)sqlite3_column_text(result, 0);
        char *fname = (char*)sqlite3_column_text(result, 1);
        char *lname = (char*)sqlite3_column_text(result, 2);
        char *phnNum = (char*)sqlite3_column_text(result, 3);
        char *gender = (char*)sqlite3_column_text(result, 5);
        char *addr = (char*)sqlite3_column_text(result, 4);
        
        
        int ID1 = atoi(ID);
        int gender1 = atoi(gender);
        
        NSString *fname1 = [NSString string], *lname1 = [NSString string], *phnNum1 = [NSString string], *addr1 = [NSString string];
        
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
    }
    
    sqlite3_finalize(result);
    
    [self.tableView setDataSource:(id<UITableViewDataSource>)self];
    
#pragma mark - set UISearchController
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"Search";
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    NSLog(@"[FirstViewController] reload");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.searchController.active)
    {
        NSLog(@"[FirstViewController] row selected");
        
        AddContactViewController *c = [self.storyboard instantiateViewControllerWithIdentifier:@"AddContact"];
        
        c.index = indexPath.row;
        c.openRoute = true;
        
        [self.navigationController pushViewController:c animated:YES];
    }
}

-(IBAction)clickAdd:(id)sender
{
    AddContactViewController *c = [self.storyboard instantiateViewControllerWithIdentifier:@"AddContact"];
    
    c.openRoute = false;
    
    [self.navigationController pushViewController:c animated:YES];
}

#pragma mark - swipe to delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"[TableView] clickDelete");
        
        int i = (int)indexPath.row;
        [[Database defaultDb]deleteSQLWithWhereStr:[NSString stringWithFormat:@"id=%i", i] tableName:@"contacts"];
        
        [self.tableView reloadData];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"delete";
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}

#pragma mark - UISearchResultUpdate
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString* input = searchController.searchBar.text;
    [results removeAllObjects];
    
    NSLog(@"%@", input);
    
    sqlite3_stmt *result = [[Database defaultDb]selectSQLWithOrderBy:nil findStr:@"fname, lname, phnNum, gender" whereStr:[NSString stringWithFormat:@"fname like '%%%@%%' or lname like '%%%@%%' or phnNum like '%%%@%%'", input, input, input] limit:-1 tableName:@"contacts"];
    
    while(sqlite3_step(result)==SQLITE_ROW)
    {
        char *fname = (char*)sqlite3_column_text(result, 0);
        char *lname = (char*)sqlite3_column_text(result, 1);
        char *phnNum = (char*)sqlite3_column_text(result, 2);
        char *gender = (char*)sqlite3_column_text(result, 3);
        //char *addr = (char*)sqlite3_column_text(result, 4);
        
        
        //int ID1 = atoi(ID);
        int gender1 = atoi(gender);
        
        NSString *fname1 = [NSString string], *lname1 = [NSString string], *phnNum1 = [NSString string];
        
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
        
        NSString* gender2 = (gender1 == 0)?@"male":@"female";
        
        NSLog(@"result: %@|%@|%@|%@", fname1, lname1, phnNum1, gender2);
        
        Person *person = [[Person alloc]init];
        person.fname = fname1;
        person.lname = lname1;
        person.phnNum = phnNum1;
        person.addr = nil;
        person.gender = gender1;
        
        [results addObject:person];
    }

    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!self.searchController.active)
    {
        return [[Database defaultDb]getCount:nil];
    }
    else
    {
        return results.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if(!self.searchController.active)
    {
        static NSString* cellIdentifier = @"contactCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        int index = (int)indexPath.row;
        
        sqlite3_stmt *result = [[Database defaultDb]selectSQLWithOrderBy:nil findStr:@"fname, lname, phnNum, gender" whereStr:[NSString stringWithFormat:@"id = %i", index] limit:-1 tableName:@"contacts"];
        
        while(sqlite3_step(result)==SQLITE_ROW)
        {
            char *fname = (char*)sqlite3_column_text(result, 0);
            char *lname = (char*)sqlite3_column_text(result, 1);
            char *phnNum = (char*)sqlite3_column_text(result, 2);
            char *gender = (char*)sqlite3_column_text(result, 3);
            //char *addr = (char*)sqlite3_column_text(result, 4);
            
            
            //int ID1 = atoi(ID);
            int gender1 = atoi(gender);
            
            NSString *fname1 = [NSString string], *lname1 = [NSString string], *phnNum1 = [NSString string];
            
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
            
            NSString* gender2 = (gender1 == 0)?@"male":@"female";
            
            NSLog(@"result: %@|%@|%@|%@", fname1, lname1, phnNum1, gender2);
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", fname1, lname1];
            
            cell.detailTextLabel.text = phnNum1;
        }
        
        sqlite3_finalize(result);
        
        return cell;
    }
    else
    {
        static NSString* cellIdentifier = @"contactCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        int index = (int)indexPath.row;
        
        Person *p = (Person*)[results objectAtIndex:index];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", p.fname, p.lname];
        cell.detailTextLabel.text = p.phnNum;
        
        return cell;
    }
}

@end
