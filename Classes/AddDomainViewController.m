    //
//  AddDomainViewController.m
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-06-09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddDomainViewController.h"
#import "LoopiaAppDelegate.h"

@interface NSObject (AddDomainDelegate)
-(void)didAddDomain;
@end


@implementation AddDomainViewController

@synthesize hud;

-(id)initWithDelegate:(id)delegate_;
{
  if(![super initWithNibName:@"AddDomainView" bundle:nil]) return nil;
  
  delegate = delegate_;
  
  return self;
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  hud = [[MBProgressHUD alloc] initWithView:self.view];
  [self.view addSubview:hud];
  
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
  
  self.navigationItem.leftBarButtonItem = cancelButton;
  
  [cancelButton release];
  
  
  [domainField becomeFirstResponder];
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


- (void)dealloc {
  self.hud = nil;
  [super dealloc];
}

-(MBProgressHUD*)createHudWithText:(NSString *)text;
{
  self.hud = [[MBProgressHUD alloc] initWithView:self.view];
  self.hud.labelText = text;
  [self.view addSubview:self.hud];
  return self.hud;
}

-(void)registerComplete;
{
  if(delegate) [delegate didAddDomain];
  [self dismissModalViewControllerAnimated:YES];
}

-(void)registerDomain:(NSString *)domainName;
{
  if([[LoopiaAppDelegate sharedAPI] addDomainToAccount:domainName buy:YES]){
    hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"Done";
    [self performSelectorOnMainThread:@selector(registerComplete) withObject:nil waitUntilDone:NO];
  } else {
    hud.labelText = @"Failed";
  }
  sleep(1);
}

-(void)checkDomain:(NSString *)domainName;
{
  if([[LoopiaAppDelegate sharedAPI] domainIsFree:domainName]){
    button.titleLabel.text = @"Register domain"; 
    isFree = YES;
    
    hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"Available!";
  } else {
    hud.labelText = @"Occupied";
  }
  sleep(1);
}


-(void)cancelAction;
{
  [self dismissModalViewControllerAnimated:YES];  
}

-(IBAction)buttonAction:(id)sender;
{
  [domainField resignFirstResponder];
  NSString *domainName = domainField.text;
  //TODO: Validate
  //must end in dot + 2-3 characters
  //must not have invalid characters
  
  if(isFree){
    //Register it
    [self createHudWithText:@"Registering"];
    [hud showWhileExecuting:@selector(registerDomain:) onTarget:self withObject:domainName animated:YES];
  } else {
    //Check it
    [self createHudWithText:@"Checking"];
    [hud showWhileExecuting:@selector(checkDomain:) onTarget:self withObject:domainName animated:YES];
  }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
  isFree = NO;
  button.titleLabel.text = @"Check availability";
}

@end
