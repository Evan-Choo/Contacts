//
//  FirstViewController.h
//  Contacts
//
//  Created by Evan Choo on 6/14/18.
//  Copyright © 2018 Evan Choo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UITableViewController

@property (nonatomic, strong) UISearchController* searchController;

@property (nonatomic, strong) NSMutableArray* results;

-(IBAction)clickAdd:(id)sender;

@end

