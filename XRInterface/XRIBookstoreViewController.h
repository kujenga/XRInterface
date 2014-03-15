//
//  XRIBookstoreViewController.h
//  XRInterface
//
//  This class provides a custom connection to The bookserver created for cs339
//  It supports buy, sell, and search operations and displays the result in the the lower text area
//
//  Created by Aaron Taylor on 3/11/14.
//  Copyright (c) 2014 Aaron Taylor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLRPCConnectionDelegate.h"

@interface XRIBookstoreViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate,
                                                          UITableViewDataSource,UITableViewDelegate,
                                                          UITextFieldDelegate,
                                                          XMLRPCConnectionDelegate>

// This method is called to pass the attributes for the connection into the class from the XRIMasterViewController
-(void) passAttributes:(NSDictionary*) attributesIn;

@end
