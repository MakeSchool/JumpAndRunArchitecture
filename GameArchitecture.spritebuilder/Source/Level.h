//
//  Level.h
//  GameArchitecture
//
//  Created by Dion Larson on 2/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Level : CCNode

@property (nonatomic, copy) NSString *nextLevelName;
@property (nonatomic, assign) int levelSpeed;

@end
