//
//  Level1Layer.m
//  chipmunkNinja
//
//  Created by Maxwell Dayvson da Silva on 2/16/12.
//  Copyright 2012 Terra Networks. All rights reserved.
//

#import "Level1Layer.h"

@implementation Level1Layer

-(void) update:(ccTime)deltaTime {
    CCArray *listOfGameObjects = [sceneSpriteBatchNode children];
    for (BaseObject *tempChar in listOfGameObjects) {
        [tempChar updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
    }    
}

-(void)createObjectOfType:(GameObjectType)objectType 
               atLocation:(CGPoint)spawnLocation 
               withZValue:(int)ZValue {
    
}

- (void) dealloc {
    [super dealloc];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CCLOG(@"TOUCH END");
    [chipMunk setTouching:FALSE];
    
}
-(void) setChipmunkJump:(CharacterStates)chipmunkState{
    [chipMunk setTouching:TRUE];
    [chipMunk setVelY:600];            
    [chipMunk changeState:chipmunkState];    
}
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    switch (chipMunk.characterState) {
        case kStateIdle:
        case kStateBreathing:
            [self setChipmunkJump:kStateFirstJumping];
            break;
        case kStateHolding:
            [self setChipmunkJump:kStateJumping];
        default:
            break;
    }
    return TRUE;
}
-(void)onUpdateBackground:(double)deltaY{
    if (background) {
        [background updateStateWithDeltaTime:deltaY];
    }
}
-(id)init {
    self = [super init];
    if (self != nil) {
        CGSize screenSize = [CCDirector sharedDirector].winSize; 
        self.isTouchEnabled = YES; 
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"level1.plist"];
        sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"level1.png"];

        background = [[Background node] init:screenSize];
        [self addChild:background];

        [self addChild:sceneSpriteBatchNode z:0];

        chipMunk = [[Chipmunk alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                                          spriteFrameByName:@"chipmunk1.png"]];
        chipMunk.delegate = self;
        [chipMunk setPosition:ccp(screenSize.width/2, 
                                (chipMunk.contentSize.height/2)-3)]; 

        
        [sceneSpriteBatchNode addChild:chipMunk z:1 tag:1000];
        [chipMunk changeState:kStateBreathing];
        [self createObjectOfType:kChipmunk 
                      atLocation:ccp(100,100) 
                      withZValue:10];
        [self scheduleUpdate];
    }
    return self; 
}

@end
