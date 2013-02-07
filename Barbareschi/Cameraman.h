//
//  Cameraman.h
//  Barbareschi
//
//  Created by Enrico on 26/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameCharacter.h"

#define kCameraman_fermoFrameName @"cameraman_02.png"
#define kCameraman_fermo_feritoFrameName @"cameraman_ferito_02.png"

@interface Cameraman : GameCharacter {
    
    double originalConstVelocity;
    
    NSArray *fermoFrameArray;
    
    NSArray *camminaAnimationArray;
    NSArray *indietreggiaAnimationArray;
    NSArray *pre_colpitoAnimationArray;
    NSArray *colpito_pugnoAnimationArray;
    NSArray *colpito_calcioAnimationArray;
    NSArray *minacciatoAnimationArray;
    
    int indiceAnimazione;
}

@end
