//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#define CP_ALLOW_PRIVATE_ACCESS 1
#import "CCPhysics+ObjectiveChipmunk.h"

@implementation MainScene {
  CCSprite *_character;
  CCPhysicsNode *_physicsNode;
}

- (void)onEnterTransitionDidFinish {
  [super onEnterTransitionDidFinish];
  
  _character.physicsBody.body.body->velocity_func = playerUpdateVelocity;
  CCActionFollow *follow = [CCActionFollow actionWithTarget:_character worldBoundary:_physicsNode.boundingBox];
  [self runAction:follow];
  
  self.userInteractionEnabled = YES;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  [_character.physicsBody.chipmunkObjects[0] eachArbiter:^(cpArbiter *arbiter) {
    [_character.physicsBody applyImpulse:ccp(0, 1200)];
  }];
}

static void
playerUpdateVelocity(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt)
{
  cpAssertSoft(body->m > 0.0f && body->i > 0.0f, "Body's mass and moment must be positive to simulate. (Mass: %f Moment: %f)", body->m, body->i);
  
	body->v = cpvadd(cpvmult(body->v, damping), cpvmult(cpvadd(gravity, cpvmult(body->f, body->m_inv)), dt));
	body->w = body->w*damping + body->t*body->i_inv*dt;
  
	// Reset forces.
	body->f = cpvzero;
	body->t = 0.0f;
  
	body->v.x = 40.f;
}

@end
