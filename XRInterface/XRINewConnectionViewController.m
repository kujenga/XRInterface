//
//  XRINewConnectionViewController.m
//  XRInterface
//
//  Created by Aaron Taylor on 3/6/14.
//  Copyright (c) 2014 Williams College cs339. All rights reserved.
//

#import "XRINewConnectionViewController.h"
#import "XRIMasterViewController.h"

@interface XRINewConnectionViewController () {
    NSInteger paramNum;
}

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
    
    paramNum = 1;

    self.attributesDict = [[NSMutableDictionary alloc] initWithCapacity:10];
    [self.attributesDict setObject:[[NSMutableArray alloc] init] forKey:@"Parameters"];
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
        case 1:
            return 2;
        case 2:
            return 1 + paramNum;
        default:
            return 1;
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

// Creates and returns custom cells for each type of input
// probably would make sense to create a custom subclass of UITableViewCell and move this code there
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EntryCell";
    
    UITableViewCell *cell = [self.inputTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITextField *inputField ;
    if ([indexPath section] == 0) {
        inputField = [[UITextField alloc] initWithFrame:CGRectMake(70, 10, 225, 30)];
        inputField.adjustsFontSizeToFitWidth = YES;
        inputField.textColor = [UIColor blackColor];
        if ([indexPath row] == 0) { // Name for the Connection
            //Label
            cell.textLabel.text = @"Name";
            //Text Field
            inputField.tag = 0;
            inputField.placeholder = @"Example Name";
            inputField.keyboardType = UIKeyboardTypeAlphabet;
            inputField.returnKeyType = UIReturnKeyNext;
        }
    } else if ([indexPath section] == 1) {
        inputField = [[UITextField alloc] initWithFrame:CGRectMake(57, 10, 238, 30)];
        inputField.adjustsFontSizeToFitWidth = YES;
        inputField.textColor = [UIColor blackColor];
        if ([indexPath row] == 0) { // URL for the Connection
            //Label
            cell.textLabel.text = @"URL";
            //Text Field
            inputField.tag = 1;
            inputField.placeholder = @"http://www.example.com";
            inputField.keyboardType = UIKeyboardTypeURL;
            inputField.returnKeyType = UIReturnKeyNext;
        } else { // Port for the Connection
            //Label
            cell.textLabel.text = @"Port";
            //Text Field
            inputField.tag = 2;
            inputField.placeholder = @"8888";
            inputField.keyboardType = UIKeyboardTypeNumberPad;
            inputField.returnKeyType = UIReturnKeyDone;
        }
    } else if (indexPath.section == 2) {
        if ([indexPath row] == 0) { // Method Call for the connection
            //Label
            cell.textLabel.text = @"Method";
            //Text Field
            inputField = [[UITextField alloc] initWithFrame:CGRectMake(83, 10, 212, 30)];
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
            inputField = [[UITextField alloc] initWithFrame:CGRectMake(18, 10, 277, 30)];
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
        inputField = [[UITextField alloc] initWithFrame:CGRectMake(70, 10, 225, 30)];
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

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        paramNum++;
        NSIndexPath * newPath = [NSIndexPath indexPathForRow:paramNum inSection:2];
        [self.inputTable insertRowsAtIndexPaths:@[newPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 2) && (indexPath.row > 0)) {
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
    self.inputTable.contentInset = UIEdgeInsetsMake(0, 0, 220, 0);
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
                [self.attributesDict setObject:textField.text forKey:@"Name"];
                break;
            case 1:
                [self.attributesDict setObject:textField.text forKey:@"URL"];
            break;
            case 2:
                [self.attributesDict setObject:textField.text forKey:@"Port"];
                break;
            case 3:
                [self.attributesDict setObject:textField.text forKey:@"Method"];
                break;
            case 4: {
                NSMutableArray *params = [self.attributesDict objectForKey:@"Parameters"];
                [params addObject:textField.text];
                [self.attributesDict setObject:params forKey:@"Parameters"];
            }
            default:
                break;
        }
    }
}

@end
