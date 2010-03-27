//
//  AccountSelectView.h
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-03-03.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabeViewControllerWithBackgroundLoading.h"

@class LPAccount;
@interface AccountSelectViewController : TabeViewControllerWithBackgroundLoading {
  NSMutableArray *accounts;
  LPAccount *newAccount;
}

@property (nonatomic, retain) NSMutableArray *accounts;

-(void)addAccount;
-(void)editAccount:(LPAccount*)account modal:(BOOL)modal;

@end