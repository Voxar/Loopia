//
//  ZoneViewController.h
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-02-28.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditableDetailCell.h"

@class LPDNSEntry;

enum  {
  ZoneViewTypeCell,
  ZoneViewDataCell,
  ZoneViewTTLCell,
  ZoneViewPriorityCell
};

@interface ZoneViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate> {
  LPDNSEntry *entry;
  NSString *domain;
  NSString *subdomain;
  
  IBOutlet UITableView *recordsTableView;
  
  UITableViewCell    *typeCell;
  EditableDetailCell *timeToLiveCell;
  EditableDetailCell *priorityCell;
  EditableDetailCell *dataCell;
  
  IBOutlet UIBarButtonItem *saveButton;
  IBOutlet UIPickerView *typePicker;
}

@property (nonatomic, retain) LPDNSEntry *entry;
@property (nonatomic, retain) NSString *domain;
@property (nonatomic, retain) NSString *subdomain;

-(id)initWithDNSEntry:(LPDNSEntry*)entry_ forDomain:(NSString *)domain_ subdomain:(NSString *)subdomain_;

-(IBAction)saveAction:(id)sender;

@end
