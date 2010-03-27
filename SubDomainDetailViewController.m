//
//  ZoneInfoController.m
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-02-28.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "SubDomainDetailViewController.h"
#import "ZoneViewController.h"
#import "AddZoneViewController.h"
#import "LPDNSEntry.h"
#import "AddSubdomainController.h"

@implementation SubDomainDetailViewController

@synthesize domain, subdomain, zoneInfoArray;

-(id)initWithDomain:(LPDomain *)domain_ subdomain:(LPSubdomain *)subdomain_ zones:(NSArray *)zones_;
{
  if(![self initWithNibName:@"SubDomainDetailView" bundle:nil]) return nil;
  
  self.domain = domain_;
  self.subdomain = subdomain_;
  self.zoneInfoArray = zones_;
  
  self.title = subdomain.name;
  
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
  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                                                         target:self 
                                                                                         action:@selector(addItem:)] autorelease];
}

-(void)addItem:(id)sender;
{
  LPDNSEntry *newEntry = [[LPDNSEntry alloc] init];
  AddZoneViewController *zoneView = [[AddZoneViewController alloc] initWithDNSEntry:newEntry forDomain:domain subdomain:subdomain];
  zoneView.delegate = self;
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:zoneView];
  [self.navigationController presentModalViewController:navController animated:YES];
  [zoneView release];
  [newEntry release];
}

-(void)saveZoneComplete:(LPDNSEntry *)newEntry;
{
  if(newEntry){
    if(![zoneInfoArray containsObject:newEntry]){
      NSMutableArray *mutableZones = [zoneInfoArray mutableCopyWithZone:nil];
      [mutableZones addObject:newEntry];
      self.zoneInfoArray = mutableZones;
    }
    [(UITableView*)self.view reloadData];
  }
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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [zoneInfoArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Set up the cell...
  LPDNSEntry *zone = [zoneInfoArray objectAtIndex:[indexPath row]];
  cell.textLabel.text = zone.type;
  cell.detailTextLabel.text = zone.data;
  [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  id entry = [zoneInfoArray objectAtIndex:[indexPath row]];
  ZoneViewController *zoneView = [[ZoneViewController alloc] initWithDNSEntry:entry forDomain:domain subdomain:subdomain];
  zoneView.delegate = self;
  [self.navigationController pushViewController:zoneView animated:YES];
  [zoneView release];
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
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
  self.subdomain = nil;
  self.zoneInfoArray = nil;
  
    [super dealloc];
}


@end

