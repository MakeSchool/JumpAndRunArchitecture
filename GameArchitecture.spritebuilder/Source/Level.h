//
//  Level.h
//  GameArchitecture
//
//  Created by Benjamin Encz on 11/06/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Level : CCNode

@property (nonatomic, copy) NSString *nextLevelName;
@property (nonatomic, assign) int levelSpeed;

@end
