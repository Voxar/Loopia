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

-(void)showHelpView;
{
  UIViewController *webController = [[UIViewController alloc] initWithNibName:@"WebView" bundle:nil];
  helpView = [webController retain];
  
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"manual.html" ofType:nil]]];
  [(UIWebView*)webController.view loadRequest:request];
  UINavigationController *webNav = [[UINavigationController alloc] initWithRootViewController:webController];
  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeModal)];
  webController.navigationItem.rightBarButtonItem = doneButton;
  [navigationController presentModalViewController:webNav animated:YES];
  [webController release];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
  // Override point for customization after app launch    
	
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

  [userDefaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithBool:YES], @"firstRun",
                                  nil]];
  
  NSData *data = [userDefaults dataForKey:@"accounts"];
  accounts = [[[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy] retain];
  NSLog(@"accounts %@", accounts);
  if(!accounts) accounts = [[NSMutableArray alloc] init];
  NSLog(@"Loaded accounts: %@", accounts);
  
  
  [window addSubview:[navigationController view]];
  [window makeKeyAndVisible];
  
  BOOL firstRun = [userDefaults  boolForKey:@"firstRun"];
  NSLog(@"FristRun? %d", firstRun);
  [userDefaults setBool:NO forKey:@"firstRun"];
  if(firstRun){
    [self showHelpView];
  }

  
	return YES;
}

-(void)closeModal;
{
  [helpView dismissModalViewControllerAnimated:YES];
  [helpView release];
  helpView = nil;
}


-(void)saveAccounts{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSLog(@"Saving accounts: %@", accounts);
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accounts];
  [userDefaults setObject:data forKey:@"accounts"];
  [userDefaults synchronize];
}

-(void)applicationWillResignActive:(UIApplication *)application{
  [self saveAccounts];
}
- (void)applicationWillTerminate:(UIApplication *)application {
  [self saveAccounts];
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
  
#ifdef DEBUG
  if ([username isEqual:@"test@loopiaapi"]) {
    api.apiEndpointURL = [NSURL URLWithString:@"http://localhost:8080"];
  }
#endif
  
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
  NSString *errorMsg = [[error userInfo] objectForKey:@"message"];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LoopiaAPI Error" message:errorMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}


@end

