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
