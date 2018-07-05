//
//  SecondViewController.h
//  Contacts
//
//  Created by Evan Choo on 6/14/18.
//  Copyright © 2018 Evan Choo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *phoneNumLable;

//number buttons
-(IBAction)clickDigit :(UIButton*)sender;

//click *
-(IBAction)clickAsterisk:(UIButton*)sender;

//click #
-(IBAction)clickWell:(UIButton*)sender;

//dialer button
-(IBAction)clickDial:(UIButton*)sender;

//delete button
-(IBAction)clickDelete:(UIButton*)sender;

//all clear
-(IBAction)clickAllClear:(UIButton*)sender;

//save as contact
-(IBAction)clickSave:(UIButton*)sender;


@end

