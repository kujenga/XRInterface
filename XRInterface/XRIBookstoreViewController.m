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

-(IBAction)submitRequest:(id)sender;

@property (weak, nonatomic) IBOutlet UIPickerView *methodPicker;
@property (weak, nonatomic) IBOutlet UITableView *parameterCells;
@property (weak, nonatomic) IBOutlet UITextView *displayText;


@property (strong,atomic) NSDictionary * attributes;
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
    
    self.methodPicker.dataSource = self;
    self.methodPicker.delegate = self;
    
    self.parameterCells.dataSource = self;
    self.parameterCells.delegate = self;
    
    [self.attributes setValue:[self.methodDic valueForKey:[self.methodDic allKeys][0]] forKey:@"Method"];
    
    [self.displayText setText:@"Server response displayed here"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) passAttributes:(NSDictionary*) attributesIn
{
    self.attributes = attributesIn;
}

-(IBAction)submitRequest:(id)sender
{
    NSString *URLString = [NSString stringWithFormat:@"%@:%@",[_attributes objectForKey:@"URL"],[_attributes objectForKey:@"Port"]];
    NSLog(@"URLString: %@",URLString);
    NSURL *URL = [NSURL URLWithString: URLString];
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
    XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
    
    //NSArray *params = @[@53477]; // Achieving Less Bugs with More Hugs in CSCI 339 (item: 53477)
    
    [request setMethod:(NSString*)[self.attributes objectForKey:@"Method"] withParameters:[self.attributes objectForKey:@"Parameters"]];
    NSLog(@"Request body: %@", [request body]);
    
    [manager spawnConnectionWithXMLRPCRequest: request delegate: self];

}

#pragma mark - XML-RPC handling methods

- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response {
    if ([response isFault]) {
        NSLog(@"Fault code: %@", [response faultCode]);
        
        NSLog(@"Fault string: %@", [response faultString]);
    } else {
        NSLog(@"Parsed response: %@", [response object]);
        [self.displayText setText:[NSString stringWithFormat:@"%@",[response object]]];
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
    NSArray *keys = [self.methodDic allKeys];
    switch (row) {
        case 0:
            return [keys objectAtIndex:0];
            break;
            
        case 1:
            return [keys objectAtIndex:1];
            break;
        
        case 2:
            return [keys objectAtIndex:2];
            break;
            
        default:
            return @"other";
            break;
    }
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *keys = [self.methodDic allKeys];
    NSString *fullMethod = [self.methodDic objectForKey:keys[row]];
    [self.attributes setValue:fullMethod forKey:@"Method"];
}

#pragma mark - Table view data source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = [NSString stringWithFormat:@"Cell"];
    UITableViewCell *cell = [self.parameterCells dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITextField *inputField ;

    inputField = [[UITextField alloc] initWithFrame:CGRectMake(80, 13, 215, 30)];
    inputField.adjustsFontSizeToFitWidth = YES;
    inputField.textColor = [UIColor blackColor];
    //Label
    cell.textLabel.text = @"Param";
    //Text Field
    inputField.tag = 0;
    inputField.placeholder = @"Example Parameter";
    inputField.keyboardType = UIKeyboardTypeAlphabet;
    inputField.returnKeyType = UIReturnKeyDone;
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
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber * num = [f numberFromString:textField.text];
    // if it is an integer, handle it as such, otherwise default to string
    if (num != nil) {
        [self.attributes setValue:@[num] forKey:@"Parameters"];
        [self submitRequest:self];
    } else {
        [self.attributes setValue:@[textField.text] forKey:@"Parameters"];
        [self submitRequest:self];
    }
}


@end
