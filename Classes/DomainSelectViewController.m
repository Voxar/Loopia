//
//  RootViewController.m
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-02-25.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "DomainSelectViewController.h"
#import "LoopiaAppDelegate.h"
#import "DomainViewController.h"
#import "Loopia.h"
#import "SearchDomainViewController.h"

NSInteger compareDomains(LPDomain *a, LPDomain *b, void *user){
  return [a.name compare:b.name];
}


@implementation DomainSelectViewController

@synthesize domains;


-(id)initWithDomains:(NSArray *)domains_;
{
  if(![self initWithNibName:@"DomainSelectView" bundle:nil]) return nil;
  
  self.domains = [domains_ sortedArrayUsingFunction:compareDomains context:nil];
  
  return self;
}

-(void)addDomain;
{
  SearchDomainViewController *addDomainController = [[SearchDomainViewController alloc] initWithNibName:@"AddDomainView" bundle:nil];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addDomainController];
  
  [self presentModalViewController:nav animated:YES];
  
  [addDomainController release];
  [nav release];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Domains";

  // No point in adding Domains if you can't search for unoccupied domains. 
//  UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDomain)];
//  [self setToolbarItems:[NSArray arrayWithObjects:spaceButton, addButton, nil]];
//  [addButton release];
//  [spaceButton release];
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

- (void)viewDidUnload {
	// Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	// For example: self.myOutlet = nil;
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Add a new object

- (void)insertNewObject {
	
}


#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [domains count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
  LPDomain *domain = [domains objectAtIndex:[indexPath row]];
	cell.textLabel.text = domain.name;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return cell;
}


-(id)loadContentForNextPageWithObject:(NSIndexPath*)indexPath;
{  
  LPDomain *domain = [domains objectAtIndex:[indexPath row]];
  
  NSArray *subdomains = [[LoopiaAppDelegate sharedAPI] subdomainsForDomainName:domain.name];

  return [NSArray arrayWithObjects:domain, subdomains, nil];
}

-(void)navigateToNextPageWithObject:(NSArray *)args;
{
  LPDomain *domain = [args objectAtIndex:0];
  NSArray *subdomains = [args objectAtIndex:1];
  DomainViewController *domainView = [[DomainViewController alloc] initWithDomain:domain subdomains:subdomains];
  [domainView setDomain:domain];
  [self.navigationController pushViewController:domainView animated:YES];
  [domainView release];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the managed object for the given index path
	}   
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}



// NSFetchedResultsControllerDelegate method to notify the delegate that all section and object changes have been processed. 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// In the simplest, most efficient, case, reload the table view.
	[self.tableView reloadData];
}

/*
 Instead of using controllerDidChangeContent: to respond to all changes, you can implement all the delegate methods to update the table view in response to individual changes.  This may have performance implications if a large number of changes are made simultaneously.

// Notifies the delegate that section and object changes are about to be processed and notifications will be sent. 
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	// Update the table view appropriately.
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	// Update the table view appropriately.
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
} 
 */


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	// Relinquish ownership of any cached data, images, etc that aren't in use.
}


- (void)dealloc {
  [super dealloc];
}


@end

