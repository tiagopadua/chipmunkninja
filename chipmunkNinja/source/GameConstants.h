typedef enum {
    kNoSceneUninitialized=0,
    kMainMenuScene=1,
    kOptionsScene=2,
    kCreditsScene=3,
    kGameLevel1=4
} SceneTypes;

typedef enum {
    kStateIdle,
    kStateStandingUp,
    kStateJumping,
    kStateBreathing,
    kStateTakingDamage,
    kStateDead,
    kStateAfterJumping
} CharacterStates;

typedef enum {
    kObjectTypeNone,
    kTempObject,
    kChipmunk,
    kTree,
    kThorn,
    kBackground,
    kStar
} GameObjectType;

@protocol GameplayLayerDelegate
-(void)createObjectOfType:(GameObjectType)objectType 
               atLocation:(CGPoint)spawnLocation 
               withZValue:(int)ZValue;
@end
