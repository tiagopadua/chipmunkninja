//
//  MainMenuScene.m
//  The Great Scape
//
//  Created by Maxwell Dayvson da Silva on 2/11/12.
//  Copyright 2012 Terra. All rights reserved.
//

#import "MainMenuScene.h"


@implementation MainMenuScene
-(id) init {
    self = [super init];
    if( self != nil){
        menuLayer = [MainMenuLayer node];
        [self addChild:menuLayer];
    }
    return self;
}
@end
