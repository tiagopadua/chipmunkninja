//
//  Level1Scene.m
//  chipmunkNinja
//
//  Created by Maxwell Dayvson da Silva on 2/16/12.
//  Copyright 2012 Terra Networks. All rights reserved.
//

#import "Level1Scene.h"
#import "MainMenuLayer.h"

@implementation Level1Scene

-(id) init {
    self = [super init];
    if( self != nil){
         level1Layer = [Level1Layer node];
        [self addChild:level1Layer];
    }
    return self;
}
- (void)resetLevel {

}
@end
