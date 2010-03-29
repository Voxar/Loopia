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
#import "MBProgressHUD.h"

@interface DomainViewController : TabeViewControllerWithBackgroundLoading <AddSubdomainDelegate, MBProgressHUDDelegate> {
  LPDomain *domain;
  NSArray *subdomains;
  
  MBProgressHUD *progressHud;
  
  IBOutlet UILabel *statusLabel;
  IBOutlet UIButton *payButton;
}

@property (nonatomic, retain) LPDomain *domain;
@property (nonatomic, retain) NSArray *subdomains;
@property (nonatomic, retain) MBProgressHUD *progressHud;

-(id)initWithDomain:(LPDomain *)domain_ subdomains:(NSArray *)subdomains_;

-(IBAction)payButtonAction:(id)sender;

-(void)addSubdomain;
-(void)removeSubdomain:(LPSubdomain *)subdomain;
-(void)didRemoveSubdomain:(LPSubdomain *)subdomain;

- (void)hudWasHidden;

@end
