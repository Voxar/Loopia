//
//  LPDNSEntry.h
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-03-03.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPObject.h"

@interface LPDNSEntry : LPObject {
  NSString *type;
  NSNumber *ttl;
  NSNumber *priority;
  NSString *data;
  NSNumber *record_id;
}

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSNumber *ttl;
@property (nonatomic, retain) NSNumber *priority;
@property (nonatomic, retain) NSString *data;
@property (nonatomic, retain) NSNumber *record_id;

@end
