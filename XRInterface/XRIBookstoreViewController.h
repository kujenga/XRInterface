//
//  XRIBookstoreViewController.h
//  XRInterface
//
//  Created by Aaron Taylor on 3/11/14.
//  Copyright (c) 2014 Williams College cs339. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRIBookstoreViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate,
                                                          UITableViewDataSource,UITableViewDelegate,
                                                          UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *methods;
@property (weak, nonatomic) IBOutlet UITableView *parameters;


@end
