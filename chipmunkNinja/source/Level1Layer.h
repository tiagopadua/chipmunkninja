//
//  Level1Layer.h
//  chipmunkNinja
//
//  Created by Maxwell Dayvson da Silva on 2/16/12.
//  Copyright 2012 Terra Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCTouchDispatcher.h"
#import "GameConstants.h"
#import "Chipmunk.h"
#import "Background.h"
#import "Thorn.h"
#import "Chainsaw.h"
@interface Level1Layer : CCLayer <GameplayLayerDelegate,ChipmunkDelegate,ThornDelegate>{
    Chipmunk *chipMunk;
    Background *background;
    CCSpriteBatchNode *sceneSpriteBatchNode;
    Chainsaw *chainsaw;
    CGSize screenSize;
    CCMenu *menu;
    CCArray *thorns;
    CCLabelTTF *scoreLabel;
    double lastThornScore;
    double nextThornPosition;
    BOOL lastThornSide;
    BOOL paraTudo;
    BOOL isTouching;
    int jumpPower;
    BOOL died;
    CCRenderTexture *_rt;
}

@property (nonatomic,assign) CCRenderTexture *_rt;
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;

@end
