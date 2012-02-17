//
//  Thorns.h
//  chipmunkNinja
//
//  Created by Tiago Padua on 16/2/12.
//  Copyright (c) 2012 Terra Networks. All rights reserved.
//

#import "cocos2d.h"

@interface Thorn : CCSprite {
@private
    BOOL _positionedRight;
}

- (Thorn*) init:(NSString *)imageFile withWindowSize:(CGSize)windowSize andTreeWidth:(double)treeWidth;
- (Thorn*) init:(NSString *)imageFile withWindowSize:(CGSize)windowSize andTreeWidth:(double)treeWidth andPositionRight:(BOOL)flipRight;
- (void) dealloc;

-(void) nextFrame:(double)dy;
- (BOOL) isPositionedRight;

@end
