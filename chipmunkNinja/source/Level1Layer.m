    //
//  Level1Layer.m
//  chipmunkNinja
//
//  Created by Maxwell Dayvson da Silva on 2/16/12.
//  Copyright 2012 Terra Networks. All rights reserved.
//

#import "Level1Layer.h"

@implementation Level1Layer


@synthesize _rt;

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
-(void) createChainsaw {
    if(chainsaw != nil) return;
    chainsaw = [Chainsaw node];
    chainsaw.position = ccp(screenSize.width,0);
    [chainsaw runAction:[CCMoveTo actionWithDuration:0.4f position:ccp(-40,chainsaw.position.y)]];
    [self addChild:chainsaw];
}

-(void) createChipmunk {
    chipMunk = [[Chipmunk alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                                      spriteFrameByName:@"chipmunk1.png"]];
    
    chipMunk.delegate = self;


    [chipMunk setPosition:ccp(screenSize.width/2, 
                              chipMunk.contentSize.height/2)]; 
    
    
    //[sceneSpriteBatchNode addChild:chipMunk];
    [self addChild:chipMunk];
    [chipMunk changeState:kStateBreathing];
}
-(void) onDestroyThorn:(id)thorn{
    CCLOG(@"QUANTIDADE NA LISTA >>>> %d", [thorns count]);
    [thorns removeObject:thorn];
}
-(void) createBackground{
    background = [[Background node] init:screenSize];
    [self addChild:background z:0];
    
}
-(BOOL) randomBOOL{
    int tmp = (arc4random() % 30)+1;
    return tmp < 25;
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
    double topScore = (screenSize.height - chipMunk.position.y) + chipMunk.score;
    Thorn *nextThorn;
    if( topScore >= nextThornPosition ){
        nextThorn = [self newThorn:lastThornSide];
        [self addChild:nextThorn];
        BOOL changeSide = [self randomBOOL];
        double minHeight = changeSide ? 40 : 140;
        int maxHeight = changeSide ? 100 : 260;
        nextThornPosition = topScore + MAX(minHeight+nextThorn.contentSize.height, 
                                           nextThorn.contentSize.height+(rand()%maxHeight));
        lastThornSide = changeSide ? !lastThornSide : lastThornSide;
        [self createChainsaw];
    }
}
-(void) destroyBody {
    [chipMunk setRotation:-90.0f];
    [chipMunk setPosition:ccp(100,100)];
    
}
-(void)onDie  {
    died = TRUE;
    [scoreLabel setString:@"MORREU MALUCO!"];
    [self runAction:[CCSequence actions:
                        [CCDelayTime actionWithDuration:0.07f],
                        [CCCallFunc actionWithTarget:self selector:@selector(destroyBody)], nil]];

}




-(BOOL) isCollisionBetweenSpriteA:(CCSprite*)spr1 spriteB:(CCSprite*)spr2 pixelPerfect:(BOOL)pp
{
    BOOL isCollision = NO; 
    CGRect intersection = CGRectIntersection([spr1 boundingBox], [spr2 boundingBox]);
    
    // Look for simple bounding box collision
    if (!CGRectIsEmpty(intersection))
    {
        // If we're not checking for pixel perfect collisions, return true
        if (!pp) {return YES;}
        
        // Get intersection info
        unsigned int x = intersection.origin.x;
        unsigned int y = intersection.origin.y;
        unsigned int w = intersection.size.width;
        unsigned int h = intersection.size.height;
        unsigned int numPixels = w * h;
        
        //NSLog(@"\nintersection = (%u,%u,%u,%u), area = %u",x,y,w,h,numPixels);
        
        // Draw into the RenderTexture
        [_rt beginWithClear:0 g:0 b:0 a:0];
        
        // Render both sprites: first one in RED and second one in GREEN
        glColorMask(1, 0, 0, 1);
        [spr1 visit];
        glColorMask(0, 1, 0, 1);
        [spr2 visit];
        glColorMask(1, 1, 1, 1);
        
        // Get color values of intersection area
        ccColor4B *buffer = malloc( sizeof(ccColor4B) * numPixels );
        glReadPixels(x, y, w, h, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
        
        
        [_rt end];
        
        // Read buffer
        unsigned int step = 1;
        for(unsigned int i=0; i<numPixels; i+=step)
        {
            ccColor4B color = buffer[i];
            
            if (color.r > 0 && color.g > 0)
            {
                isCollision = YES;
                break;
            }
        }
        
        // Free buffer memory
        free(buffer);
    }
    
    return isCollision;
}


- (void) checkDeath{
    Thorn *currentThorn;
    
    if(chainsaw != nil && [self isCollisionBetweenSpriteA:chipMunk spriteB:chainsaw pixelPerfect:TRUE]){
        [self onDie];
        return;
    }
    CCARRAY_FOREACH(thorns, currentThorn) {
        if ([self isCollisionBetweenSpriteA:chipMunk spriteB:currentThorn pixelPerfect:TRUE] ) {
            [self onDie];
            return;
        }
    }

}

-(void) createGameObjects{
    [self createBackground];
    [self createChipmunk];
    
}
-(void)onUpdateBackground:(double)deltaY andDeltaTime:(double)deltaTime{
    if (background) {
        [background updateStateWithDeltaTime:deltaY];
    }
    [scoreLabel setString: [NSString stringWithFormat:@"%03.0fm", chipMunk.score/50] ];
    Thorn *currentThorn;
    CCARRAY_FOREACH(thorns, currentThorn) {
        [currentThorn updatePosition:deltaY];
    }
    if(chainsaw){
        chainsaw.position = ccp(chainsaw.position.x, chainsaw.position.y - deltaY);
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
    chainsaw = nil;
}

-(void) initialize {
    lastThornScore = 0.0f;
    lastThornSide = RIGHT;
    screenSize = [CCDirector sharedDirector].winSize;
    nextThornPosition = screenSize.height+MAX(40,1+(rand()%160));
    thorns = [[CCArray alloc] initWithCapacity:INITIAL_THORN_COUNT];
    CCLOG(@"ENG INIT");
    [self loadPlistLevel];
    [self createGameObjects];
    
    scoreLabel = [CCLabelTTF labelWithString:@"000m" fontName:@"Marker Felt"fontSize:15];
    scoreLabel.position = ccp(screenSize.width/2, screenSize.height - scoreLabel.contentSize.height/2 - 10);
    [scoreLabel setString:@"000"];
    [self addChild:scoreLabel z:300];
    _rt = [CCRenderTexture renderTextureWithWidth:screenSize.width height:screenSize.height];
    _rt.position = ccp(screenSize.width*0.5f,screenSize.height*0.1f);
    [self addChild:_rt];
    _rt.visible = NO;
    died = FALSE;
    [self createRestartButton];    
    [self schedule:@selector(update:)];
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
    if(died) return;
    if(chipMunk){
        [chipMunk updateStateWithDeltaTime:deltaTime andListOfGameObjects:NULL];
    }
    if(chainsaw != nil) {
     [chainsaw nextFrame:deltaTime andIncrement:50];   
    }
    [self checkDeath];
}
- (void) dealloc {
    [self restartLayer];
    [super dealloc];
}
@end
