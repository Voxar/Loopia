//
//  LPAccount.h
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-03-03.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPObject.h"

@interface LPAccount : LPObject {
  NSString *username;
  NSString *password;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

@end
