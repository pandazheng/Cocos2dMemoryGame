//
//  MTMenuScene.m
//  Memory
//
//  Created by Jake Scott on 20/03/13.
//
//

#import "MTMenuScene.h"

@implementation MTMenuScene

+(id)scene
{
    return [[[self alloc] init] autorelease];
}

-(id)init
{
    if (self = [super init]) {
        MTMenuLayer *layer = [MTMenuLayer node];
        [self addChild:layer];
    }
    return self;
}

@end
