//
//  XRIDetailViewController.h
//  XRInterface
//
//  This class provides functionality to interface with a custom connection
//
//  Created by Aaron Taylor on 3/6/14.
//  Copyright (c) 2014 Aaron Taylor. All rights reserved.
//

#import "XMLRPCConnectionDelegate.h"

#import <UIKit/UIKit.h>

@interface XRIDetailViewController : UIViewController <UISplitViewControllerDelegate, XMLRPCConnectionDelegate,
                                                       UITableViewDataSource, UITableViewDelegate,
                                                       UITextFieldDelegate>

@property (strong, nonatomic) id detailItem;


@end
