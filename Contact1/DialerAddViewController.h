//
//  DialerAddViewController.h
//  Contact1
//
//  Created by Evan Choo on 6/29/18.
//  Copyright © 2018 Evan Choo. All rights reserved.
//
#ifndef DialerAddViewController_h
#define DialerAddViewController_h

#import <UIKit/UIKit.h>

@interface DialerAddViewController : UIViewController

@property NSString *input;

@property (weak,nonatomic) IBOutlet UITextField *fnameText;
@property (weak,nonatomic) IBOutlet UITextField *lnameText;
@property (weak,nonatomic) IBOutlet UITextField *numText;
@property (weak,nonatomic) IBOutlet UITextField *addrText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSeg;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

-(IBAction)clickCancle:(id)sender;
-(IBAction)clickSave:(id)sender;

@end

#endif /* DialerAddViewController_h */
