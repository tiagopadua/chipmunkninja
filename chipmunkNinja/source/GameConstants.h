typedef enum {
    kNoSceneUninitialized=0,
    kMainMenuScene=1,
    kOptionsScene=2,
    kCreditsScene=3,
    kGameLevel1=4
} SceneTypes;

typedef enum {
    kStateIdle,
    kStateBreathing,
    kStateFirstJumping,
    kStateJumping,
    kStateFlying,
    kStateHolding,
    kStateTakingDamage,
    kStateDead
} CharacterStates;

typedef enum {
    kObjectTypeNone,
    kTempObject,
    kChipmunk,
    kTree,
    kThorn,
    kBackground,
    kStar,
    kChainsaw
} GameObjectType;

@protocol ThornDelegate
-(void)onDestroyThorn:(id)thorn;
@end

@protocol ChipmunkDelegate
-(void)onUpdateBackground:(double)deltaY andDeltaTime:(double)deltaTime;
@end

@protocol GameplayLayerDelegate
-(void)createObjectOfType:(GameObjectType)objectType 
               atLocation:(CGPoint)spawnLocation 
               withZValue:(int)ZValue;
@end
