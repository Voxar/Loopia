//
//  LoopiaAPI.h
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-02-27.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPDNSEntry;

extern NSString const * LoopiaDomainStatusOK;
extern NSString const * LoopiaDomainStatusOCCUPIED;
extern NSString const * LoopiaDomainStatusAUTH_ERROR;
extern NSString const * LoopiaDomainStatusRATE_LIMITED;
extern NSString const * LoopiaDomainStatusBAD_INDATA;
extern NSString const * LoopiaDomainStatusUNKNOWN_ERROR;

extern NSString const * LoopiaDomainAccountTypeLOOPIADNS;
extern NSString const * LoopiaDomainAccountTypeHOSTING_PRIVATE;
extern NSString const * LoopiaDomainAccountTypeHOSTING_BUSINESS;

extern NSString const * LoopiaDomainDomainConfigurationNO_CONFIG;
extern NSString const * LoopiaDomainDomainConfigurationPARKING;
extern NSString const * LoopiaDomainDomainConfigurationHOSTING_UNIX;
extern NSString const * LoopiaDomainDomainConfigurationHOSTING_AUTOBAHN;
extern NSString const * LoopiaDomainDomainConfigurationHOSTING_WINDOWS;

@class LoopiaAPI;
@protocol LoopiaAPIDelegate
@optional
-(void)loopiaAPI:(LoopiaAPI*)api respondedToMethod:(NSString *)method withResult:(id)result;
-(void)loopiaAPI:(LoopiaAPI*)api respondedWithError:(NSError *)error;

@end


@interface LoopiaAPI : NSObject {
  NSString *username;
  NSString *password;
  NSString *customerNumber;
  NSURL *apiEndpointURL;
  
  id<LoopiaAPIDelegate, NSObject> delegate;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *customerNumber;
@property (nonatomic, retain) NSURL *apiEndpointURL;
@property (nonatomic, assign) id<LoopiaAPIDelegate, NSObject> delegate;

//-(id)initWithUsername:(NSString*)user password:(NSString*)pass;
-(id)init;

-(void)setUsername:(NSString *)username_ password:(NSString *)password_;

-(NSDictionary*) domain:(NSString *)domainName;
-(NSArray *)domains;
-(NSString *)statusForDomain:(NSString *)domainName;
-(NSArray *)subdomainsForDomain:(NSString *)domain;
-(NSArray *)zoneRecordsForDomain:(NSString*)domain subdomain:(NSString *)subdomain; 
-(BOOL)updateZoneRecord:(LPDNSEntry *)record forDomain:(NSString *)domain subdomain:(NSString*)subdomain;
/* not yet implemented:
addDomainToAccount
addSubdomain
addZoneRecord
payInvoiceUsingCredits
removeSubdomain
removeZoneRecord

*/
@end
