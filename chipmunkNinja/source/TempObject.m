//
//  TempObject.m
//  chipmunkNinja
//
//  Created by Maxwell Dayvson da Silva on 2/16/12.
//  Copyright 2012 Terra Networks. All rights reserved.
//

#import "TempObject.h"


@implementation TempObject

@synthesize jumpAnimation;

-(void)changeState:(CharacterStates)newState {
    [self stopAllActions];
    id action = nil;
    [self setCharacterState:newState];
    switch (newState) {
        case kStateJumping:
            CCLOG(@"Chipmunk->Starting the jumping Animation");
            action = [CCAnimate actionWithAnimation:jumpAnimation restoreOriginalFrame:NO];
            break;
        default:
            CCLOG(@"Unhandled state %d in Chipmunk", newState);
            break;
    }
    if (action != nil) {
        [self runAction:action];
    }
}


-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects {
    //Aqui utilizamos os estados dos objetos
}
-(void) initAnimations {
    [self setJumpAnimation:
     [self loadPlistForAnimationWithName:@"jump" 
                            andClassName:@"chipmunk"]];
    
}
- (void) dealloc{
    [jumpAnimation release];
    [super dealloc];
}

-(id) init {
    self = [super init];
    if(self != nil){
        [self initAnimations];
        gameObjectType = kTempObject;
        characterState = kStateJumping;
        [self changeState:kStateJumping];
    }
    return self;
}
@end
