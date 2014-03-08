//
//  XRINewConnectionViewController.m
//  XRInterface
//
//  Created by Aaron Taylor on 3/6/14.
//  Copyright (c) 2014 Williams College cs339. All rights reserved.
//

#import "XRINewConnectionViewController.h"
#import "XRIMasterViewController.h"

@interface XRINewConnectionViewController ()

@property (strong,atomic) NSMutableDictionary * attributesDict;

@end

@implementation XRINewConnectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) connectMaster:(id)sender
{
    self.masterController = sender;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.inputTable.delegate = self;
    self.inputTable.dataSource = self;

    self.attributesDict = [[NSMutableDictionary alloc] initWithCapacity:10];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelCreation:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)finishCreation:(id)sender
{
    /*
     
    add code here to create an XML-RPC object and send it back to the Master
    
     */
    if ([self.attributesDict count] >= 3) {
        [self.masterController insertNewObject:self withConnectionAttributes:self.attributesDict];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Input Unfinished"
                                                        message: @"Please complete all fields"
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - UITableView data source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        default:
            return 2;
    }
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Name for Connection";
        case 1:
            return @"URL Configuration";
        case 2:
            return @"Method and Parameters";
        default:
            return @"Other Settings";
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EntryCell";
    
    UITableViewCell *cell = [self.inputTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITextField *playerTextField ;
    if ([indexPath section] == 0) {
        playerTextField = [[UITextField alloc] initWithFrame:CGRectMake(73, 10, 222, 30)];
        playerTextField.adjustsFontSizeToFitWidth = YES;
        playerTextField.textColor = [UIColor blackColor];
        if ([indexPath row] == 0) { // Name for the Connection
            //Label
            cell.textLabel.text = @"Name";
            //Text Field
            playerTextField.tag = 0;
            playerTextField.placeholder = @"Example Name";
            playerTextField.keyboardType = UIKeyboardTypeAlphabet;
            playerTextField.returnKeyType = UIReturnKeyNext;
        }
    } else if ([indexPath section] == 1) {
        playerTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 10, 235, 30)];
        playerTextField.adjustsFontSizeToFitWidth = YES;
        playerTextField.textColor = [UIColor blackColor];
        if ([indexPath row] == 0) { // URL for the Connection
            //Label
            cell.textLabel.text = @"URL";
            //Text Field
            playerTextField.tag = 1;
            playerTextField.placeholder = @"http://www.example.com";
            playerTextField.keyboardType = UIKeyboardTypeURL;
            playerTextField.returnKeyType = UIReturnKeyNext;
        } else { // Port for the Connection
            //Label
            cell.textLabel.text = @"Port";
            //Text Field
            playerTextField.tag = 2;
            playerTextField.placeholder = @"8888";
            playerTextField.keyboardType = UIKeyboardTypeNumberPad;
            playerTextField.returnKeyType = UIReturnKeyDone;
        }
    } else { // default Cells
        //Label
        cell.textLabel.text = @"Other";
        //Text Field
        playerTextField = [[UITextField alloc] initWithFrame:CGRectMake(70, 10, 225, 30)];
        playerTextField.adjustsFontSizeToFitWidth = YES;
        playerTextField.textColor = [UIColor blackColor];
        playerTextField.tag = 3;
        playerTextField.placeholder = @"Other Info";
        playerTextField.keyboardType = UIKeyboardTypeAlphabet;
        playerTextField.returnKeyType = UIReturnKeyDone;
    }
    playerTextField.backgroundColor = [UIColor whiteColor];
    playerTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    playerTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
    //playerTextField.textAlignment = UITextAlignmentLeft;
    playerTextField.delegate = self;
    
    playerTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
    [playerTextField setEnabled: YES];
        
    [cell.contentView addSubview:playerTextField];

    return cell;
}



#pragma mark - Table View delegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
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
            [self.attributesDict setObject:textField.text forKey:@"Name"];
            break;
        case 1:
            [self.attributesDict setObject:[NSURL URLWithString:textField.text] forKey:@"URL"];
            break;
        case 2:
        {
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber * portNumber = [f numberFromString:@"42"];
            [self.attributesDict setObject:portNumber forKey:@"Port"];
        }
            break;

        default:
            break;
    }
}

@end
