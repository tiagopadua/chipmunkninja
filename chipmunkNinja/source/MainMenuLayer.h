//
//  MainMenuLayer.h
//  The Great Scape
//
//  Created by Maxwell Dayvson da Silva on 2/11/12.
//  Copyright 2012 Terra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameManager.h"
@interface MainMenuLayer : CCLayer {
    CCSpriteBatchNode *sceneSpriteBatchNode;
    CCParallaxNode *background;
    CCMenu *mainMenu;
    CGSize screenSize;
}

@end
