//
//  Tree.m
//  chipmunkNinja
//
//  Created by Tiago Padua on 12/2/12.
//  Copyright (c) 2012 Terra Networks. All rights reserved.
//

#import "Tree.h"

@implementation Tree

-(Tree*) init:(NSString*)imageFile withWindowSize:(CGSize)windowSize andHeightMultiplier:(double)heightTimes {
    return [self init:imageFile withWindowSize:windowSize andHeightMultiplier:heightTimes andPositionRight:FALSE];
}
-(Tree*) init:(NSString*)imageFile withWindowSize:(CGSize)windowSize andHeightMultiplier:(double)heightTimes andPositionRight:(BOOL)flipRight {
    self = [CCSprite spriteWithFile:imageFile rect:CGRectMake(0, 0, 43, windowSize.height*heightTimes)];
    self.flipX = flipRight;
    if (self) {
        self.anchorPoint = ccp(0,0);
        self.position = ccp(flipRight ? windowSize.width-self.contentSize.width : 0, 0);
        ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
        [self.texture setTexParameters:&params];
    }
    return self;
}
-(void)dealloc {
    [super dealloc];
}

@end
