//
//  XRINewConnectionViewController.h
//  XRInterface
//
//  Created by Aaron Taylor on 3/6/14.
//  Copyright (c) 2014 Aaron Taylor. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XRIMasterViewController;

@interface XRINewConnectionViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

-(void) connectMaster:(id) sender;

-(IBAction) cancelCreation:(id)sender;
-(IBAction) finishCreation:(id) sender;


@property (weak, nonatomic) IBOutlet UITableView *inputTable;

@property (weak,nonatomic) XRIMasterViewController *masterController;

@end
