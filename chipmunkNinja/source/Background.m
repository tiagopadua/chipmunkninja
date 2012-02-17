//
//  Background.m
//  chipmunkNinja
//
//  Created by Tiago Padua on 11/2/12.
//  Copyright (c) 2012 Terra Networks. All rights reserved.
//

#import "Background.h"

@implementation Background

#define BACKGROUND_SPEED_FACTOR 2

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

-(void) nextFrame:(double)dy {
    self.position = ccp(self.position.x, self.position.y - (dy/BACKGROUND_SPEED_FACTOR) );
}

@end
