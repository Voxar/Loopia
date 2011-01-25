//
//  AddDomainViewController.h
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-06-09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AddDomainViewController : UIViewController <UITextFieldDelegate> {
  IBOutlet UITextField *domainField;
  IBOutlet UIButton *button;
  
  BOOL isFree;
  
  MBProgressHUD *hud;
  
  id delegate;
}

@property (nonatomic, retain) MBProgressHUD *hud;

-(id)initWithDelegate:(id)delegate_;

-(MBProgressHUD*)createHudWithText:(NSString *)text;

-(IBAction)buttonAction:(id)sender;

-(void)registerDomain:(NSString *)domainName;
-(void)checkDomain:(NSString *)domainName;

-(void)registerComplete;

-(void)cancelAction;

@end
