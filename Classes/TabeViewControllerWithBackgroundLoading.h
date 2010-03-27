//
//  UITableViewController+BackgroundLoadingNext.h
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-02-28.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TabeViewControllerWithBackgroundLoading : UITableViewController {
  UITableViewCell *cellLoading;
}

@property (retain) UITableViewCell *cellLoading;

-(void)startLoadingCell:(UITableViewCell*)cell withObject:(id)args;

-(id)loadContentForNextPageWithObject:(id)args;
-(void)navigateToNextPageWithObject:(id)args;

@end
