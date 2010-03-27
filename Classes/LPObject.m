//
//  LPObject.m
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-03-03.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "LPObject.h"


@implementation LPObject

- (void)encodeWithCoder:(NSCoder *)aCoder;
{
  [aCoder encodeObject:[self asRemoteObject] forKey:@"remoteObject"];
}

- (id)initWithCoder:(NSCoder *)aDecoder;
{
  NSLog(@"oooo");
  return [self initWithRemoteObject:[aDecoder decodeObjectForKey:@"remoteObject"]];
}

-(id)initWithRemoteObject:(id)object;
{
  if(![super init]) return nil;
  
  if(![self loadFromRemoteObject:object]){
    [self release];
    self = nil;
    return nil;
  }
  
  return self;
}

-(BOOL)loadFromRemoteObject:(id)object;
{
  [NSException raise:@"Not implemented" format:@"Please override loadFromRemoteObject:"];
  return NO;
}

-(NSDictionary*)asRemoteObject;
{
  [NSException raise:@"Not implemented" format:@"Please override asRemoteObject"];
  return nil;
}

-(NSString *)description;
{
  return [[self asRemoteObject] description];
}

@end
