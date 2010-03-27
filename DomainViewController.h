//
//  DomainViewController.h
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-02-28.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Loopia.h"

#import "TabeViewControllerWithBackgroundLoading.h"
#import "AddSubdomainController.h"

@interface DomainViewController : TabeViewControllerWithBackgroundLoading <AddSubdomainDelegate> {
  LPDomain *domain;
  NSArray *subdomains;
  
  IBOutlet UILabel *statusLabel;
  IBOutlet UIButton *payButton;
}

@property (nonatomic, retain) LPDomain *domain;
@property (nonatomic, retain) NSArray *subdomains;

-(id)initWithDomain:(LPDomain *)domain_ subdomains:(NSArray *)subdomains_;

-(IBAction)payButtonAction:(id)sender;

-(void)addSubdomain;
@end
