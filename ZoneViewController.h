//
//  ZoneViewController.h
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-02-28.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditableDetailCell.h"
#import "Loopia.h"
#import "MBProgressHUD.h"

@class LPDNSEntry;

enum  {
  ZoneViewTypeCell,
  ZoneViewDataCell,
  ZoneViewTTLCell,
  ZoneViewPriorityCell
};

@protocol ZoneViewDelegate

-(void)saveZoneComplete:(LPDNSEntry *)newEntry;

@end


@interface ZoneViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, MBProgressHUDDelegate> {
  LPDNSEntry *entry;
  LPDomain *domain;
  LPSubdomain *subdomain;
  
  IBOutlet UITableView *recordsTableView;
  
  UITableViewCell    *typeCell;
  EditableDetailCell *timeToLiveCell;
  EditableDetailCell *priorityCell;
  EditableDetailCell *dataCell;
  
  MBProgressHUD *saveProgressHud;
  
  IBOutlet UIBarButtonItem *saveButton;
  IBOutlet UIPickerView *typePicker;
  id<ZoneViewDelegate> delegate;
}

@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) LPDNSEntry *entry;
@property (nonatomic, retain) LPDomain *domain;
@property (nonatomic, retain) LPSubdomain *subdomain;

@property (nonatomic, retain) MBProgressHUD *saveProgressHud;

-(id)initWithDNSEntry:(LPDNSEntry*)entry_ forDomain:(LPDomain *)domain_ subdomain:(LPSubdomain *)subdomain_;

-(IBAction)saveAction:(id)sender;



-(void)saveEntry:(LPDNSEntry*)newEntry;
-(void)doneSaveing:(LPDNSEntry *)savedEntry;

- (void)hudWasHidden;

@end
