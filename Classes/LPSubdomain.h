//
//  LPSubdomain.h
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-03-03.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPObject.h"

@interface LPSubdomain : LPObject {
  NSString *name;
}

@property (nonatomic, retain) NSString *name;

@end
