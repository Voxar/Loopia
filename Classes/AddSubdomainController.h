//
//  AddSubdomainController.h
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-03-27.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Loopia.h"

@class AddSubdomainController;
@protocol AddSubdomainDelegate

-(void)addSubdomain:(AddSubdomainController*)controller savedSubdomain:(LPSubdomain *)subdomain withSuccess:(BOOL)success;

@end


@interface AddSubdomainController : UIViewController {
  id<AddSubdomainDelegate> delegate;
  LPDomain *domain;
  
  IBOutlet UITextField *textField;
}

@property (nonatomic, assign) id<AddSubdomainDelegate> delegate;

-(id)initWithDomain:(LPDomain *)domain;

@end
