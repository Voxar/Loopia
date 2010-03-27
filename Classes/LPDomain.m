//
//  LPDomain.m
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-03-03.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "LPDomain.h"


@implementation LPDomain

@synthesize name, paid, registered, referenceNr, unpaidAmount;

-(id)init
{
  if(![super init]) return nil;
  
  self.name = @"unnamed";
  self.paid = NO;
  self.registered = NO;
  self.referenceNr = 0;
  self.unpaidAmount = 0.0;
  
  return self;
}

-(void)dealloc;
{
  self.name = nil;
  
  [super dealloc];
}

-(BOOL)loadFromRemoteObject:(id)object;
{
  self.name         = [object objectForKey:@"domain"];
  self.paid         = [[object objectForKey:@"paid"] intValue] == 1;
  self.registered   = [[object objectForKey:@"registered"] intValue] == 1;
  self.referenceNr  = [[object objectForKey:@"reference_no"] intValue];
  self.unpaidAmount = [[object objectForKey:@"unpaid_amount"] doubleValue];
  
  return object != nil;
}

-(NSDictionary *)asRemoteObject;
{
  return [NSDictionary dictionaryWithObjectsAndKeys:
          self.name, @"domain", 
          [NSNumber numberWithInt:(self.paid ? 1 : 0)], @"paid", 
          [NSNumber numberWithInt:(self.registered ? 1 : 0)], @"registered",
          [NSNumber numberWithInt:self.referenceNr], @"reference_no",
          [NSNumber numberWithDouble:self.unpaidAmount], @"unpaid_amount",
          nil];
}


@end
