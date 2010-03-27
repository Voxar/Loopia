//
//  AccountEditViewController.h
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-03-04.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Loopia.h"

@interface AccountEditViewController : UIViewController <UITextFieldDelegate> {
  LPAccount *account;
  
  IBOutlet UITextField *usernameField;
  IBOutlet UITextField *passwordField;
}

@property (nonatomic, retain) LPAccount *account;

-(id)initWithAccount:(LPAccount*)account_;

@end
