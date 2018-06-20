//
//  ThirdViewController.h
//  Contacts
//
//  Created by Evan Choo on 6/18/18.
//  Copyright © 2018 Evan Choo. All rights reserved.
//

#ifndef ThirdViewController_h
#define ThirdViewController_h

#import <UIKit/UIKit.h>

@interface ThirdViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *yellowPageWeb;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stopButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;

-(void)updateButtons;
@end


#endif /* ThirdViewController_h */

