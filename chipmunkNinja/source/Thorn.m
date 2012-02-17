//
//  Thorns.m
//  chipmunkNinja
//
//  Created by Tiago Padua on 16/2/12.
//  Copyright (c) 2012 Terra Networks. All rights reserved.
//

#import "Thorn.h"

@implementation Thorn

- (Thorn*) init:(NSString *)imageFile withWindowSize:(CGSize)windowSize andTreeWidth:(double)treeWidth {
    return [self init:imageFile withWindowSize:windowSize andTreeWidth:treeWidth andPositionRight:FALSE];
}
- (Thorn*) init:(NSString *)imageFile withWindowSize:(CGSize)windowSize andTreeWidth:(double)treeWidth andPositionRight:(BOOL)flipRight {
    self = [CCSprite spriteWithFile:imageFile];
    if (self) {
        if (flipRight) {
            self.flipX = flipRight;
            self.position = ccp(windowSize.width-treeWidth, windowSize.height + self.contentSize.height/2);
        } else {
            self.position = ccp(treeWidth, windowSize.height + self.contentSize.height/2);
        }
        _positionedRight = flipRight;
    }
    return self;
}
-(void)dealloc {
    [super dealloc];
}

-(void) nextFrame:(double)dy {
    self.position = ccp(self.position.x, self.position.y - dy);
}

- (BOOL) isPositionedRight {
    return _positionedRight;
}

@end
