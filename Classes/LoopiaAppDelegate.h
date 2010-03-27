//
//  LoopiaAppDelegate.h
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-02-25.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoopiaAPI.h"

@interface LoopiaAppDelegate : NSObject <UIApplicationDelegate, LoopiaAPIDelegate> {
  UIWindow *window;
  UINavigationController *navigationController;
  LoopiaAPI *api;
  NSMutableArray *accounts;
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, readonly) LoopiaAPI *api;

@property (nonatomic, readonly) NSMutableArray *accounts;


+(LoopiaAppDelegate*)standardLoopiaAppDelegate;
+(LoopiaAPI*)sharedAPI;

-(void)setupAPIWithUsername:(NSString *)username password:(NSString *)password;

@end

