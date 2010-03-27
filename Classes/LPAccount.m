//
//  LPAccount.m
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-03-03.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "LPAccount.h"


@implementation LPAccount

@synthesize username, password;

-(id)init
{
  if(![super init]) return nil;
  
  self.username = @"";
  self.password = @"";
  
  return self;
}

-(void)dealloc;
{
  self.username = nil;
  self.password = nil;
  [super dealloc];
}

-(BOOL)loadFromRemoteObject:(NSDictionary *)object;
{
  self.username = [object objectForKey:@"username"];
  self.password = [object objectForKey:@"password"];
  NSLog(@"user: %@ pass: %@ obj: %@", username, password, object);
  return self.username && self.password;
}

-(NSDictionary *)asRemoteObject;
{
  NSLog(@"account serializing");
  return [NSDictionary dictionaryWithObjectsAndKeys:self.username, @"username", self.password, @"password", nil];
}

@end
