//
//  AddZoneViewController.m
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-03-27.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "AddZoneViewController.h"
#import "LoopiaAppDelegate.h"


@implementation AddZoneViewController

-(void)viewDidLoad;
{
  [super viewDidLoad];
  
  self.title = @"New record";
  
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
  self.navigationItem.leftBarButtonItem = cancelButton;
  [cancelButton release];
  
//  UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
//  self.navigationItem.leftBarButtonItem = saveButton;
//  [saveButton release];
}


-(void)cancelAction;
{
  [self dismissModalViewControllerAnimated:YES];
  [delegate saveZoneComplete:nil];
}


-(void)doneSaveing:(LPDNSEntry *)savedEntry; //override
{
  [self dismissModalViewControllerAnimated:YES];
  [delegate saveZoneComplete:savedEntry];
}

-(void)backgroundSave; //override
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  BOOL success = [[LoopiaAppDelegate sharedAPI] addZoneRecord:entry forDomainName:domain.name subdomainName:subdomain.name];
  if(success)
    [self performSelectorOnMainThread:@selector(doneSaveing:) withObject:entry waitUntilDone:NO];
  else
    [self performSelectorOnMainThread:@selector(doneSaveing:) withObject:nil waitUntilDone:NO];
  [pool release];
}


@end
