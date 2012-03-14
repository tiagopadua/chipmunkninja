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

#import "Chipmunk.h"

@implementation Chipmunk

@synthesize idleAnimation;
@synthesize jumpAnimation;
@synthesize firstJumpAnimation;
@synthesize flyAnimation;
@synthesize holdAnimation;
@synthesize breathAnimation;
@synthesize touching;
@synthesize velY;
@synthesize score;
@synthesize delegate;
//@synthesize damageAnimation;
//@synthesize deadAnimation;

-(void) finishedJump:(CCNode*)aNode {
    [self changeState:kStateFlying];
}

-(void)changeState:(CharacterStates)newState {
    [self stopAllActions];
    id action = nil;
    [self setCharacterState:newState];
    switch (newState) {
        case kStateIdle:
            CCLOG(@"Chipmunk->Starting the idle Animation");
            action = [CCAnimate actionWithAnimation:idleAnimation restoreOriginalFrame:NO];
            break;
        case kStateFirstJumping:
            CCLOG(@"Chipmunk->Starting the first jump Animation");
            CCAnimate *animFJ = [CCAnimate actionWithAnimation:firstJumpAnimation restoreOriginalFrame:NO];
            id callbackFirstJump = [CCCallFuncN actionWithTarget:self selector:@selector(finishedJump:)];
            action = [CCSequence actions:animFJ,callbackFirstJump, nil];
            [[GameManager sharedGameManager] playSoundEffect:JUMP_TRACK];
            break;
        case kStateJumping:
            CCLOG(@"Chipmunk->Starting the jump Animation");
            CCAnimate *animJ = [CCAnimate actionWithAnimation:jumpAnimation restoreOriginalFrame:NO];
            id callbackJump = [CCCallFuncN actionWithTarget:self selector:@selector(finishedJump:)];
            action = [CCSequence actions:animJ,callbackJump, nil];
            [[GameManager sharedGameManager] playSoundEffect:JUMP_TRACK];
            break;
        case kStateHolding:
            CCLOG(@"Chipmunk->Starting the hold Animation");
            action = [CCAnimate actionWithAnimation:holdAnimation restoreOriginalFrame:NO];
            [[GameManager sharedGameManager] playSoundEffect:JUMP_END_TRACK];
            break;
        case kStateFlying:
            CCLOG(@"Chipmunk->Starting the fly Animation");
            CCAnimate *anim = [CCAnimate actionWithAnimation:flyAnimation restoreOriginalFrame:YES];
            action = [CCRepeatForever actionWithAction:anim];
            break;
        case kStateBreathing:
            CCLOG(@"Chipmunk->Starting the breath Animation");
            CCAnimate *animB = [CCAnimate actionWithAnimation:breathAnimation restoreOriginalFrame:YES];
            action = [CCRepeatForever actionWithAction:animB];
            break;
        default:
            CCLOG(@"Unhandled state %d in Chipmunk", newState);
            break;
    }
    if (action != nil) {
        [self runAction:action];
    }
}
#define RIGHT true
#define LEFT false
-(void) animateSlideDown:(ccTime)deltaTime{
    double VEL_SLIDE = -200;
    double newPosY = self.position.y + VEL_SLIDE * deltaTime ;
    if(touching){
        newPosY = self.position.y + MAX(VEL_SLIDE * deltaTime, velY * deltaTime);
        velY -= 1000 * 1.5 * deltaTime;
    }
    // Evita deslizar mais no inicio do jogo
    double chipmunkZero = self.contentSize.height / 2;
    if ((score <= 0) && (newPosY < chipmunkZero)) {
        newPosY = chipmunkZero;
    }
    self.position = ccp(self.position.x, newPosY);
}

- (void) calculateMaxY:(double)deltaTime{
    double maxY = 2 * (screenSize.height / 3);
    double dy = 0.0f;
    if (self.position.y > maxY) {
        dy = self.position.y - maxY;
        self.position = ccp(self.position.x, maxY);
        score += dy;
        [delegate onUpdateBackground:dy andDeltaTime:deltaTime];
    }
}
-(CGRect)getRealBoundingBox{
    CGSize contentSize = [self contentSize];
    CGPoint contentPosition = [self position];
    CGRect result = CGRectMake(contentPosition.x, contentPosition.y, 
                (contentSize.width) * ABS(self.scaleX), (contentSize.height) * ABS(self.scaleY));
    //CGRectOffset(, contentPosition.x-contentSize.width/2, contentPosition.y-contentSize.height/2);
    
    return   result;
}
-(void) animateWhenJump:(ccTime)deltaTime {
    double widthTree = 13+(self.contentSize.width/2);
    double deltaX = 500*deltaTime;
    
    if (touching) deltaX *= 1.5;
    
    if(side == LEFT){
        self.position = ccp(self.position.x + deltaX, self.position.y + velY*deltaTime);
        self.scaleX = self.scaleX>0 ? self.scaleX : -self.scaleX;
        if (self.position.x >= (screenSize.width - widthTree)) {
            self.position = ccp(screenSize.width - widthTree, self.position.y);
            [self changeState:kStateHolding];
            side = RIGHT;
        }
    } else {
        self.scaleX = self.scaleX<0 ? self.scaleX : -self.scaleX;
        self.position = ccp(self.position.x - deltaX, self.position.y + velY*deltaTime);
        if (self.position.x <= widthTree) {
            self.position = ccp(widthTree, self.position.y);
            [self changeState:kStateHolding];
            side = LEFT;
        }
    }
    if (touching) {
        velY -= 1000*deltaTime;
    } else {
        velY -= 1000*4*deltaTime;
    }
    
}


-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {
    //Aqui utilizamos os estados dos objetos
    switch (characterState) {
        case kStateJumping:
        case kStateFlying:
        case kStateFirstJumping:
            [self animateWhenJump:deltaTime];
            break;
        case kStateHolding:
            [self animateSlideDown:deltaTime];
            break;
        default:
            break;
    }
    [self calculateMaxY:deltaTime];
    
}

-(void) initAnimations {
    [self setIdleAnimation:
     [self loadPlistForAnimationWithName:@"idle" 
                            andClassName:@"chipmunk"]];
    [self setFirstJumpAnimation:
     [self loadPlistForAnimationWithName:@"firstJump" 
                            andClassName:@"chipmunk"]];
    [self setBreathAnimation:
     [self loadPlistForAnimationWithName:@"breathing" 
                            andClassName:@"chipmunk"]];
    [self setJumpAnimation:
     [self loadPlistForAnimationWithName:@"jumping" 
                            andClassName:@"chipmunk"]];
    [self setHoldAnimation:
     [self loadPlistForAnimationWithName:@"holding" 
                            andClassName:@"chipmunk"]];
    [self setFlyAnimation:
     [self loadPlistForAnimationWithName:@"flying" 
                            andClassName:@"chipmunk"]];
    
}
- (void) dealloc{
    [jumpAnimation release];
    [idleAnimation release];
    [firstJumpAnimation release];
    [holdAnimation release];
    [flyAnimation release];
    [breathAnimation release];
    [super dealloc];
}

-(id) init {
    self = [super init];
    velY = 0;
    if(self != nil){
        [self initAnimations];
        gameObjectType = kChipmunk;
        characterState = kStateIdle;
        self.scale = 0.7f;
        self.scaleX = 0.7f;
        self.scaleY = 0.7f;
 
    }
    return self;
}

@end
