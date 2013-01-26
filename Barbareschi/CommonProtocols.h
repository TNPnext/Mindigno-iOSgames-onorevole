//  CommonProtocols.h

typedef enum {
    kStateSpawning,
    kStateIdle,
    kStateCrouching,
    kStateStandingUp,
    kStateWalking,
    kStateAttacking,
    kStateJumping,
    kStateBreathing,
    kStateTakingDamage,
    kStateDead,
    kStateTraveling,
    kStateRotating, 
    kStateDrilling,
    kStateAfterJumping
} CharacterStates; // 1

typedef enum {
    kObjectTypeNone,
    kBarbareschiType,
    kIenaType,
    kCameramanType
} GameObjectType;