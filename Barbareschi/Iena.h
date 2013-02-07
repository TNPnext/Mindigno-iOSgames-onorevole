//
//  Iena.h
//  Barbareschi
//
//  Created by Enrico on 26/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameCharacter.h"

#define kIena_fermoFrameName @"iena_06.png"
#define kIena_fermo_feritaFrameName @"iena_ferita_06.png"

@interface Iena : GameCharacter {
    
    double originalConstVelocity;
    
    NSArray *fermoFrameArray;
    
    NSArray *camminaAnimationArray;
    NSArray *indietreggiaAnimationArray;
    NSArray *pre_colpitaAnimationArray;
    NSArray *colpita_pugnoAnimationArray;
    NSArray *colpita_calcioAnimationArray;
    NSArray *minacciataAnimationArray;
    
    int indiceAnimazione;
    
    int indiceSoundToPlay;
}

@end
