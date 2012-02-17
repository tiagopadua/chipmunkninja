//
//  HelloWorldLayer.m
//  chipmunkNinja
//
//  Created by Tiago Padua on 31/1/12.
//

// Import the interfaces
#import "Engine.h"

// HelloWorldLayer implementation
@implementation Engine

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Engine *layer = [Engine node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

#define LEFT TRUE
#define RIGHT FALSE

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        size = [[CCDirector sharedDirector] winSize];
        score = 0.0f;
        lastThornScore = 0.0f;
        lastThornSide = LEFT;
        lastLeftIndex = 0;
        lastRightIndex = 0;

        level = [[Level alloc] init:@"Level1.plist" withWindowSize:size];

        background = [level getBackground];
        treeLeft = [level getTreeLeft];
        treeRight = [level getTreeRight];
        chipmunk = [level getChipmunk];
        scoreLabel = [CCLabelTTF labelWithString:@"000m" fontName:@"Marker Felt"fontSize:15];

        scoreLabel.position = ccp(size.width/2, size.height - scoreLabel.contentSize.height/2 - 10);
        backgroundState = FALSE;
        isJumping = FALSE;
        chipmunkSide = LEFT;
        self.isTouchEnabled = TRUE;

        [self addChild:background];
        [self addChild:treeLeft];
        [self addChild:treeRight];
        [self addChild:chipmunk];
        [self addChild:scoreLabel];

        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];

        [self schedule:@selector(nextFrame:)];
	}
	return self;
}

-(void) checkAddThorn {
    CCSprite *currentThorn;
    CCARRAY_FOREACH([level getThorns], currentThorn) {
        if (currentThorn.position.y <= 0) {
            currentThorn.position = ccp(currentThorn.position.x, size.height + currentThorn.contentSize.height/2);
            [self removeChild:currentThorn cleanup:TRUE];
            [[level getThorns] removeObject:currentThorn];
        }
    }
    if ( (score - lastThornScore) > 120) {
        [self addChild:[level newThorn:lastThornSide]];
        lastThornSide = !lastThornSide;
        lastThornScore = score;
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    isTouching = FALSE;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    if (!isJumping) {
        isTouching = isJumping = TRUE;
        jumpPower = [level JUMP_POWER_START];
    }
    return TRUE;
}

-(void) updateScore:(double)deltaScore{
    score += deltaScore;
    [scoreLabel setString: [NSString stringWithFormat:@"%03.0fm", score/50] ];
}

-(void) chipmunkSlideDown:(ccTime)dt{
    double newPosY = chipmunk.position.y + [level VEL_SLIDE] * dt ;
    if(isTouching){
        newPosY = chipmunk.position.y + MAX([level VEL_SLIDE] * dt, jumpPower * dt);
        jumpPower -= [level GRAVITY] * [level JUMP_HOLD_FACTOR] * dt;
    }
    // Evita deslizar mais no inicio do jogo
    double chipmunkZero = chipmunk.contentSize.height / 2;
    if ((score <= 0) && (newPosY < chipmunkZero)) {
        newPosY = chipmunkZero;
    }
    chipmunk.position = ccp(chipmunk.position.x, newPosY);
}

- (void) checkDeath{
    bool died = false;

    if (chipmunk.position.y < 10 && score > 5) died = true;

    CCSprite *currentThorn;
    CCARRAY_FOREACH([level getThorns], currentThorn) {
        CGRect thornRect = currentThorn.boundingBox;
        thornRect.origin.x += (thornRect.size.width *= 0.5) / 2;
        thornRect.origin.y += (thornRect.size.height *= 0.5) / 2;
        CGRect chipmunkRect = chipmunk.boundingBox;
        chipmunkRect.origin.x += (chipmunkRect.size.width *= 0.7) / 2;
        if (CGRectIntersectsRect(chipmunkRect, thornRect)) died = true;
    }
    if (died) [scoreLabel setString:@"MORREU MALUCO!"];
}

- (void) calculateMaxChipmunkY{
    double maxY = 2 * (size.height / 3);
    double dy = 0.0f;
    if (chipmunk.position.y > maxY) {
        dy = chipmunk.position.y - maxY;
        chipmunk.position = ccp(chipmunk.position.x, maxY);
        [self updateScore:dy];
        [background nextFrame:dy];
        Thorn *currentThorn;
        CCARRAY_FOREACH([level getThorns], currentThorn) {
            [currentThorn nextFrame:dy];            
        }
        [self checkAddThorn];
    }
}

- (void) animateChipmunk:(ccTime)dt{
    double deltaX = [level VEL_X]*dt;
    if (isTouching) deltaX *= [level VEL_X_HOLD_FACTOR];
    if(chipmunkSide == LEFT){
        chipmunk.position = ccp(chipmunk.position.x + deltaX, chipmunk.position.y + jumpPower*dt);
        if (chipmunk.position.x >= treeRight.position.x) {
            chipmunk.position = ccp(treeRight.position.x, chipmunk.position.y);
            isJumping = FALSE;
            chipmunkSide = RIGHT;
        }
    } else {
        chipmunk.position = ccp(chipmunk.position.x - deltaX, chipmunk.position.y + jumpPower*dt);
        
        if (chipmunk.position.x <= treeLeft.contentSize.width) {
            chipmunk.position = ccp(treeLeft.contentSize.width, chipmunk.position.y);
            isJumping = FALSE;
            chipmunkSide = LEFT;
        }
    }
    if (isTouching) {
        jumpPower -= [level GRAVITY]*dt;
    } else {
        jumpPower -= [level GRAVITY]*[level JUMP_HOLD_FACTOR]*dt;
    }        
}

- (void) nextFrame:(ccTime)dt {
    if (isJumping) [self animateChipmunk:dt];
    else [self chipmunkSlideDown:dt];

    [self calculateMaxChipmunkY];
    [self checkDeath];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    if (level) [level release];
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
