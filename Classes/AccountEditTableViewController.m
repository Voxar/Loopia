//
//  AccountEditViewController.m
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-03-04.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "AccountEditViewController.h"
#import "EditableDetailCell.h"

@implementation AccountEditViewController

@synthesize account;

-(id)initWithAccount:(LPAccount*)account_;
{
  if(![self initWithNibName:@"AccountEditView" bundle:nil]) return nil;
  
  self.account = account_;
  
  return self;
}

- (EditableDetailCell *)newDetailCellWithTag:(NSInteger)tag
{
  EditableDetailCell *cell = [[EditableDetailCell alloc] initWithFrame:CGRectZero 
                                                       reuseIdentifier:nil];
  [[cell textField] setDelegate:self];
  [[cell textField] setTag:tag];
  
  return cell;
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

-(void)save
{
  [usernameField resignFirstResponder];
  [passwordField resignFirstResponder];
  [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
  [super viewDidLoad];

  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
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
  return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  EditableDetailCell *cell = [self newDetailCellWithTag:[indexPath row]];
  
  switch ([indexPath row]) {
  case 0:
      usernameField = cell.textField;
      usernameField.text = account.username;
      [usernameField setAutocorrectionType:UITextAutocorrectionTypeNo];
    break;
  case 1:
      passwordField = cell.textField;
      passwordField.text = account.password;
      [passwordField setAutocorrectionType:UITextAutocorrectionTypeNo];
      [passwordField setSecureTextEntry:YES];
    break;
  }
  
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Navigation logic may go here. Create and push another view controller.
  // AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
  // [self.navigationController pushViewController:anotherViewController];
  // [anotherViewController release];
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
  [super dealloc];
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
  NSLog(@"endEdit: %@", textField.text);
  if (textField.tag == UsernameTag) {
    account.username = textField.text;
  } else {
    account.password = textField.text;
  }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
  if(textField.tag == UsernameTag){
    [passwordField becomeFirstResponder];
  } else {
    [self save];
  }
  return YES;
}
@end

