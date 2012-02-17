//
//  TempObject.h
//  chipmunkNinja
//
//  Created by Maxwell Dayvson da Silva on 2/16/12.
//  Copyright 2012 Terra Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BaseObject.h"

@interface TempObject : BaseObject {
    CCAnimation *jumpAnimation;    
}
@property (nonatomic, retain) CCAnimation *jumpAnimation;
@end
