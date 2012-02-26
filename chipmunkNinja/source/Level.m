//
//  Level.m
//  chipmunkNinja
//
//  Created by Tiago Padua on 11/2/12.
//  Copyright (c) 2012 Terra Networks. All rights reserved.
//

#import "Level.h"

@implementation Level

-(NSDictionary*) getPlist:(NSString*)propertyFile {
    NSString *localizedPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:propertyFile];
    return [[NSDictionary dictionaryWithContentsOfFile:localizedPath] retain];
}

-(Level*) init:(NSString *)propertyFile withWindowSize:(CGSize)windowSize {
    self = [super init];
    if (self) {
        _windowSize = windowSize;

        // Read the property file
        if (propertyFile) {
            NSDictionary *plist = [self getPlist:propertyFile];
            _GRAVITY = ((NSNumber*)[plist objectForKey:@"gravity"]).doubleValue;
            _JUMP_POWER_START = ((NSNumber*)[plist objectForKey:@"jumpPower"]).doubleValue;
            _JUMP_HOLD_FACTOR = ((NSNumber*)[plist objectForKey:@"jumpFactor"]).doubleValue;
            _VEL_SLIDE = ((NSNumber*)[plist objectForKey:@"slideSpeed"]).doubleValue;
            _VEL_X = ((NSNumber*)[plist objectForKey:@"horizontalSpeed"]).doubleValue;
            _VEL_X_HOLD_FACTOR = ((NSNumber*)[plist objectForKey:@"horizontalSpeedFactor"]).doubleValue;
            _LEVEL_HEIGHT = ((NSNumber*)[plist objectForKey:@"levelHeight"]).doubleValue;
        }

        _thorns = [[CCArray alloc] initWithCapacity:INITIAL_THORN_COUNT];

        //Create the sprites
//        _chipmunk = [[Chipmunk alloc] init:@"chipmunk1.png"];
//        _background = [[Background alloc] init:@"background.png" withWindowSize:_windowSize andHeightMultiplier:_LEVEL_HEIGHT/BACKGROUND_SPEED_FACTOR];
        _treeLeft = [[Tree alloc] init:@"tree-left.png" withWindowSize:_windowSize andHeightMultiplier:_LEVEL_HEIGHT];
        _treeRight = [[Tree alloc] init:@"tree-left.png" withWindowSize:_windowSize andHeightMultiplier:_LEVEL_HEIGHT andPositionRight:TRUE];

//        for (int i=0; i<INITIAL_THORN_COUNT; ++i) {
//            [_thorns addObject:[[Thorn alloc] init:@"thorn-left.png" withWindowSize:windowSize andTreeWidth:_treeLeft.contentSize.width]];
//            [_thorns addObject:[[Thorn alloc] init:@"thorn-left.png" withWindowSize:windowSize andTreeWidth:_treeLeft.contentSize.width andPositionRight:TRUE]];
//        }
    }
    return self;
}

-(void)dealloc {
    if (_chipmunk) [_chipmunk dealloc];
    if (_background) [_background dealloc];
    if (_treeLeft) [_treeLeft dealloc];
    if (_treeRight) [_treeRight dealloc];
    [super dealloc];
}

- (Background*) getBackground {
    return _background;
}
- (Chipmunk*) getChipmunk {
    return _chipmunk;
}
- (Tree*) getTreeLeft {
    return _treeLeft;
}
- (Tree*) getTreeRight {
    return _treeRight;
}
- (CCArray*) getThorns {
    return _thorns;
}
- (Thorn*) newThorn:(BOOL)isRight {
    Thorn *currentThorn = [[Thorn alloc] init:@"thorn-left.png" withWindowSize:_windowSize andTreeWidth:_treeLeft.contentSize.width andPositionRight:isRight];
    [_thorns addObject:currentThorn];
    return currentThorn;
}

- (double) GRAVITY { return _GRAVITY; }
- (double) JUMP_POWER_START { return _JUMP_POWER_START; }
- (double) JUMP_HOLD_FACTOR { return _JUMP_HOLD_FACTOR; }
- (double) VEL_SLIDE { return _VEL_SLIDE; }
- (double) VEL_X { return _VEL_X; }
- (double) VEL_X_HOLD_FACTOR { return _VEL_X_HOLD_FACTOR; }
- (double) LEVEL_HEIGHT { return _LEVEL_HEIGHT; }


@end
