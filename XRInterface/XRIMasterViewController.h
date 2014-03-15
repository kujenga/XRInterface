//
//  XRIMasterViewController.h
//  XRInterface
//
//  This class controlls the main screen of the app, through which the detail view controllers and the creation screen are accessed
//
//  Created by Aaron Taylor on 3/6/14.
//  Copyright (c) 2014 Aaron Taylor. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XRIDetailViewController;
@class XRINewConnectionViewController;

@interface XRIMasterViewController : UITableViewController

// This method is called by the XRINewConnectionViewController class to add a new row to the screen presented by this class
- (void)insertNewObject:(id)sender withConnectionAttributes:(NSDictionary*) connectionAttributes;

// The view controller that is instantiated with the proper object passed to it upon row selection
@property (strong, nonatomic) XRIDetailViewController *detailViewController;
// The view controller for the creation of new connections
@property (strong,nonatomic) XRINewConnectionViewController *connectionViewController;
// The button that is presssed by the user to setup a new XML-RPC connection
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end
