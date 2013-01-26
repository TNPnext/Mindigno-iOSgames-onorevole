//  CommonProtocols.h

typedef enum {
    kStateIdle,
    kStateWalking,
    kStateAttacking,
    kStateTakingDamage,
    kStateDead
} CharacterStates; // 1

typedef enum {
    kObjectTypeNone,
    kBarbareschiType,
    kIenaType,
    kCameramanType
} GameObjectType;