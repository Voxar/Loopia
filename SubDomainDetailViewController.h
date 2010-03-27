//
//  ZoneInfoController.h
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-02-28.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SubDomainDetailViewController : UITableViewController {
  NSString *domainName;
  NSString *subdomain;
  NSArray *zoneInfoArray;
}

@property (nonatomic, retain) NSString *domainName;
@property (nonatomic, retain) NSString *subdomain;
@property (nonatomic, retain) NSArray *zoneInfoArray;

-(id)initWithDomainName:(NSString *)domain_ subdomain:(NSString *)subdomain_ zoneInfo:(NSArray *)zoneInfoArray_;

@end
