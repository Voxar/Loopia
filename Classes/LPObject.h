//
//  LPObject.h
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-03-03.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LPObject : NSObject <NSCoding> {

}

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

-(id)initWithRemoteObject:(NSDictionary *)object;

-(BOOL)loadFromRemoteObject:(NSDictionary *)object;
-(NSDictionary*)asRemoteObject;



@end
