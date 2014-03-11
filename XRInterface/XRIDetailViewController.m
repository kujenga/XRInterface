//
//  XRIDetailViewController.m
//  XRInterface
//
//  Created by Aaron Taylor on 3/6/14.
//  Copyright (c) 2014 Williams College cs339. All rights reserved.
//

#import "XRIDetailViewController.h"

#import "XMLRPCRequest.h"
#import "XMLRPCResponse.h"
#import "XMLRPCConnectionManager.h"

@interface XRIDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation XRIDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
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

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    NSDictionary *attributes = (NSDictionary*)self.detailItem;
    NSString *URLString = [NSString stringWithFormat:@"%@:%@",[attributes objectForKey:@"URL"],[attributes objectForKey:@"Port"]];
    NSLog(@"URLString: %@",URLString);
    NSURL *URL = [NSURL URLWithString: URLString];
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
    XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
    
    NSArray *params = @[@53477]; // Achieving Less Bugs with More Hugs in CSCI 339 (item: 53477)
    
    [request setMethod: @"mainServer.lookUp" withParameters:params];
    
    NSLog(@"Request body: %@", [request body]);
    
    [manager spawnConnectionWithXMLRPCRequest: request delegate: self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XMLRPCConnectionDelegate methods

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
