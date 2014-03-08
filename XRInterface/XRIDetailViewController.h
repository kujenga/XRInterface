//
//  XRIDetailViewController.h
//  XRInterface
//
//  Created by Aaron Taylor on 3/6/14.
//  Copyright (c) 2014 Williams College cs339. All rights reserved.
//

#import "XMLRPCConnectionDelegate.h"

#import <UIKit/UIKit.h>

@interface XRIDetailViewController : UIViewController <UISplitViewControllerDelegate, XMLRPCConnectionDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
