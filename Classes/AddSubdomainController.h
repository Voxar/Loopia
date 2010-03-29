//
//  AddSubdomainController.h
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-03-27.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Loopia.h"
#import "MBProgressHUD.h"

@class AddSubdomainController;
@protocol AddSubdomainDelegate

-(void)addSubdomain:(AddSubdomainController*)controller savedSubdomain:(LPSubdomain *)subdomain withSuccess:(BOOL)success;

@end


@interface AddSubdomainController : UIViewController <MBProgressHUDDelegate, UITextFieldDelegate> {
  id<AddSubdomainDelegate> delegate;
  LPDomain *domain;
  MBProgressHUD *saveProgressHud;
  
  IBOutlet UITextField *textField;
}

@property (nonatomic, assign) id<AddSubdomainDelegate> delegate;
@property (nonatomic, retain) MBProgressHUD *saveProgressHud;

-(id)initWithDomain:(LPDomain *)domain;

-(void)save;
-(void)saveComplete:(LPSubdomain *)subdomain;
- (void)hudWasHidden;

@end
