//
//  XRIDetailViewController.m
//  XRInterface
//
//  Created by Aaron Taylor on 3/6/14.
//  Copyright (c) 2014 Aaron Taylor. All rights reserved.
//

#import "XRIDetailViewController.h"

#import "XMLRPCRequest.h"
#import "XMLRPCResponse.h"
#import "XMLRPCConnectionManager.h"

@interface XRIDetailViewController () {
    NSMutableDictionary * _attributes;
    NSInteger paramNum;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (weak, nonatomic) IBOutlet UINavigationItem *headerLabel;
@property (weak, nonatomic) IBOutlet UITableView *inputTable;
@property (weak, nonatomic) IBOutlet UITextView *displayText;

- (IBAction)submitRequest:(id)sender;

- (void)configureView;
@end

@implementation XRIDetailViewController

/*
 * This class needs to be fully implemented.
 * next steps include providing a selection of the methods inputted upon creation of the item,
 * and a way to add the appropriate nuber of parameters for each method call
 */

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        if (true || [_detailItem class] == [NSDictionary class]) {
            _attributes = [(NSDictionary*)_detailItem mutableCopy];
        } else {
            NSLog(@"Error, object inputted to XRIDetailViewController was not a NSDictionary");
        }
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (_attributes) {
        self.headerLabel.title = [_attributes objectForKey:@"Name"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.inputTable.dataSource = self;
    self.inputTable.delegate = self;
    
    [self.displayText setText:@""];
    
    paramNum = 1;
    
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)submitRequest:(id)sender
{
    NSString *URLString = [NSString stringWithFormat:@"%@:%@",[_attributes objectForKey:@"URL"],[_attributes objectForKey:@"Port"]];
    NSLog(@"URLString: %@",URLString);
    NSURL *URL = [NSURL URLWithString: URLString];
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
    XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
    
    // sets the method and parameters of the response based on the current attributes string
    [request setMethod:[_attributes objectForKey:@"Method"] withParameters:[_attributes objectForKey:@"Parameters"]];
    
    NSLog(@"Request body: %@", [request body]);
    
    [manager spawnConnectionWithXMLRPCRequest: request delegate: self];
}

#pragma mark - XMLRPCConnectionDelegate methods

- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response {
    if ([response isFault]) {
        NSLog(@"Fault code: %@", [response faultCode]);
        
        NSLog(@"Fault string: %@", [response faultString]);
    } else {
        NSLog(@"Parsed response: %@", [response object]);
        [self.displayText setText:[response object]];
    }
    
    NSLog(@"Response body: %@", [response body]);
}

- (void)request: (XMLRPCRequest *)request didFailWithError: (NSError *)error
{
    NSLog(@"XMLRPC requestfailed with error: %@",error);
}


- (BOOL)request: (XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace: (NSURLProtectionSpace *)protectionSpace
{
    return NO;
}

- (void)request: (XMLRPCRequest *)request didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge
{
    
}

- (void)request: (XMLRPCRequest *)request didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge
{
    
}

#pragma mark - UITableView data source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + paramNum;
}

// Creates and returns custom cells for each type of input
// probably would make sense to create a custom subclass of UITableViewCell and move this code there
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.inputTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITextField *inputField;
    if (indexPath.section == 0) {
        if ([indexPath row] == 0) { // Method Call for the connection
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            //Label
            cell.textLabel.text = @"Method";
            //Text Field
            inputField = [[UITextField alloc] initWithFrame:CGRectMake(83, 8, 212, 30)];
            inputField.adjustsFontSizeToFitWidth = YES;
            inputField.textColor = [UIColor blackColor];
            inputField.tag = 3;
            inputField.placeholder = @"mainServer.foo";
            inputField.keyboardType = UIKeyboardTypeURL;
            inputField.returnKeyType = UIReturnKeyNext;
        } else { // Default Parameter for the Connection
            //Label
            cell.textLabel.text = @"";
            //Text Field
            inputField = [[UITextField alloc] initWithFrame:CGRectMake(18, 8, 277, 30)];
            inputField.adjustsFontSizeToFitWidth = YES;
            inputField.textColor = [UIColor blackColor];
            inputField.tag = 4;
            inputField.placeholder = @"Default Input Parameter";
            inputField.keyboardType = UIKeyboardTypeAlphabet;
            inputField.returnKeyType = UIReturnKeyDone;
        }
    } else { // default Cells
        //Label
        cell.textLabel.text = @"Other";
        //Text Field
        inputField = [[UITextField alloc] initWithFrame:CGRectMake(70, 8, 225, 30)];
        inputField.adjustsFontSizeToFitWidth = YES;
        inputField.textColor = [UIColor blackColor];
        inputField.tag = 3;
        inputField.placeholder = @"Other Info";
        inputField.keyboardType = UIKeyboardTypeAlphabet;
        inputField.returnKeyType = UIReturnKeyDone;
    }
    inputField.backgroundColor = [UIColor whiteColor];
    inputField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    inputField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
    //inputField.textAlignment = UITextAlignmentLeft;
    inputField.delegate = self;
    
    inputField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
    [inputField setEnabled: YES];
    
    [cell.contentView addSubview:inputField];
    
    return cell;
}



#pragma mark - Table View delegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        paramNum++;
        NSIndexPath * newPath = [NSIndexPath indexPathForRow:paramNum inSection:0];
        [self.inputTable insertRowsAtIndexPaths:@[newPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.inputTable scrollToRowAtIndexPath:newPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    [self.inputTable reloadData];
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // can add parameter rows, but not method rows
    if (indexPath.row == ([self tableView:self.inputTable numberOfRowsInSection:0] - 1)) {
        return YES;
    } else {
        return NO;
    }
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleInsert;
}

#pragma mark UITextField Delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    // self.inputTable.contentInset = UIEdgeInsetsMake(0, 0, 220, 0);
    if ([textField.placeholder isEqual: @"Default Input Parameter"]) {
        [self.inputTable setEditing:YES animated:YES];
    }
    
    //[self.inputTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:cell_index inSection:cell_section] animated:YES];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //NSIndexPath *indexPath = [self.inputTable indexPathForSelectedRow];
    if ( textField.text != nil ) {
        switch (textField.tag) {
            case 0:
                [_attributes setObject:textField.text forKey:@"Method"];
                break;
            default: {
                NSLog(@"Must finish implementation of textfieldDidEndEditing method in XRIDetailViewController to handle multiple parameters");
                // need code here to add elements to the NSMutableArray for key "Parameters"
                // the parameters must be kept in order, and integers must be interpreted as such
                NSMutableArray *params = [_attributes objectForKey:@"Parameters"];
                if (params == nil) {
                    params = [[NSMutableArray alloc] init];
                    [_attributes setObject:params forKey:@"Parameters"];
                }
                // This will add replicas of parameters currently, must be fixed
                [params addObject:textField.text];
            }
                break;
        }
    }
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
