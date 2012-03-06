//
//  Chainsaw.h
//  chipmunkNinja
//
//  Created by Maxwell Dayvson da Silva on 3/6/12.
//  Copyright 2012 Terra Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BaseObject.h"
@interface Chainsaw : BaseObject {
    int velY;
    CCSprite *edge;
    CCSprite *chain;
    BOOL lastX;
    double posY;
    double minMoveX;
    double maxMoveX;
}
-(void) nextFrame:(double)deltaTime andIncrement:(double)multiply;

@end
