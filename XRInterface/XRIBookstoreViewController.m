//
//  XRIBookstoreViewController.m
//  XRInterface
//
//  This class is a custom controller for interfacing with a bookstore server front end.
//  Other classes like this one can be created and linked to from prototype cells in the
//  storyboard for further customization of the app.
//
//  Created by Aaron Taylor on 3/11/14.
//  Copyright (c) 2014 Williams College cs339. All rights reserved.
//

#import "XRIBookstoreViewController.h"

#import "XMLRPCRequest.h"
#import "XMLRPCResponse.h"
#import "XMLRPCConnectionManager.h"

@interface XRIBookstoreViewController ()

@property (strong,atomic) NSDictionary * methodDic;
@property (strong,atomic) NSMutableArray *parametersArray;

@end

@implementation XRIBookstoreViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (self.methodDic == nil) {
        self.methodDic = [NSDictionary dictionaryWithObjects:@[@"mainServer.lookUp",@"mainServer.search",@"mainServer.buy"] forKeys:@[@"Lookup",@"Search",@"Buy"]];
    }
    
    self.methods.dataSource = self;
    self.methods.delegate = self;
    
    self.parameters.dataSource = self;
    self.parameters.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response {
    if ([response isFault]) {
        NSLog(@"Fault code: %@", [response faultCode]);
        
        NSLog(@"Fault string: %@", [response faultString]);
    } else {
        NSLog(@"Parsed response: %@", [response object]);
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

#pragma mark - Picker view data source

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

#pragma mark Picker view delegate

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[self.methodDic allKeys] objectAtIndex:0];
            break;
            
        case 1:
            return [[self.methodDic allKeys] objectAtIndex:1];
            break;
        
        case 2:
            return [[self.methodDic allKeys] objectAtIndex:2];
            break;
            
        default:
            return @"other";
            break;
    }
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

#pragma mark - Table view data source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = [NSString stringWithFormat:@"Cell"];
    UITableViewCell *cell = [self.parameters dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITextField *inputField ;

        inputField = [[UITextField alloc] initWithFrame:CGRectMake(73, 10, 222, 30)];
        inputField.adjustsFontSizeToFitWidth = YES;
        inputField.textColor = [UIColor blackColor];

            //Label
            cell.textLabel.text = @"Name";
            //Text Field
            inputField.tag = 0;
            inputField.placeholder = @"Example Name";
            inputField.keyboardType = UIKeyboardTypeAlphabet;
            inputField.returnKeyType = UIReturnKeyNext;
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

#pragma mark Table view delegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark UITextField Delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //NSIndexPath *indexPath = [self.inputTable indexPathForSelectedRow];
    
    switch (textField.tag) {
        case 0:
            [self.parametersArray insertObject:textField.text atIndex:0];
            break;
        case 1:
            [self.parametersArray insertObject:textField.text atIndex:1];
            break;
        case 2:
            [self.parametersArray insertObject:textField.text atIndex:2];
            break;
            
        default:
            break;
    }
}


@end
