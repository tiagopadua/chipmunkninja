//
//  HelloWorldLayer.h
//  chipmunkNinja
//
//  Created by Tiago Padua on 31/1/12.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CCTouchDispatcher.h"
#import "Level.h"

// HelloWorldLayer
@interface Engine: CCLayer
{
    CGSize size;

    Background *background;
    CCSprite *treeLeft;
    CCSprite *treeRight;
    CCSprite *chipmunk;
    CCLabelTTF *scoreLabel;
    
    Level *level;

    double lastThornScore;
    BOOL lastThornSide;
    int lastLeftIndex;
    int lastRightIndex;
    
    double score;
    double jumpPower;
    BOOL backgroundState;
    BOOL isJumping;
    BOOL isTouching;
    BOOL chipmunkSide;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
