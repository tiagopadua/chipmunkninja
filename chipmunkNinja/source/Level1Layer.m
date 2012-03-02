    //
//  Level1Layer.m
//  chipmunkNinja
//
//  Created by Maxwell Dayvson da Silva on 2/16/12.
//  Copyright 2012 Terra Networks. All rights reserved.
//

#import "Level1Layer.h"

@implementation Level1Layer




-(void)createObjectOfType:(GameObjectType)objectType 
               atLocation:(CGPoint)spawnLocation 
               withZValue:(int)ZValue {
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
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
                              chipMunk.contentSize.height/2)]; 
    
    
    [sceneSpriteBatchNode addChild:chipMunk];
    [chipMunk changeState:kStateBreathing];
}
-(void) onDestroyThorn:(id)thorn{
    CCLOG(@"QUANTIDADE NA LISTA >>>> %d", [thorns count]);
    [self removeChild:thorn cleanup:TRUE];
    [thorns removeObject:thorn];
}
-(void) createBackground{
    background = [[Background node] init:screenSize];
    [self addChild:background z:0];
    
}

-(void) loadPlistLevel {
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"level1.plist"];
    sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"level1.png"];    
    [self addChild:sceneSpriteBatchNode z:1];
    
}

- (Thorn*) newThorn:(BOOL)isRight {
    Thorn *currentThorn = [[Thorn alloc] init];
    [currentThorn setSide:isRight];
    [thorns addObject:currentThorn];
    currentThorn.delegate = self;

    return currentThorn;
}

-(void) checkAddThorn {
    if ( (chipMunk.score - lastThornScore) > 120) {
        [self addChild:[self newThorn:lastThornSide]];        
        lastThornSide = !lastThornSide;
        lastThornScore = chipMunk.score;
    }
}
-(void)onDie  {
    [scoreLabel setString:@"MORREU MALUCO!"];
    paraTudo = TRUE;
}
- (BOOL) rect:(CGRect) rect collisionWithRect:(CGRect) rectTwo
{
    float rect_x1 = rect.origin.x;
    float rect_x2 = rect_x1+rect.size.width;
    
    float rect_y1 = rect.origin.y;
    float rect_y2 = rect_y1+rect.size.height;
    
    float rect2_x1 = rectTwo.origin.x;
    float rect2_x2 = rect2_x1+rectTwo.size.width;
    
    float rect2_y1 = rectTwo.origin.y;
    float rect2_y2 = rect2_y1+rectTwo.size.height;
    CCLOG(@"R1[X1]=%f R1[X2]=%f R1[Y1]=%f R1[Y2]=%f", rect_x1,rect_x2,rect_y1,rect_y2);
    CCLOG(@"R1[X1]=%f R1[X2]=%f R1[Y1]=%f R1[Y2]=%f", rect2_x1,rect2_x2,rect2_y1,rect2_y2);
    if((rect_x2 > rect2_x1 && rect_x1 < rect2_x2) &&(rect_y2 > rect2_y1 && rect_y1 < rect2_y2))
        return YES;
    
    return NO;
}
- (void) checkDeath{
    Thorn *currentThorn;
    CCARRAY_FOREACH(thorns, currentThorn) {
        CGRect cMArea = [chipMunk getRealBoundingBox];
        CGRect cThorn = [currentThorn getRealBoundingBox];


        if ([self rect:cMArea collisionWithRect:cThorn] == YES) {
            CCLOG(@"cM x %f y: %f w:%f h:%f", chipMunk.position.x, chipMunk.position.y, chipMunk.contentSize.width, chipMunk.contentSize.height);
            CCLOG(@"thorn x %f y: %f w:%f h:%f", currentThorn.position.x, currentThorn.position.y, currentThorn.contentSize.width, currentThorn.contentSize.height);
            [self onDie];
            break;
        }
    }
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
        [currentThorn updatePosition:deltaY];
    }
    [self checkAddThorn];

}
#define INITIAL_THORN_COUNT 5
#define LEFT TRUE
#define RIGHT FALSE

-(void) createRestartButton {
    CCSprite *restartSprite = [CCSprite spriteWithSpriteFrame:
                               [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btn-restart-level.png"]];
    CCMenuItemSprite *restartButton = [CCMenuItemSprite itemFromNormalSprite:restartSprite selectedSprite:nil
                                                                      target:self selector:@selector(onClickRestart)];
    menu = [CCMenu menuWithItems:restartButton, nil];
    menu.anchorPoint = ccp(0,0);
    menu.position = ccp(screenSize.width - (restartSprite.contentSize.width + 30),screenSize.height - 30);
    [self addChild:menu];
}
-(void) restartLayer {
    [self removeAllChildrenWithCleanup:TRUE];
    [thorns release];
    
}

-(void) initialize {
    lastThornScore = 0.0f;
    lastThornSide = RIGHT;
    paraTudo = FALSE;
    screenSize = [CCDirector sharedDirector].winSize;
    thorns = [[CCArray alloc] initWithCapacity:INITIAL_THORN_COUNT];
    CCLOG(@"ENG INIT");
    [self loadPlistLevel];
    [self createGameObjects];
    [self schedule:@selector(update:)];
    scoreLabel = [CCLabelTTF labelWithString:@"000m" fontName:@"Marker Felt"fontSize:15];
    scoreLabel.position = ccp(screenSize.width/2, screenSize.height - scoreLabel.contentSize.height/2 - 10);
    [scoreLabel setString:@"000"];
    [self addChild:scoreLabel z:300];
    [self createRestartButton];    
}

-(void) onClickRestart {
    [self restartLayer];
    [self initialize];
}


-(id)init {
    self = [super init];
    if (self != nil) {
        paraTudo = FALSE;     
        self.isTouchEnabled = YES;
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        [self initialize];
        CCLOG(@"ENG INIT");
        
    }
    return self; 
}
-(void) update:(ccTime)deltaTime {
    if(paraTudo)return;
    CCArray *listOfGameObjects = [sceneSpriteBatchNode children];
    for (BaseObject *tempChar in listOfGameObjects) {
        [tempChar updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
    }
    [self checkDeath];
}
- (void) dealloc {
    [self restartLayer];
    [super dealloc];
}
@end
