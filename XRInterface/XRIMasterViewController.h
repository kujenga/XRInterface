//
//  XRIMasterViewController.h
//  XRInterface
//
//  Created by Aaron Taylor on 3/6/14.
//  Copyright (c) 2014 Williams College cs339. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XRIDetailViewController;
@class XRINewConnectionViewController;

@interface XRIMasterViewController : UITableViewController

- (void)insertNewObject:(id)sender withString:(NSString*) str;

@property (strong, nonatomic) XRIDetailViewController *detailViewController;
@property (strong,nonatomic) XRINewConnectionViewController *connectionViewController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end
