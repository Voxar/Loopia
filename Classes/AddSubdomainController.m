  //
//  AddSubdomainController.m
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-03-27.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "AddSubdomainController.h"
#import "LoopiaAppDelegate.h"

@implementation AddSubdomainController

@synthesize delegate, saveProgressHud;

-(id)initWithDomain:(LPDomain *)domain_;
{
  if(![self initWithNibName:@"AddSubdomain" bundle:nil]) return nil;
  
  domain = [domain_ retain];
  
  return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction)];
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
  
  self.navigationItem.leftBarButtonItem = cancelButton;
  self.navigationItem.rightBarButtonItem = saveButton;
  
  [saveButton release];
  [cancelButton release];
  
  textField.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
  [textField becomeFirstResponder];
}

-(void)cancelAction;
{
  [self dismissModalViewControllerAnimated:YES];
}

-(void)saveAction;
{
  if(textField.text.length == 0) return;
  [textField resignFirstResponder];
  self.saveProgressHud = [[MBProgressHUD alloc] initWithView:self.view];
  self.saveProgressHud.labelText = @"Saving";
  [self.view addSubview:saveProgressHud];
  [self.saveProgressHud showWhileExecuting:@selector(save) onTarget:self withObject:nil animated:YES];
//  [self performSelectorInBackground:@selector(backgroundSave) withObject:nil];
}

-(void)save;
{
  LPSubdomain *subdomain = [[LPSubdomain alloc] init];
  subdomain.name = textField.text;
  
  NSLog(@"add: %@ on %@", subdomain, domain);
  
  BOOL success = [[LoopiaAppDelegate sharedAPI] addSubdomainName:subdomain.name forDomainName:domain.name];
  [self performSelectorOnMainThread:@selector(saveComplete:) withObject:(success ? subdomain : nil) waitUntilDone:NO];
  
  [subdomain release];
}

-(void)saveComplete:(LPSubdomain *)subdomain;
{
  [delegate addSubdomain:self savedSubdomain:subdomain withSuccess:(subdomain ? YES : NO)];
  [self dismissModalViewControllerAnimated:YES];
}

- (void)hudWasHidden;
{
  [saveProgressHud removeFromSuperview];
  self.saveProgressHud = nil;
}




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

- (BOOL)textFieldShouldReturn:(UITextField *)textField; 
{
  [self saveAction];
  return YES;
}

- (void)dealloc {
  [domain release];
  [super dealloc];
}


@end
