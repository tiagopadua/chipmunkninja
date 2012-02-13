//
//  Chipmunk.m
//  chipmunkNinja
//
//  Created by Tiago Padua on 12/2/12.
//  Copyright (c) 2012 Terra Networks. All rights reserved.
//

#import "Chipmunk.h"

@implementation Chipmunk

- (Chipmunk*) init:(NSString *)imageFile {
    self = [CCSprite spriteWithFile:imageFile];
    if (self) {
        
    }
    return self;
}

-(void)dealloc {
    [super dealloc];
}

@end
