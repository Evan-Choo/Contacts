//
//  AddContactViewController.h
//  Contact1
//
//  Created by Evan Choo on 7/3/18.
//  Copyright © 2018 Evan Choo. All rights reserved.
//

#ifndef AddContactViewController_h
#define AddContactViewController_h

#import <UIKit/UIKit.h>

@interface AddContactViewController : UIViewController

@property NSInteger index;
@property BOOL openRoute;

@property (weak, nonatomic) IBOutlet UITextField *fnameText;
@property (weak, nonatomic) IBOutlet UITextField *lnameText;
@property (weak, nonatomic) IBOutlet UITextField *numText;
@property (weak, nonatomic) IBOutlet UITextField *addrText;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;

#pragma mark - hiding prevention
@property (nonatomic, assign) CGFloat keyBoardHeight;
@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic,strong) UITextView *currentTextView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSeg;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

-(IBAction)clickShare:(id)sender;

-(IBAction)clickSave:(id)sender;

-(IBAction)clickDelete:(id)sender;

@end


#endif /* AddContactViewController_h */
