//
//  RootViewController.h
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-02-25.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoopiaAPI.h"
#import "TabeViewControllerWithBackgroundLoading.h"

@interface DomainSelectViewController : TabeViewControllerWithBackgroundLoading {
  NSArray *domains;
}

@property (nonatomic, retain) NSArray *domains;

-(id)initWithDomains:(NSArray *)domains_;

@end
