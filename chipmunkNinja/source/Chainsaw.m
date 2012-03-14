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

#import "Chainsaw.h"


@implementation Chainsaw


-(void) nextFrame:(double)deltaTime andIncrement:(double)multiply{
    if(lastX){
        if(self.position.x >= maxMoveX){
            lastX = !lastX;
        }
    }else{
        if(self.position.x <= minMoveX){
            lastX = !lastX;
        }
    }
    
    
    posY = MAX(self.position.y + (deltaTime * 50), -50);
    self.position = ccp(self.position.x + (deltaTime * (lastX ? +200 : -200)), posY);
}

-(void)changeState:(CharacterStates)newState {
    id action = nil;
}


-(void) loadSprite {
    
    
    edge = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                   sharedSpriteFrameCache]
                                                  spriteFrameByName:@"chainsaw-edge.png"]];
    chain = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                    sharedSpriteFrameCache]
                                                   spriteFrameByName:@"chainsaw.png"]];
    
    
    edge.anchorPoint = ccp(0.0f,0.0f);
    chain.anchorPoint = ccp(0.0f,0.0f);
    chain.position = ccp(edge.contentSize.width-1,0);

    lastX = FALSE;
    posY = 0;

    [self addChild:edge];
    [self addChild:chain];
    [self setContentSize:CGSizeMake(chain.contentSize.width+edge.contentSize.width, 30)];
    self.anchorPoint = ccp(0.0f, 0.0f);

}

-(id) init {
    self = [super init];
    velY = 0;
    minMoveX = 0;
    maxMoveX = 50;
    if(self != nil){
        [self loadSprite];
        gameObjectType = kChainsaw;
        characterState = kStateIdle;        
    }
    return self;
}
@end
