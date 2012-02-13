//
//  Level.h
//  chipmunkNinja
//
//  Created by Tiago Padua on 11/2/12.
//  Copyright (c) 2012 Terra Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Tree.h"
#import "Background.h"
#import "Chipmunk.h"

#define BACKGROUND_SPEED_FACTOR 2.0f

@interface Level : NSObject {
@private
    double _GRAVITY;
    double _JUMP_POWER_START;
    double _JUMP_HOLD_FACTOR;
    double _VEL_SLIDE;
    double _VEL_X;
    double _VEL_X_HOLD_FACTOR;
    double _LEVEL_HEIGHT;

    Background *_background;
    Chipmunk *_chipmunk;
    Tree *_treeLeft;
    Tree *_treeRight;
}

- (Level*)init:(NSString*)propertyFile withWindowSize:(CGSize)windowSize;
- (void)dealloc;

- (Background*) getBackground;
- (Chipmunk*) getChipmunk;
- (Tree*) getTreeLeft;
- (Tree*) getTreeRight;

- (double) GRAVITY;
- (double) JUMP_POWER_START;
- (double) JUMP_HOLD_FACTOR;
- (double) VEL_SLIDE;
- (double) VEL_X;
- (double) VEL_X_HOLD_FACTOR;
- (double) LEVEL_HEIGHT;

@end
