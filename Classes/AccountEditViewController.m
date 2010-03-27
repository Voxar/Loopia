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

-(void)save
{
  account.username = [NSString stringWithFormat:@"%@@loopiaapi", usernameField.text];
  account.password = passwordField.text;
  
  [usernameField resignFirstResponder];
  [passwordField resignFirstResponder];
  [self.navigationController popViewControllerAnimated:YES];
  [self dismissModalViewControllerAnimated:YES];
  
  NSLog(@"user: '%@' pass: '%@'", account.username, account.password);
}

-(void)cancel
{
  [self.navigationController popViewControllerAnimated:YES];
  [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSString *username = [[account.username componentsSeparatedByString:@"@"] objectAtIndex:0];
  usernameField.text = username;
  passwordField.text = account.password;
  
  self.title = @"Edit account";
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
  
  [usernameField becomeFirstResponder];
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


- (void)dealloc {
  [super dealloc];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
  if(textField == usernameField){
    [passwordField becomeFirstResponder];
  } else {
    [self save];
  }
  return YES;
}
@end

