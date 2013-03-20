//
//  MTPlayfieldScene.m
//  Memory
//
//  Created by Jake Scott on 20/03/13.
//
//

#import "MTPlayfieldScene.h"
#import "MTPlayfieldLayer.h"

@implementation MTPlayfieldScene

+(id) sceneWithRows:(NSInteger)numRows andColumns:(NSInteger)numCols
{
    return [[[self alloc] sceneWithRows:numRows andColumns:numCols] autorelease];
}

-(id) sceneWithRows:(NSInteger)numRows andColumns:(NSInteger)numCols
{
    if (self = [super init]) {
        // Create an instance of the MTPlayfieldLayer
        MTPlayfieldLayer *layer = [MTPlayfieldLayer layerWithRows:numRows andColumns:numCols];
        
        [self addChild:layer];
    }
    
    return self;
}

@end
