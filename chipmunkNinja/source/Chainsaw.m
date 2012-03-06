//
//  Chainsaw.m
//  chipmunkNinja
//
//  Created by Maxwell Dayvson da Silva on 3/6/12.
//  Copyright 2012 Terra Networks. All rights reserved.
//

#import "Chainsaw.h"


@implementation Chainsaw


-(void) nextFrame:(double)deltaTime andIncrement:(double)multiply{
    posY = self.position.y + (deltaTime * 50);
    self.position = ccp(self.position.x, posY);
}

-(void)changeState:(CharacterStates)newState {
    id action = nil;
}

-(void) endAnimation {
    lastX = !lastX;
    CCLOG(@"ENDANIMATIONNNN++++++++++++++++++");
    id moveTo = [CCMoveTo actionWithDuration:0.5 position:ccp(self.position.x + (lastX ? +50 : -50), posY)];
    id call = [CCCallFunc actionWithTarget:self selector:@selector(endAnimation)];     
    [self runAction:[CCSequence actions:moveTo, call, nil]];

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
    chain.position = ccp(edge.contentSize.width,0);
    lastX = FALSE;
    posY = 0;
    [self endAnimation];
    [self addChild:edge];
    [self addChild:chain];
}

-(id) init {
    self = [super init];
    velY = 0;
    if(self != nil){
        [self loadSprite];
        gameObjectType = kChainsaw;
        characterState = kStateIdle;        
    }
    return self;
}
@end
