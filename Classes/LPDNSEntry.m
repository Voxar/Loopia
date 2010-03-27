//
//  LPDNSEntry.m
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-03-03.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "LPDNSEntry.h"


@implementation LPDNSEntry

@synthesize type, ttl, priority, data, record_id;

-(id)init
{
  if(![super init]) return nil;
  
  self.type = @"A";
  self.ttl = [NSNumber numberWithInt:3600];
  self.priority = [NSNumber numberWithInt:0];
  self.data = @"127.0.0.1";
  self.record_id = [NSNumber numberWithInt:0];
  
  return self;
}

-(void)dealloc;
{
  self.type = nil;
  self.ttl  = nil;
  self.priority = nil;
  self.data = nil;
  self.record_id = nil;

  [super dealloc];
}

-(BOOL)loadFromRemoteObject:(NSDictionary *)object;
{
  self.type      = [object objectForKey:@"type"];
  self.ttl       = [object objectForKey:@"ttl"];
  self.priority  = [object objectForKey:@"priority"];
  self.data      = [object objectForKey:@"rdata"];
  self.record_id = [object objectForKey:@"record_id"];

  return object != nil;
}

-(NSDictionary *)asRemoteObject;
{
  return [NSDictionary dictionaryWithObjectsAndKeys:
          self.type, @"type", 
          self.ttl, @"ttl", 
          self.priority, @"priority",
          self.data, @"rdata",
          self.record_id, @"record_id",
          nil];
}


@end
