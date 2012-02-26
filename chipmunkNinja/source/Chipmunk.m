//
//  Chipmunk.m
//  chipmunkNinja
//
//  Created by Tiago Padua on 12/2/12.
//  Copyright (c) 2012 Terra Networks. All rights reserved.
//

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
            break;
        case kStateJumping:
            CCLOG(@"Chipmunk->Starting the jump Animation");
            CCAnimate *animJ = [CCAnimate actionWithAnimation:jumpAnimation restoreOriginalFrame:NO];
            id callbackJump = [CCCallFuncN actionWithTarget:self selector:@selector(finishedJump:)];
            action = [CCSequence actions:animJ,callbackJump, nil];
            break;
        case kStateHolding:
            CCLOG(@"Chipmunk->Starting the hold Animation");
            action = [CCAnimate actionWithAnimation:holdAnimation restoreOriginalFrame:NO];
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

- (void) calculateMaxY{
    double maxY = 2 * (screenSize.height / 3);
    double dy = 0.0f;
    if (self.position.y > maxY) {
        dy = self.position.y - maxY;
        self.position = ccp(self.position.x, maxY);
        score += dy;
        [delegate onUpdateBackground:dy];
    }
}

-(void) animateWhenJump:(ccTime)deltaTime {
    double widthTree = 22+(self.contentSize.width/2);
    double deltaX = 500*deltaTime;
    
    if (touching) deltaX *= 1.5;
    
    if(side == LEFT){
        self.position = ccp(self.position.x + deltaX, self.position.y + velY*deltaTime);
        self.flipX = FALSE;
        if (self.position.x >= (screenSize.width - widthTree)) {
            self.position = ccp(screenSize.width - widthTree, self.position.y);
            [self changeState:kStateHolding];
            side = RIGHT;
        }
    } else {
        self.flipX = TRUE;
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
    [self calculateMaxY];
    
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
    }
    return self;
}

//-(void)slideDown:(ccTime)dt withGravity:(double)gravity andSlideSpeed:(double)slideSpeed andHoldFactor:(double)holdFactor {
//    double newPosY = self.position.y + slideSpeed * dt ;
//    if(isTouching) {
//        newPosY = self.position.y + MAX(slideSpeed * dt, jumpPower * dt);
//        jumpPower -= gravity * holdFactor * dt;
//    }
//
//    // Evita deslizar mais no inicio do jogo
//    double chipmunkZero = self.contentSize.height / 2;
//    if ((score <= 0) && (newPosY < chipmunkZero)) {
//        newPosY = chipmunkZero;
//    }
//
//    self.position = ccp(self.position.x, newPosY);
//}

@end
