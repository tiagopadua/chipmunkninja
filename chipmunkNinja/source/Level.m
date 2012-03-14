/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Tiago de Pádua <tiagopadua@gmail.com>
 * Created 01/2012
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

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

        _treeLeft = [[Tree alloc] init:@"tree-left.png" withWindowSize:_windowSize andHeightMultiplier:_LEVEL_HEIGHT];
        _treeRight = [[Tree alloc] init:@"tree-left.png" withWindowSize:_windowSize andHeightMultiplier:_LEVEL_HEIGHT andPositionRight:TRUE];


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
