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

#import "Thorn.h"

@implementation Thorn
@synthesize delegate;

-(void)createWithNumElements:(int)times andFlipX:(BOOL)flipX
{

    for (int i = 0; i<times; i++) {
        CCSprite* sprite = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                                   sharedSpriteFrameCache]
                                                                  spriteFrameByName:@"thorn-right.png"]];
        sprite.anchorPoint = ccp(0.0f, 0.0f);
        sprite.position = ccp(flipX ? 30 : 16, 24*i);
        sprite.scaleX = flipX ? -1.0 : 1.0;
        
        [self addChild:sprite];

    }
    [self setContentSize:CGSizeMake(32, 24*times)];
}
-(void)changeState:(CharacterStates)newState {
    
}

-(void) updatePosition:(double)deltaY {
    self.position = ccp(self.position.x, self.position.y - deltaY);
    if(self.position.y < 0 ){
        [delegate onDestroyThorn:self];
        [self removeFromParentAndCleanup:TRUE];
    }
}
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {
}
- (void) dealloc{
    [super dealloc];
}

-(void) setSide:(BOOL)flipRight{
    [self createWithNumElements: MAX(2, rand() % 5)  andFlipX:flipRight];
    if (flipRight) {
        self.position = ccp(40, screenSize.height + self.contentSize.height/2);
    } else {
        self.position = ccp(screenSize.width-55, screenSize.height + self.contentSize.height/2);
    }
    self.flipX = flipRight;
    CCLOG(@"FLIP SIDE >>>  %d", flipRight);
}
-(Thorn*) init:(BOOL)flipX{
    self = [super init];
    if(self != nil){
        gameObjectType = kThorn;
        characterState = kStateIdle;
    }
    return self;
}

@end
