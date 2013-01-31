//
//  Lifebar.h
//  Barbareschi
//
//  Created by Enrico on 31/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Lifebar : CCSprite {
    
    double length;
}

//Life va da 100 a 0.
- (void)setLife:(double)life;

@end
