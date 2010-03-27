//
//  DomainViewController.h
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-02-28.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoopiaAPI.h"

#import "TabeViewControllerWithBackgroundLoading.h"

@interface DomainViewController : TabeViewControllerWithBackgroundLoading {
  NSDictionary *domain;
  NSArray *subdomains;
  
  IBOutlet UILabel *statusLabel;
  IBOutlet UIButton *payButton;
}

@property (nonatomic, retain) NSDictionary *domain;
@property (nonatomic, retain) NSArray *subdomains;

-(id)initWithDomain:(NSDictionary *)domain_ subdomains:(NSArray *)subdomains_;

-(IBAction)payButtonAction:(id)sender;

@end
