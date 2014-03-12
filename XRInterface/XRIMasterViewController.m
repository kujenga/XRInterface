//
//  XRIMasterViewController.m
//  XRInterface
//
//  Created by Aaron Taylor on 3/6/14.
//  Copyright (c) 2014 Williams College cs339. All rights reserved.
//

#import "XRIMasterViewController.h"
#import "XRIDetailViewController.h"
#import "XRINewConnectionViewController.h"

#define DEFAULT_PORT 8800

@interface XRIMasterViewController () {
    NSMutableArray *_objects;
    NSMutableArray *_connections;
}
@end


@implementation XRIMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    if (!_connections) {
        _connections = [[NSMutableArray alloc] init];
    }
    
    NSMutableDictionary * bookstoreConnection = [[NSMutableDictionary alloc] initWithCapacity:10];
    [bookstoreConnection setObject:@"Bookstore Connection" forKey:@"Name"];
    [bookstoreConnection setObject:[NSURL URLWithString:@"http://rath.cs.williams.edu"] forKey:@"URL"];
    [bookstoreConnection setObject:[NSNumber numberWithInt:DEFAULT_PORT] forKey:@"Port"];
    [_connections addObject:bookstoreConnection];
    
    NSMutableDictionary * defaultConnection = [[NSMutableDictionary alloc] initWithCapacity:10];
    [defaultConnection setObject:@"Default Connection" forKey:@"Name"];
    [defaultConnection setObject:[NSURL URLWithString:@"http://rath.cs.williams.edu"] forKey:@"URL"];
    [defaultConnection setObject:[NSNumber numberWithInt:DEFAULT_PORT] forKey:@"Port"];
    [_connections addObject:defaultConnection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)insertNewObject:(id)sender withConnectionAttributes:(NSDictionary *)connectionAttributes
{
    if (!_connections) {
        _connections = [[NSMutableArray alloc] init];
    }
    [_connections addObject:connectionAttributes];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_connections.count inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSDate *object = _objects[indexPath.row];
        NSDictionary *chosenAttributes = _connections[indexPath.row];
        [[segue destinationViewController] setDetailItem:chosenAttributes];
        
    } else if ([[segue identifier] isEqualToString:@"showCreator"]) {
        
        [[segue destinationViewController] connectMaster:self];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // +1 accounts for bookstore
    return _connections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 0) && (indexPath.row == 0)) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookstoreCell" forIndexPath:indexPath];
        
        return cell;
    } else {
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        cell.textLabel.text = [_connections[indexPath.row] objectForKey:@"Name"];
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.row > 0)
        return YES;
    else
        return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_connections removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

@end
