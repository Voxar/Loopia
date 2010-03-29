//
//  LoopiaAPI.m
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-02-27.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "LoopiaAPI.h"

#import "XMLRPCConnection.h"
#import "XMLRPCRequest.h"
#import "XMLRPCResponse.h"
#import "LPDNSEntry.h"
#import "LPDomain.h"
#import "LPSubdomain.h"

NSString const * LoopiaDomainStatusOK = @"OK";
NSString const * LoopiaDomainStatusOCCUPIED = @"OCCUPIED";
NSString const * LoopiaDomainStatusAUTH_ERROR = @"AUTH_ERROR";
NSString const * LoopiaDomainStatusRATE_LIMITED = @"RATE_LIMITED";
NSString const * LoopiaDomainStatusBAD_INDATA = @"BAD_INDATA";
NSString const * LoopiaDomainStatusUNKNOWN_ERROR = @"UNKNOWN_ERROR";

NSString const * LoopiaDomainAccountTypeLOOPIADNS = @"LOOPIADNS";
NSString const * LoopiaDomainAccountTypeHOSTING_PRIVATE = @"HOSTING_PRIVATE";
NSString const * LoopiaDomainAccountTypeHOSTING_BUSINESS = @"HOSTING_BUSINESS";

NSString const * LoopiaDomainDomainConfigurationNO_CONFIG = @"NO_CONFIG";
NSString const * LoopiaDomainDomainConfigurationPARKING = @"PARKING";
NSString const * LoopiaDomainDomainConfigurationHOSTING_UNIX = @"HOSTING_UNIX";
NSString const * LoopiaDomainDomainConfigurationHOSTING_AUTOBAHN = @"HOSTING_AUTOBAHN";
NSString const * LoopiaDomainDomainConfigurationHOSTING_WINDOWS = @"HOSTING_WINDOWS";

@interface LoopiaAPI (private)
-(BOOL)shouldUseCustomerNumberForMethod:(NSString *)method;
-(id)call:(NSString *)method args:(NSArray *)args;
-(NSError *)checkErrors:(XMLRPCResponse *)response;
@end

@implementation LoopiaAPI (private)
-(BOOL)shouldUseCustomerNumberForMethod:(NSString *)method;
{
  NSArray *methodsThatCanUseCustomerNumber = [NSArray arrayWithObjects:
                                              @"addDomainToAccount",
                                              @"addSubdomain",
                                              @"addZoneRecord",
                                              @"getDomain",
                                              @"getDomains",
                                              @"getSubdomains",
                                              @"getZoneRecords",
                                              @"payInvoiceUsingCredits",
                                              @"removeSubdomain",
                                              @"removeZoneRecord",
                                              @"updateZoneRecord",
                                              nil];
  return [methodsThatCanUseCustomerNumber containsObject:method];
}
-(void)respondToCall:(NSDictionary*)options;
{
  NSString *method = [options objectForKey:@"method"];
  XMLRPCResponse *response = [options objectForKey:@"response"];
  [delegate loopiaAPI:self respondedToMethod:method withResult:[response object]];
}

-(void)backgroundCall:(NSDictionary *)options;
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  
  NSString *method = [options objectForKey:@"method"];
  NSArray *arguments = [options objectForKey:@"arguments"];
  
  XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithHost:apiEndpointURL];
  [request setMethod:method withObjects:arguments];
  XMLRPCResponse *response = [XMLRPCConnection sendSynchronousXMLRPCRequest:request];
  NSLog(@"response: %@", response);
  
  if(![self checkErrors:response]){
      
    NSDictionary *resultOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                   method, @"method",
                                   response, @"response",
                                   nil];
    
    [self performSelectorOnMainThread:@selector(respondToCall:) withObject:resultOptions waitUntilDone:NO];
  }
  [pool release];
}

-(NSError *)checkErrors:(XMLRPCResponse *)response;
{
  NSError *error = nil;
  if([response isKindOfClass:[NSError class]]) {
    error = (NSError*)response;
    response = nil;
  }
  
  if(response)
    if([response isFault]) {
      error = [NSError errorWithDomain:@"se.loopia" 
                                    code:[[response code] intValue] 
                                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[response fault], @"message", [response object], @"object", nil]];
    } else {
      id obj = [response object];
      if([obj isEqual:LoopiaDomainStatusAUTH_ERROR] ||
         ([obj respondsToSelector:@selector(containsObject:)] && [obj containsObject:LoopiaDomainStatusAUTH_ERROR])){
           error = [NSError errorWithDomain:@"se.loopia" 
                                         code:[[response code] intValue] 
                                     userInfo:[NSDictionary dictionaryWithObject:LoopiaDomainStatusAUTH_ERROR forKey:@"message"]];
      }
    }
  if(error){
    NSLog(@"ERROR!");
    if(delegate && [delegate respondsToSelector:@selector(loopiaAPI:respondedWithError:)])
      [delegate loopiaAPI:self respondedWithError:error];
  }

  return error;
}

-(id)call:(NSString *)method args:(NSArray *)args;
{
  if(!username || !password){
    [[NSException exceptionWithName:@"Authorization required" reason:@"Must set username and password" userInfo:nil] raise];
  }
  
  NSMutableArray *arguments = [NSMutableArray arrayWithObjects:username, password, nil];
  
  if(customerNumber && [self shouldUseCustomerNumberForMethod:method])
    [arguments addObject:customerNumber];

  if(args)
    [arguments addObjectsFromArray:args];
  
  if(delegate && [delegate respondsToSelector:@selector(loopiaAPI:respondedToMethod:withResult:)]){
    NSLog(@"backgrounding the job");
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             method, @"method",
                             arguments, @"arguments",
                             nil];
    [self performSelectorInBackground:@selector(backgroundCall:) withObject:options];
    return nil;
  } else {
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithHost:apiEndpointURL];
    [request setMethod:method withObjects:arguments];
    XMLRPCResponse *result = [XMLRPCConnection sendSynchronousXMLRPCRequest:request];
    NSLog(@"response: %@", [result object]);
    if([self checkErrors:result]){
      return nil;
    }
    return [result object];
  }
  return nil;
}
@end


@implementation LoopiaAPI

@synthesize username, password, customerNumber, apiEndpointURL, delegate;


-(id)init;
{
  if(![super init]) return nil;
  
  self.apiEndpointURL = [NSURL URLWithString:@"https://api.loopia.se/RPCSERV"];
  self.customerNumber = nil;
  
  return self;
}

-(void)setUsername:(NSString *)username_ password:(NSString *)password_;
{
  self.username = username_;
  self.password = password_;
  if ([username_ isEqual:@"test@loopiaapi"]) {
    self.apiEndpointURL = [NSURL URLWithString:@"http://localhost:8080"];
  }
}

-(void)dealloc;
{
  self.username = nil;
  self.password = nil;
  self.apiEndpointURL = nil;
  self.customerNumber = nil;
  [super dealloc];
}

-(LPDomain*) domainForDomainName:(NSString *)domainName;
{
  NSDictionary *domainInfo = [self call:@"getDomain" args:[NSArray arrayWithObject: domainName]];
  return [[[LPDomain alloc] initWithRemoteObject:domainInfo] autorelease];
}

-(NSArray *)domains;
{
  NSArray *domainInfos = [self call:@"getDomains" args:nil];
  NSMutableArray *domains = [NSMutableArray array];
  for(NSDictionary *info in domainInfos){
    LPDomain *domain = [[LPDomain alloc] initWithRemoteObject:info];
    [domains addObject:domain];
  }
  return domains;
}

-(NSString *) statusForDomainName:(NSString *)domainName;
{
  return (NSString *)[self call:@"domainIsFree" args:[NSArray arrayWithObject:domainName]];
}

-(NSArray *)subdomainsForDomainName:(NSString *)domain;
{
  NSArray *infoArray = [self call:@"getSubdomains" args:[NSArray arrayWithObject:domain]];
  NSMutableArray *subdomains = [NSMutableArray array];
  for(NSString *subdomainName in infoArray){
    LPSubdomain *subdomain = [[LPSubdomain alloc] initWithRemoteObject:subdomainName];
    [subdomains addObject:subdomain];
    [subdomain release];
  }
  return subdomains;
}

-(NSArray *)zoneRecordsForDomainName:(NSString*)domain subdomainName:(NSString *)subdomain;
{
  NSArray *infoArray = [self call:@"getZoneRecords" args:[NSArray arrayWithObjects:domain, subdomain, nil]];
  NSMutableArray *records = [NSMutableArray array];
  for(NSDictionary *dict in infoArray){
    LPDNSEntry *entry = [[LPDNSEntry alloc] initWithRemoteObject:dict];
    [records addObject:entry];
    [entry release];
  }
  return records;
}

-(BOOL)updateZoneRecord:(LPDNSEntry *)record forDomainName:(NSString *)domain subdomainName:(NSString*)subdomain;
{
  id ret = [self call:@"updateZoneRecord" args:[NSArray arrayWithObjects:domain, subdomain, [record asRemoteObject], nil]];
  NSLog(@"updateZoneRecord returned %@", ret);
  return ret != nil;
}

-(BOOL)addZoneRecord:(LPDNSEntry *)record forDomainName:(NSString *)domain subdomainName:(NSString*)subdomain;
{
  id ret = [self call:@"addZoneRecord" args:[NSArray arrayWithObjects:domain, subdomain, [record asRemoteObject], nil]];
  NSLog(@"addZoneRecord returned %@", ret);
  return ret != nil;
}

-(BOOL)addSubdomainName:(NSString *)subdomain forDomainName:(NSString *)domain;
{
  id ret = [self call:@"addSubdomain" args:[NSArray arrayWithObjects:domain, subdomain, nil]];
  NSLog(@"addSubdomain returned %@", ret);
  return ret != nil;
}

-(BOOL)removeSubdomainName:(NSString*)subdomain forDomainName:(NSString *)domain;
{
  id ret = [self call:@"removeSubdomain" args:[NSArray arrayWithObjects:domain, subdomain, nil]];
  NSLog(@"removeSubdomainName returned %@", ret);
  return ret != nil;
}

-(BOOL)removeZoneRecord:(LPDNSEntry*)zone forDomainName:(NSString *)domainName subdomainName:(NSString *)subdomainName;
{
  id ret = [self call:@"removeZoneRecord" args:[NSArray arrayWithObjects:domainName, subdomainName, zone.record_id, nil]];
  NSLog(@"removeZoneRecord returned %@", ret);
  return ret != nil;
}

-(BOOL)payInvoiceWithRefNr:(NSString *)refNr;
{
  id ret = [self call:@"payInvoiceUsingCredits" args:[NSArray arrayWithObjects:refNr, nil]];
  NSLog(@"payInvoiceUsingCredits returned %@", ret);
  return ret != nil;
}

@end
