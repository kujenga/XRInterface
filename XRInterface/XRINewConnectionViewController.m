//
//  XRINewConnectionViewController.m
//  XRInterface
//
//  Created by Aaron Taylor on 3/6/14.
//  Copyright (c) 2014 Williams College cs339. All rights reserved.
//

#import "XRINewConnectionViewController.h"
#import "XRIMasterViewController.h"

@interface XRINewConnectionViewController ()

@end

@implementation XRINewConnectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) connectMaster:(id)sender
{
    self.masterController = sender;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.textInput.text = @"sample text";
    self.textInput.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelCreation:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)finishCreation:(id)sender
{
    /*
     
    add code here to create an XML-RPC object and send it back to the Master
    
     */
    
    
    
    [self.masterController insertNewObject:self withString:self.textInput.text];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITextField Delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
