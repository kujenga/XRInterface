//
//  XRIBookstoreViewController.h
//  XRInterface
//
//  Created by Aaron Taylor on 3/11/14.
//  Copyright (c) 2014 Williams College cs339. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLRPCConnectionDelegate.h"

@interface XRIBookstoreViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate,
                                                          UITableViewDataSource,UITableViewDelegate,
                                                          UITextFieldDelegate,
                                                          XMLRPCConnectionDelegate>
-(void) passAttributes:(NSDictionary*) attributesIn;

@end
