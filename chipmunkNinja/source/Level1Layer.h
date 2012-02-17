//
//  Level1Layer.h
//  chipmunkNinja
//
//  Created by Maxwell Dayvson da Silva on 2/16/12.
//  Copyright 2012 Terra Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConstants.h"
#import "TempObject.h"
@interface Level1Layer : CCLayer <GameplayLayerDelegate>{
    CCSprite *chipMunk;
    CCSpriteBatchNode *sceneSpriteBatchNode;
}

@end
