//
//  ZoneInfoController.h
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-02-28.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Loopia.h"
#import "MBProgressHUD.h"

@class LPDNSEntry;
@interface SubDomainDetailViewController : UITableViewController {
  LPDomain *domain;
  LPSubdomain *subdomain;
  NSArray *zoneInfoArray;
  
  MBProgressHUD *progressHud;
}

@property (nonatomic, retain) LPDomain *domain;
@property (nonatomic, retain) LPSubdomain *subdomain;
@property (nonatomic, retain) NSArray *zoneInfoArray;
@property (nonatomic, retain) MBProgressHUD *progressHud;

-(id)initWithDomain:(LPDomain *)domain_ subdomain:(LPSubdomain *)subdomain_ zones:(NSArray *)zoneInfoArray_;


-(void)removeEntry:(LPDNSEntry*)entry;
-(void)didRemoveEntry:(LPDNSEntry*)entry;

@end
