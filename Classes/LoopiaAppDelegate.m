//
//  LoopiaAppDelegate.m
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-02-25.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "LoopiaAppDelegate.h"

#import "LoopiaAPI.h"

@implementation LoopiaAppDelegate

@synthesize api;
@synthesize window;
@synthesize navigationController;

@synthesize accounts;


+(LoopiaAppDelegate*)standardLoopiaAppDelegate;
{
  return (LoopiaAppDelegate*)[[UIApplication sharedApplication] delegate];
}

+(LoopiaAPI*)sharedAPI;
{
  LoopiaAPI *api_ = [[LoopiaAppDelegate standardLoopiaAppDelegate] api];
  if(!api_){
    [[NSException exceptionWithName:@"Loopia API not initialized" reason:@"See LoopiaAppDelegate initAPIWithUsername:password:" userInfo:nil] raise];
  }
  return api_;
}

#pragma mark -
#pragma mark Application lifecycle

-(void)loopiaAPI:(LoopiaAPI*)api respondsToMethod:(NSString *)method withResult:(id)result;
{
  NSLog(@"backgrounded result for %@: %@", method, result);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
  // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
  [window makeKeyAndVisible];
  
  NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:@"accounts"];
  accounts = [[[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy] retain];
  NSLog(@"accounts %@", accounts);
  if(!accounts) accounts = [[NSMutableArray alloc] init];
  NSLog(@"Loaded accounts: %@", accounts);
//  
//  NSLog(@"domains: %@", [api domains]);
//  NSLog(@"subdomains: %@", [api subdomainsForDomain:@"voxar.net"]);
//  NSLog(@"Domain status (voxar.net): %@", [api statusForDomain:@"voxar.net"]);
//  NSLog(@"Domain status (ofnejfnakjenfjkef.net): %@", [api statusForDomain:@"ofnejfnakjenfjkef.net"]);
//  NSLog(@"domain: %@", [api domain:@"voxar.net"]);
//  NSLog(@"zone info: %@", [api zoneRecordsForDomain:@"voxar.se" subdomain:@"www"]);
  
	return YES;
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
  NSLog(@"Saving accounts: %@", accounts);
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accounts];
  [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"accounts"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  NSLog(@"TEMINATED");
}


-(void)setupAPIWithUsername:(NSString *)username password:(NSString *)password;
{
  if(api){
    api.delegate = nil;
    [api release];
    api = nil;
  }
  api = [[LoopiaAPI alloc] init];
  [api setUsername:username password:password];
  api.delegate = self;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
  [api release];
  [accounts release];
	[super dealloc];
}


#pragma mark LoopiaAPIDelegate

-(void)loopiaAPI:(LoopiaAPI*)api respondedWithError:(NSError *)error;
{
  NSLog(@"Application intercepted error: %@ %@", error, [error userInfo]);
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LoopiaAPI Error" message:[[error userInfo] objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}


@end

