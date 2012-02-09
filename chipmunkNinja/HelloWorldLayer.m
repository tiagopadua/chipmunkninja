//
//  HelloWorldLayer.m
//  chipmunkNinja
//
//  Created by Tiago Padua on 31/1/12.
//


// Import the interfaces
#import "HelloWorldLayer.h"


// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

#define LEFT TRUE
#define RIGHT FALSE
#define VEL_SLIDE -200.0f
#define VEL_X 300.0f
#define GRAVITY 1000.0f
#define JUMP_POWER_START 600.0f
#define JUMP_HOLD_FACTOR 3.0f

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
	
        CGSize size = [[CCDirector sharedDirector] winSize];

        score = 0.0f;
        background = [CCSprite spriteWithFile: @"background.png" rect:CGRectMake(0, 0, size.width, 480*1000)];
      //  background2 = [CCSprite spriteWithFile: @"background.png"];
        chipmunk = [CCSprite spriteWithFile: @"chipmunk1.png"];
        treeLeft = [CCSprite spriteWithFile: @"tree-left.png"];
        treeRight = [CCSprite spriteWithFile: @"tree-left.png"];
        scoreLabel = [CCLabelTTF labelWithString:@"000m" fontName:@"Marker Felt"fontSize:15];

        treeRight.flipX = TRUE;
        treeRight.position = ccp(size.width - treeRight.contentSize.width/2, size.height/2);
        treeLeft.position = ccp(treeLeft.contentSize.width/2, size.height/2);
        background.anchorPoint = ccp(0,0);
        background.position = ccp(0, 0);
        ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
        [background.texture setTexParameters:&params];
        
        //background2.position = ccp(size.width/2, background.position.y + background.contentSize.height);
        scoreLabel.position = ccp(size.width/2, size.height - scoreLabel.contentSize.height/2 - 10);
        backgroundState = FALSE;
        isJumping = FALSE;
        chipmunkSide = LEFT;
        self.isTouchEnabled = TRUE;
        chipmunk.position = ccp(treeLeft.contentSize.width, chipmunk.contentSize.height/2);
        [self schedule:@selector(nextFrame:)];
        
        [self addChild:background];
        //[self addChild:background2];

        [self addChild:treeLeft];
        [self addChild:treeRight];
        [self addChild:chipmunk];
        [self addChild:scoreLabel];
        
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    

	}
	return self;
}

-(void) animateBackground:(double)dy {
    background.position = ccp(background.position.x, background.position.y - dy);    
    /*
     ISSO AQUI FUNCIONA
     if(backgroundState){
     if( background2.position.y < -(background2.contentSize.height/2) ){
     backgroundState = FALSE;
     }else{
     background2.position = ccp(background2.position.x, background2.position.y - dy);
     background.position = ccp(background.position.x, background2.position.y + background2.contentSize.height);        
     }
     }else{        
     
     if( background.position.y < -(background.contentSize.height/2)){
     backgroundState = TRUE;
     }else{
     background.position = ccp(background.position.x, background.position.y - dy);
     background2.position = ccp(background.position.x, background.position.y + background.contentSize.height);        
     }
     } 
     */
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    isTouching = FALSE;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    isTouching = isJumping = TRUE;
    jumpPower = JUMP_POWER_START;
    return TRUE;
}

-(void) updateScore:(double)deltaScore{
    score += deltaScore;
    [scoreLabel setString: [NSString stringWithFormat:@"%03.0fm", score/50] ];
}

-(void) chipmunkSlideDown:(ccTime)dt{
    double newPosY = chipmunk.position.y + VEL_SLIDE * dt ;
    if(isTouching){
        newPosY = chipmunk.position.y + MAX(VEL_SLIDE * dt, jumpPower * dt);
        jumpPower -= GRAVITY * JUMP_HOLD_FACTOR * dt * 3;
    }
    
    // Evita deslizar mais no inicio do jogo
    double chipmunkZero = chipmunk.contentSize.height / 2;
    if ((score <= 0) && (newPosY < chipmunkZero)) {
        newPosY = chipmunkZero;
    }
    chipmunk.position = ccp(chipmunk.position.x, newPosY);
}

- (void) checkDeath{
    if (chipmunk.position.y < 10 && score > 5){
        [scoreLabel setString:@"MORREU MALUCO!"];
    }
}
- (void) calculateMaxChipmunkY{
    CGSize size = [[CCDirector sharedDirector] winSize];
    double maxY = 2 * (size.height / 3);
    double dy = 0.0f;
    if (chipmunk.position.y > maxY) {
        dy = chipmunk.position.y - maxY;
        chipmunk.position = ccp(chipmunk.position.x, maxY);
        [self updateScore:dy];
        [self animateBackground:dy];
    }
}

- (void) animateChipmunk:(ccTime)dt{
    
    if(isJumping){
        double deltaX = VEL_X*dt;
        if (isTouching) deltaX *= JUMP_HOLD_FACTOR;
        if(chipmunkSide == LEFT){
            chipmunk.position = ccp(chipmunk.position.x + deltaX, chipmunk.position.y + jumpPower*dt);
            if (chipmunk.position.x >= treeRight.position.x - (treeRight.contentSize.width/2)) {
                chipmunk.position = ccp(treeRight.position.x - (treeRight.contentSize.width/2), chipmunk.position.y);
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
            jumpPower -= GRAVITY*dt;
        } else {
            jumpPower -= GRAVITY*JUMP_HOLD_FACTOR*dt;
        }

        
    }else{
        [self chipmunkSlideDown:dt];
    }
    [self calculateMaxChipmunkY];
    [self checkDeath];
}



- (void) nextFrame:(ccTime)dt {
    [self animateChipmunk:dt];
}



// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
