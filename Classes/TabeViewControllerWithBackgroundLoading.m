//
//  UITableViewController+BackgroundLoadingNext.m
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-02-28.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "TabeViewControllerWithBackgroundLoading.h"

@interface TabeViewControllerWithBackgroundLoading (private)
-(void)loadContentForNextPagePoolWrapperWithObject:(id)args;
-(void)stopLoading;
-(void)doneLoadingWithObject:(id)args;
@end
@implementation TabeViewControllerWithBackgroundLoading (private)
-(void)loadContentForNextPagePoolWrapperWithObject:(id)args;
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  id result = [self loadContentForNextPageWithObject:args];
  [self doneLoadingWithObject:result];
  [pool release];
}
-(void)stopLoading;
{
  if(self.cellLoading){
    [cellLoading setAccessoryView:nil];
    self.cellLoading = nil;
  }
}
-(void)doneLoadingWithObject:(id)args;
{
  [self stopLoading];
  [self performSelectorOnMainThread:@selector(navigateToNextPageWithObject:) withObject:args waitUntilDone:NO];
}
@end


@implementation TabeViewControllerWithBackgroundLoading

@synthesize cellLoading;


-(id)loadContentForNextPageWithObject:(id)args;
{
  NSLog(@"Expected you to overload loadContentForNextPageWithObject:");
  return nil;
}

-(void)navigateToNextPageWithObject:(id)args;
{
  NSLog(@"Expected you to overload navigateToNextPageWithObject:");
}

-(void)startLoadingCell:(UITableViewCell*)cell withObject:(id)args;
{
  if(self.cellLoading) 
    [self stopLoading];
  self.cellLoading = cell;
  UIActivityIndicatorView *spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
  [cell setAccessoryView:spinner];
  [spinner startAnimating];
  [self performSelectorInBackground:@selector(loadContentForNextPagePoolWrapperWithObject:) withObject:args];
}


#pragma mark Standard navigation paths
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  [self startLoadingCell:cell withObject:indexPath];
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(cellLoading)
    return nil;
  return indexPath;
}

@end
