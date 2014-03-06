//
//  XRINewConnectionViewController.h
//  XRInterface
//
//  Created by Aaron Taylor on 3/6/14.
//  Copyright (c) 2014 Williams College cs339. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XRIMasterViewController;

@interface XRINewConnectionViewController : UIViewController <UITextFieldDelegate>

-(void) connectMaster:(id) sender;

-(IBAction) cancelCreation:(id)sender;
-(IBAction) finishCreation:(id) sender;

@property IBOutlet UITextField *textInput;

@property (weak,nonatomic) XRIMasterViewController *masterController;

@end
