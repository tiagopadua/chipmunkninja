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

#import "Background.h"


@implementation Background 

-(void)createSpriteByName:(NSString*)name
flipX:(BOOL)flipX
ratio:(CGPoint)ratio
position:(CGPoint)position
zIndex:(int)zIndex
{
    CCSprite* sprite = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                                   sharedSpriteFrameCache]
                                                                  spriteFrameByName:name]];
    sprite.anchorPoint = ccp(0.0f, 0.0f);
    sprite.flipX = flipX;
    [self addChild:sprite z:zIndex parallaxRatio:ratio positionOffset:position];
}
-(id) init{
    self = [super init];
    screenSize = [CCDirector sharedDirector].winSize;
    if (self) {

        self.anchorPoint = ccp(0,0);
        self.position = ccp(0, 0);

        
        double posXTreeRigth = screenSize.width-33;
        double posY1Element = screenSize.height-1;
        double posY2Element = (screenSize.height*2)-2;
        double posY3Element = (screenSize.height*3)-3;
        [self createSpriteByName:@"base_sprite.png" flipX:FALSE ratio:ccp(1.0f,0.5f) position:CGPointZero zIndex:9];        
        [self createSpriteByName:@"background.png" flipX:FALSE ratio:ccp(1.0f,0.5f) position:ccp(0,posY1Element) zIndex:10];
        [self createSpriteByName:@"background.png" flipX:FALSE ratio:ccp(1.0f,0.5f) position:ccp(0,posY2Element) zIndex:11];
        [self createSpriteByName:@"background.png" flipX:FALSE ratio:ccp(1.0f,0.5f) position:ccp(0,posY3Element) zIndex:12];
        [self createSpriteByName:@"tree-right.png" flipX:TRUE ratio:ccp(1.0f,1.0f) position:ccp(0,posY1Element) zIndex:13];
        [self createSpriteByName:@"tree-right.png" flipX:TRUE ratio:ccp(1.0f,1.0f) position:ccp(0,posY2Element) zIndex:14];
        [self createSpriteByName:@"tree-right.png" flipX:TRUE ratio:ccp(1.0f,1.0f) position:ccp(0,posY3Element) zIndex:15];
        [self createSpriteByName:@"tree-right.png" flipX:FALSE ratio:ccp(1.0f,1.0f) position:ccp(posXTreeRigth,posY1Element) zIndex:16];
        [self createSpriteByName:@"tree-right.png" flipX:FALSE ratio:ccp(1.0f,1.0f) position:ccp(posXTreeRigth,posY2Element) zIndex:17];
        [self createSpriteByName:@"tree-right.png" flipX:FALSE ratio:ccp(1.0f,1.0f) position:ccp(posXTreeRigth,posY3Element) zIndex:18];


    }
    return self;
}
-(void)dealloc {
    [super dealloc];
}

-(void) updateStateWithDeltaTime:(ccTime)deltaTime {
    double deltaY = self.position.y+screenSize.height*3;
    self.position = ccp(self.position.x, self.position.y - deltaTime);
    if (deltaY < 0) {
        CCLOG(@"%f - %f", self.position.y, deltaY);
        self.position = ccp(self.position.x, deltaY-screenSize.height);
    }

}

@end
