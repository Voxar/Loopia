//
//  LPDomain.h
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-03-03.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPObject.h"

@interface LPDomain : LPObject {
  NSString *name;
  BOOL paid;
  BOOL registered;
  NSInteger referenceNr;
  double unpaidAmount;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) BOOL paid;
@property (nonatomic, assign) BOOL registered;
@property (nonatomic, assign) NSInteger referenceNr;
@property (nonatomic, assign) double unpaidAmount;
@property (nonatomic, readonly) NSString *stringReferenceNr;

@end
