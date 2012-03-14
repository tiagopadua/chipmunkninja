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

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCTouchDispatcher.h"
#import "GameConstants.h"
#import "Chipmunk.h"
#import "Background.h"
#import "Thorn.h"
#import "Chainsaw.h"


@interface Level1Layer : CCLayer <GameplayLayerDelegate,ChipmunkDelegate,ThornDelegate>{
    Chipmunk *chipMunk;
    Background *background;
    CCSpriteBatchNode *sceneSpriteBatchNode;
    Chainsaw *chainsaw;
    CGSize screenSize;
    CCMenu *menu;
    CCArray *thorns;
    CCLabelTTF *scoreLabel;
    double lastThornScore;
    double nextThornPosition;
    BOOL lastThornSide;
    BOOL paraTudo;
    BOOL isTouching;
    int jumpPower;
    BOOL died;
    CCRenderTexture *_rt;
    SimpleAudioEngine *soundEngine;
}

@property (nonatomic,assign) CCRenderTexture *_rt;
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;

@end
