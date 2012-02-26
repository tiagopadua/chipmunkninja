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

-(void) createChipmunk {
    chipMunk = [[Chipmunk alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                                      spriteFrameByName:@"chipmunk1.png"]];
    chipMunk.delegate = self;
    [chipMunk setPosition:ccp(screenSize.width/2, 
                              (chipMunk.contentSize.height/2)-3)]; 
    
    
    [sceneSpriteBatchNode addChild:chipMunk];
    [chipMunk changeState:kStateBreathing];
    
}
-(void) createBackground{
    background = [[Background node] init:screenSize];
    [self addChild:background z:0];
    
}

-(void) loadPlistLevel {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"level1.plist"];
    sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"level1.png"];    
    [self addChild:sceneSpriteBatchNode z:1];
    
}

- (Thorn*) newThorn:(BOOL)isRight {
    Thorn *currentThorn = [[Thorn alloc] init];
    [currentThorn setSide:isRight];
    [thorns addObject:currentThorn];
    return currentThorn;
}

-(void) checkAddThorn {
    Thorn *currentThorn;
    CCARRAY_FOREACH(thorns, currentThorn) {
        if (currentThorn.position.y <= 0) {
            currentThorn.position = ccp(currentThorn.position.x, screenSize.height + currentThorn.contentSize.height/2);
            [self removeChild:currentThorn cleanup:TRUE];
            [thorns removeObject:currentThorn];
        }
    }
    if ( (chipMunk.score - lastThornScore) > 120) {
        [self addChild:[self newThorn:lastThornSide]];
        lastThornSide = !lastThornSide;
        lastThornScore = chipMunk.score;
    }
}

- (void) checkDeath{
    bool died = false;
    
    if (chipMunk.position.y < 10 && chipMunk.score > 5) died = true;
    
    CCSprite *currentThorn;
    CCARRAY_FOREACH(thorns, currentThorn) {
        CGRect thornRect = currentThorn.boundingBox;
        thornRect.origin.x += (thornRect.size.width *= 0.5) / 2;
        thornRect.origin.y += (thornRect.size.height *= 0.5) / 2;
        CGRect chipmunkRect = chipMunk.boundingBox;
        chipmunkRect.origin.x += (chipmunkRect.size.width *= 0.7) / 2;
        if (CGRectIntersectsRect(chipmunkRect, thornRect)) died = true;
    }
    if (died) [scoreLabel setString:@"MORREU MALUCO!"];
}



-(void) createGameObjects{
    
    [self createBackground];
    [self createChipmunk];
    
}
-(void)onUpdateBackground:(double)deltaY{
    if (background) {
        [background updateStateWithDeltaTime:deltaY];
    }
    [scoreLabel setString: [NSString stringWithFormat:@"%03.0fm", chipMunk.score/50] ];
    Thorn *currentThorn;
    CCARRAY_FOREACH(thorns, currentThorn) {
        [currentThorn setPosition:ccp(currentThorn.position.x, currentThorn.position.y - deltaY)];
    }
    [self checkAddThorn];
    [self checkDeath];
}
#define INITIAL_THORN_COUNT 5
#define LEFT TRUE
#define RIGHT FALSE
-(id)init {
    self = [super init];
    if (self != nil) {
        
        self.isTouchEnabled = YES;
        lastThornScore = 0.0f;
        lastThornSide = RIGHT;
        screenSize = [CCDirector sharedDirector].winSize;
        thorns = [[CCArray alloc] initWithCapacity:INITIAL_THORN_COUNT];
        [self loadPlistLevel];
        [self createGameObjects];
        [self scheduleUpdate];
        scoreLabel = [CCLabelTTF labelWithString:@"000m" fontName:@"Marker Felt"fontSize:15];
        scoreLabel.position = ccp(screenSize.width/2, screenSize.height - scoreLabel.contentSize.height/2 - 10);
        [scoreLabel setString:@"000"];
        [self addChild:scoreLabel z:300];
        
        
    }
    return self; 
}

@end
