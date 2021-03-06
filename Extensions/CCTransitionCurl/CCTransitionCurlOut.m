/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2014-2015 Lars Birkemose
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "CCTransitionCurlOut.h"
#import "CCSpriteCurl.h"

// -----------------------------------------------------------------------

@implementation CCTransitionCurlOut
{
    CCSpriteCurl *_curl;
    CGSize _curlSize;
    CCTransitionDirection _direction;
}

// -----------------------------------------------------------------------

+ (instancetype)transitionCurlOutWithDirection:(CCTransitionDirection)direction duration:(NSTimeInterval)duration
{
    return [[self alloc] initWithDirection:direction duration:duration];
}

// -----------------------------------------------------------------------

- (instancetype)initWithDirection:(CCTransitionDirection)direction duration:(NSTimeInterval)duration
{
    self = [super initWithDuration:duration];
    
    _direction = direction;
    
    return self;
}

// -----------------------------------------------------------------------

- (void)startTransition:(CCScene *)scene
{
    [super startTransition:scene];
    
    // READ THIS!
    // If the compiler fails with "Property outgoingTexture not found ..." you can solve it two ways
    // 1) Download latest V3.4 version of Cocos2D and replace it
    // 2) Add the line "@property (nonatomic, readonly) CCRenderTexture *outgoingTexture;" (without quotes) to CCTransition.h along with the other properties
    _curl = [[CCSpriteCurl alloc] initWithTexture:self.outgoingTexture.texture
                                               rect:(CGRect){CGPointZero, [CCDirector sharedDirector].viewSize}
                                            rotated:NO];
    
    _curl.positionType = CCPositionTypeNormalized;
    _curl.position = ccp(0.5, 0.5);
    [self addChild:_curl z:1000];
    
    switch (_direction)
    {
        case CCTransitionDirectionLeft:
            _curl.pageMode = CCPageModeCurlLeft;
            [_curl curlStart:ccp([CCDirector sharedDirector].viewSize.width, 0)];
            break;
        case CCTransitionDirectionRight:
            _curl.pageMode = CCPageModeCurlRight;
            [_curl curlStart:ccp(0, 0)];
            break;
        default: NSAssert(NO, @"Transition direction not supported");
    }
}

// -----------------------------------------------------------------------

- (void)draw:(CCRenderer *)renderer transform:(const GLKMatrix4 *)transform
{
    self.outgoingTexture.visible = NO;
}

// -----------------------------------------------------------------------

- (void)update:(CCTime)delta
{
    // always call super first
    [super update:delta];
    
    // set up the transition
    float curlProgress = sqrtf(self.progress);
    
    switch (_direction)
    {
        case CCTransitionDirectionLeft:
            [_curl curlTo:ccp([CCDirector sharedDirector].viewSize.width * (1 - curlProgress),
                              [CCDirector sharedDirector].viewSize.height * 0.5 * sinf(curlProgress * M_PI))];
            break;
            
        case CCTransitionDirectionRight:
            [_curl curlTo:ccp([CCDirector sharedDirector].viewSize.width * curlProgress,
                              [CCDirector sharedDirector].viewSize.height * 0.5 * sinf(curlProgress * M_PI))];
            break;
            
        default:
            break;
    }
    
}

// -----------------------------------------------------------------------

@end




























