//
//  HelloWorldLayer.h
//  chipmunkNinja
//
//  Created by Tiago Padua on 31/1/12.
//  Copyright Terra Networks 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CCTouchDispatcher.h"
// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    CCSprite *background;
    CCSprite *background2;
    CCSprite *treeLeft;
    CCSprite *treeRight;
    CCSprite *chipmunk;
    CCLabelTTF *scoreLabel;
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
