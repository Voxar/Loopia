//
//  LPSubdomain.m
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-03-03.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "LPSubdomain.h"


@implementation LPSubdomain

@synthesize name;

-(id)init
{
  if(![super init]) return nil;
  
  self.name = @"unnamed";
  
  return self;
}

-(void)dealloc;
{
  self.name = nil;
  
  [super dealloc];
}

-(BOOL)loadFromRemoteObject:(NSString *)object;
{
  self.name = object;
  
  return object != nil;
}

-(NSString *)asRemoteObject;
{
  return self.name;
}

@end
