//
//  ZoneViewController.m
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-02-28.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "ZoneViewController.h"
#import "LPDNSEntry.h"
#import "LoopiaAppDelegate.h"



@implementation ZoneViewController

@synthesize delegate, entry, domain, subdomain;

-(id)initWithDNSEntry:(LPDNSEntry*)entry_ forDomain:(LPDomain *)domain_ subdomain:(LPSubdomain *)subdomain_;
{
  if(![self initWithNibName:@"ZoneView" bundle:nil]) return nil;
  self.entry = entry_;
  self.domain = domain_;
  self.subdomain = subdomain_;
  return self;
}


-(NSArray *)dnsRecordTypes;
{
  static NSArray *recordTypes = nil;
  if(!recordTypes) 
    recordTypes = [[NSArray alloc] initWithObjects:@"A", @"AAAA", @"CNAME", @"HINFO", @"MX", @"SRV", @"TXT", nil];
  return recordTypes;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Edit record";
  self.navigationItem.rightBarButtonItem = saveButton;
}

-(void)viewWillAppear:(BOOL)animated
{
  [recordsTableView reloadData];
//  typePicker.bounds = CGRectOffset(typePicker.bounds, 0, -typePicker.bounds.size.height);
  [recordsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
  [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{

}

-(void)viewWillDisappear:(BOOL)animated
{
  [self.navigationController setToolbarHidden:NO animated:YES];
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
  self.entry = nil;
  self.domain = nil;
  self.subdomain = nil;
  [super dealloc];
}

#pragma mark Privates

-(void)hideKeyboard;
{
  [timeToLiveCell.textField resignFirstResponder];
  [priorityCell.textField resignFirstResponder];
  [dataCell.textField resignFirstResponder];
}

-(void)showPicker;
{
  CGRect bounds = typePicker.bounds;
  bounds.origin.y = 0;
  
  [UIView beginAnimations:@"showPicker" context:nil];
  [UIView setAnimationDuration:0.3];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  typePicker.bounds = bounds;
  [UIView commitAnimations];  
}

-(void)hidePicker;
{
  CGRect bounds = typePicker.bounds;
  bounds.origin.y = -typePicker.bounds.size.height;
  
  [UIView beginAnimations:@"hidePicker" context:nil];
  [UIView setAnimationDuration:0.3];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  typePicker.bounds = bounds;
  [UIView commitAnimations];  
}

#pragma mark Actions

-(void)doneSaveing:(LPDNSEntry *)savedEntry;
{
  [delegate saveZoneComplete:savedEntry];
}

-(void)backgroundSave;
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  BOOL success = [[LoopiaAppDelegate sharedAPI] updateZoneRecord:entry forDomainName:domain.name subdomainName:subdomain.name];
  if(success)
    [self performSelectorOnMainThread:@selector(doneSaveing:) withObject:entry waitUntilDone:NO];
  else
    [self performSelectorOnMainThread:@selector(doneSaveing:) withObject:nil waitUntilDone:NO];
  [pool release];
}

-(IBAction)saveAction:(id)sender;
{
  NSNumberFormatter *nf = [[[NSNumberFormatter alloc] init] autorelease];
  entry.ttl = [nf numberFromString:timeToLiveCell.textField.text];
  entry.type = typeCell.detailTextLabel.text;
  entry.priority = [nf numberFromString:priorityCell.textField.text];
  entry.data = dataCell.textField.text;
  
  [self performSelectorInBackground:@selector(backgroundSave) withObject:nil];
}

#pragma mark TableView

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section;
{
  return 4;
}

-(EditableDetailCell *)newEditableCell;
{
  EditableDetailCell *cell = [[EditableDetailCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"editablecell"];
  return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  UITableViewCell *cell = nil;
  
  switch ([indexPath row]) {
    case ZoneViewTypeCell:
      typeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
      typeCell.textLabel.text = @"Type";
      typeCell.detailTextLabel.text = entry.type;
      cell = typeCell;
      break;
    case ZoneViewDataCell:
      [dataCell release];
      dataCell = [self newEditableCell];
      dataCell.textField.text = entry.data;
      dataCell.textLabel.text = @"Data";
      dataCell.textField.delegate = self;
      [dataCell.textField setAutocorrectionType:UITextAutocorrectionTypeNo];
      cell = dataCell;
      break;
    case ZoneViewTTLCell:
      [timeToLiveCell release];
      timeToLiveCell = [self newEditableCell];
      timeToLiveCell.textField.text = [entry.ttl stringValue];
      timeToLiveCell.textLabel.text = @"TTL";
      timeToLiveCell.textField.delegate = self;
      timeToLiveCell.textField.keyboardType = UIKeyboardTypeNumberPad;
      cell = timeToLiveCell;
      break;
    case ZoneViewPriorityCell:
      [priorityCell release];
      priorityCell = [self newEditableCell];
      priorityCell.textField.text = [entry.priority stringValue];
      priorityCell.textLabel.text = @"Priority";
      priorityCell.textField.delegate = self;
      priorityCell.textField.keyboardType = UIKeyboardTypeNumberPad;
      cell = priorityCell;
      break;
  }
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self hideKeyboard];
  
  if(indexPath.row == ZoneViewTypeCell){
    [self showPicker];
  } else {
    [self hidePicker];
  }

  if (indexPath.row == ZoneViewTTLCell) 
    [timeToLiveCell.textField becomeFirstResponder];
  if(indexPath.row == ZoneViewPriorityCell)
    [priorityCell.textField becomeFirstResponder];
  if(indexPath.row == ZoneViewDataCell)
    [dataCell.textField becomeFirstResponder];
}

#pragma mark Picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return [[self dnsRecordTypes] count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return [[self dnsRecordTypes] objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  typeCell.detailTextLabel.text = [[self dnsRecordTypes] objectAtIndex:row];
  [typeCell setNeedsLayout];
}

#pragma mark textFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [recordsTableView selectRowAtIndexPath:nil animated:NO scrollPosition:0];
  [self hidePicker];
}

@end
