//
//  main.m
//  Loopia
//
//  Created by Patrik Sjöberg on 2010-02-25.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
