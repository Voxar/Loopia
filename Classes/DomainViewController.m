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
#import "AddSubdomainController.h"

NSInteger compareSubdomains(LPSubdomain *a, LPSubdomain *b, void *user){
  return [a.name compare:b.name];
}

@implementation DomainViewController

@synthesize domain, subdomains, progressHud;

-(id)initWithDomain:(LPDomain *)domain_ subdomains:(NSArray *)subdomains_;
{
  if(![self initWithNibName:@"DomainView" bundle:nil]) return nil;
  
  self.domain = domain_;
  self.subdomains = [subdomains_ sortedArrayUsingFunction:compareSubdomains context:nil];
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


-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
  [super setEditing:editing animated:animated];
  //[self.navigationController setToolbarHidden:!editing animated:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  self.title = domain.name;
  
  BOOL canPay = domain.paid == 0 && domain.referenceNr != -1 && domain.unpaidAmount != 0.0;
  
  NSLog(@"domainview didload%@", domain);
  statusLabel.text = domain.registered ? @"Registered" : @"Unregistered";
  payButton.enabled = canPay;
  [payButton setTitle:(canPay ? [NSString stringWithFormat:@"Pay %.2f Kr", domain.unpaidAmount] : @"Paid") forState:payButton.state];
  [payButton setNeedsLayout];
  
  
  UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSubdomain)];
  [self setToolbarItems:[NSArray arrayWithObjects:spaceButton, addButton, nil]];
  [addButton release];
  [spaceButton release];
  
  self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)addSubdomain;
{
  AddSubdomainController *addSubdomainController = [[AddSubdomainController alloc] initWithDomain:domain];
  addSubdomainController.delegate = self;
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addSubdomainController];
  [self presentModalViewController:nav animated:YES];
  [addSubdomainController release];
  [nav release];
}

-(void)didRemoveSubdomain:(LPSubdomain *)subdomain;
{
  if(subdomain){
    NSUInteger index = [subdomains indexOfObject:subdomain];
    
    NSMutableArray *mutableSubdomains = [subdomains mutableCopyWithZone:nil];
    [mutableSubdomains removeObject:subdomain];
    self.subdomains = mutableSubdomains;
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];  
  }
}

-(void)removeSubdomain:(LPSubdomain *)subdomain;
{
  NSLog(@"removing subdomain %@", subdomain);
  BOOL success = [[LoopiaAppDelegate sharedAPI] removeSubdomainName:subdomain.name forDomainName:domain.name];
  NSLog(success ? @"OK" : @"FAIL");
  if(success){
    [self performSelectorOnMainThread:@selector(didRemoveSubdomain:) withObject:(success ? subdomain : nil) waitUntilDone:NO];
  }
}

-(void)addSubdomain:(AddSubdomainController*)controller savedSubdomain:(LPSubdomain *)savedSubdomain withSuccess:(BOOL)success;
{
  if(success){
    self.subdomains = [[subdomains arrayByAddingObject:savedSubdomain] sortedArrayUsingFunction:compareSubdomains context:nil];
    [self.tableView reloadData];
  }
}

- (void)hudWasHidden;
{
  [self.progressHud removeFromSuperview];
  self.progressHud = nil;
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

-(void)didPayInvoiceForDomain:(LPDomain *)paidDomain;
{
  if(paidDomain){
    payButton.enabled = NO;
    [payButton setTitle:@"Paid" forState:UIControlStateDisabled];
  }
}

-(void)payInvoice:(NSString *)refNr;
{
  BOOL success = [[LoopiaAppDelegate sharedAPI] payInvoiceWithRefNr:refNr];
  if(success){
    self.progressHud.labelText = @"Verifying";
    LPDomain *paidDomain = [[LoopiaAppDelegate sharedAPI] domainForDomainName:domain.name];
    success = paidDomain.paid;
    if(success){
      progressHud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
      progressHud.mode = MBProgressHUDModeCustomView;
      progressHud.labelText = @"Success"; 
    } else {
      progressHud.labelText = @"Failed";
    }

    sleep(1);
    [self performSelectorOnMainThread:@selector(didPayInvoiceForDomain:) withObject:(success ? paidDomain : nil) waitUntilDone:NO];
  } else {
    progressHud.labelText = @"Failed";
    sleep(1);
    [self performSelectorOnMainThread:@selector(didPayInvoiceForDomain:) withObject:nil waitUntilDone:NO];
  }
}

-(IBAction)payButtonAction:(id)sender;
{
  self.progressHud = [[MBProgressHUD alloc] initWithView:self.view];
  self.progressHud.labelText = @"Paying";
  [self.view addSubview:progressHud];
  [self.progressHud showWhileExecuting:@selector(payInvoice:) onTarget:self withObject:domain.stringReferenceNr animated:YES];
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
  return @"Subdomains";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Set up the cell...
  LPSubdomain *subdomain = [subdomains objectAtIndex:[indexPath row]];
  cell.textLabel.text = subdomain.name;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
  return cell;
}


-(id)loadContentForNextPageWithObject:(NSIndexPath*)indexPath;
{
  LPSubdomain *subdomain = [subdomains objectAtIndex:[indexPath row]];
  NSArray *zoneInfo = [[LoopiaAppDelegate sharedAPI] zoneRecordsForDomainName:domain.name subdomainName:subdomain.name];
  NSLog(@"%@\n%@", domain, subdomain);
  return [NSArray arrayWithObjects:zoneInfo, subdomain, nil];
}

-(void)navigateToNextPageWithObject:(id)args;
{
  NSArray *zones = [args objectAtIndex:0];
  LPSubdomain *subdomain = [args objectAtIndex:1];
  SubDomainDetailViewController *zoneView = [[[SubDomainDetailViewController alloc] initWithDomain:domain subdomain:subdomain zones:zones] autorelease];
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

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      // Delete the row from the data source
      LPSubdomain *subdomain = [subdomains objectAtIndex:indexPath.row];
      self.progressHud = [[MBProgressHUD alloc] initWithView:self.view];
      self.progressHud.labelText = [NSString stringWithFormat:@"Removing %@", subdomain.name];
      [self.view addSubview:progressHud];
      [self.progressHud showWhileExecuting:@selector(removeSubdomain:) onTarget:self withObject:subdomain animated:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



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

