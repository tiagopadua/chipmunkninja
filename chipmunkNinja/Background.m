//
//  Background.m
//  chipmunkNinja
//
//  Created by Tiago Padua on 11/2/12.
//  Copyright (c) 2012 Terra Networks. All rights reserved.
//

#import "Background.h"

@implementation Background

-(Background*) init:(NSString*)imageFile withWindowSize:(CGSize)windowSize andHeightMultiplier:(double)heightTimes {
    self = [CCSprite spriteWithFile:imageFile rect:CGRectMake(0, 0, windowSize.width, windowSize.height*heightTimes)];
    if (self) {
        self.anchorPoint = ccp(0,0);
        self.position = ccp(0, 0);
        ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
        [self.texture setTexParameters:&params];
    }
    return self;
}
-(void)dealloc {
    [super dealloc];
}

@end
