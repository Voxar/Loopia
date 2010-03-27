//
//  DomainViewController.m
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-02-28.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "DomainViewController.h"
#import "SubDomainDetailViewController.h"
#import "LoopiaAppDelegate.h"

@implementation DomainViewController

@synthesize domain, subdomains;

-(id)initWithDomain:(NSDictionary *)domain_ subdomains:(NSArray *)subdomains_;
{
  if(![self initWithNibName:@"DomainView" bundle:nil]) return nil;
  
  self.domain = domain_;
  self.subdomains = subdomains_;
  
  return self;
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  self.title = [domain objectForKey:@"domain"];
  
  NSLog(@"%@", domain);
  BOOL registered = [[domain objectForKey:@"registered"] boolValue];
  BOOL paid = [[domain objectForKey:@"paid"] boolValue];
  statusLabel.text = registered ? @"Registrerad" : @"Oregistrerad";
  payButton.enabled = !paid;
  int amount = [[domain objectForKey:@"unpaid_amount"] intValue];
  payButton.titleLabel.text = paid ? @"Betalad" : [NSString stringWithFormat:@"Betala", amount];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(IBAction)payButtonAction:(id)sender;
{
  payButton.titleLabel.text = @"Betald";
  payButton.enabled = NO;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [subdomains count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
  return @"Subdomäner";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Set up the cell...
  NSString *subdomain = [subdomains objectAtIndex:[indexPath row]];
  cell.textLabel.text = subdomain;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
  return cell;
}


-(id)loadContentForNextPageWithObject:(NSIndexPath*)indexPath;
{
  NSString *domainName = [domain objectForKey:@"domain"];
  NSString *subdomain = [subdomains objectAtIndex:[indexPath row]];
  NSArray *zoneInfo = [[LoopiaAppDelegate sharedAPI] zoneRecordsForDomain:domainName subdomain:subdomain];
  NSLog(@"%@\n%@", domain, subdomain);
  return [NSArray arrayWithObjects:zoneInfo, domainName, subdomain, nil];
}

-(void)navigateToNextPageWithObject:(id)args;
{
  NSArray *zones = [args objectAtIndex:0];
  NSString *domainName = [args objectAtIndex:1];
  NSString *subdomain = [args objectAtIndex:2];
  SubDomainDetailViewController *zoneView = [[[SubDomainDetailViewController alloc] initWithDomainName:domainName subdomain:subdomain zoneInfo:zones] autorelease];
  [self.navigationController pushViewController:zoneView animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  [self startLoadingCell:cell withObject:indexPath];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
  self.domain = nil;
  self.subdomains = nil;
    [super dealloc];
}


@end

