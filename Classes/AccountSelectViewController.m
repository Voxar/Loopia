//
//  AccountSelectView.m
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-03-03.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "AccountSelectViewController.h"
#import "DomainSelectViewController.h"
#import "AccountEditViewController.h"

#import "LoopiaAppDelegate.h"
#import "Loopia.h"

@implementation AccountSelectViewController

@synthesize accounts;

/*
- (id)initWithStyle:(UITableViewStyle)style {
  // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
  if (self = [super initWithStyle:style]) {
  }
  return self;
}
*/


-(void)addAccount;
{
  newAccount = [[LPAccount alloc] init];
  [accounts addObject:newAccount];
  //nevigate to edit account
  [self editAccount:newAccount modal:YES];
}

-(void)editAccount:(LPAccount*)account modal:(BOOL)modal;
{
  AccountEditViewController *editAccountController = [[AccountEditViewController alloc] initWithAccount:account];
  if(modal){
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:editAccountController];
    [self presentModalViewController:nav animated:YES];
    [nav release];
  } else
    [self.navigationController pushViewController:editAccountController animated:YES];
  [editAccountController release];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Accounts";
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  self.accounts = [[LoopiaAppDelegate standardLoopiaAppDelegate] accounts];
  
  [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
  
  UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAccount)];
  [self setToolbarItems:[NSArray arrayWithObjects:spaceButton, addButton, nil]];
  [addButton release];
  [spaceButton release];
  
  
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
  [super setEditing:editing animated:animated];
//  [self.navigationController setToolbarHidden:!editing animated:animated];
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [(UITableView*)self.view reloadData];
  if(newAccount){
    if(newAccount.username.length == 0 && newAccount.password.length == 0) {
      [accounts removeObject:newAccount];
    }
    [(UITableView*)self.view reloadData];
  }
  [newAccount release];
  newAccount = nil;
}


- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [accounts count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Set up the cell...
  LPAccount *account = [accounts objectAtIndex:[indexPath row]];
  cell.textLabel.text = account.username;
  cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
  
  return cell;
}


-(id)loadContentForNextPageWithObject:(NSIndexPath*)indexPath;
{  
  LPAccount *account = [accounts objectAtIndex:[indexPath row]];
  
  [[LoopiaAppDelegate standardLoopiaAppDelegate] setupAPIWithUsername:account.username password:account.password];
  
  NSArray *domains = [[LoopiaAppDelegate sharedAPI] domains];
  
  return domains;
}

-(void)navigateToNextPageWithObject:(NSArray *)domains;
{
  if(!domains) return;
//  NSArray *domains = [args objectAtIndex:0];
  DomainSelectViewController *domainView = [[DomainSelectViewController alloc] initWithDomains:domains];
  [self.navigationController pushViewController:domainView animated:YES];
  [domainView release];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the row from the data source
    [accounts removeObjectAtIndex:[indexPath row]];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
  }   
  else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    [self addAccount];
  }   
}




// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
  id account = [[accounts objectAtIndex:[fromIndexPath row]] retain];
  [accounts removeObjectAtIndex:[fromIndexPath row]];
  [accounts insertObject:account atIndex:[toIndexPath row]];
  [account release];
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
  LPAccount *account = [accounts objectAtIndex:[indexPath row]];
  [self editAccount:account modal:NO];
}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the item to be re-orderable.
  return YES;
}
*/


- (void)dealloc {
  self.accounts = nil;
  [super dealloc];
}


@end

