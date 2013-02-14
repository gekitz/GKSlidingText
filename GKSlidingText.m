//
//  GKSlidingText.m
//  GKSlidingText
//
//  Created by Georg Kitz on 2/10/13.
//  Copyright (c) 2013 Aurora Apps. All rights reserved.
//

#import "GKSlidingText.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat GKDeviceScale()
{
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		return [[UIScreen mainScreen] scale];
	}
	return 1.0f;
}

typedef NS_ENUM(NSUInteger, GKSlidingTextState) {
	GKSlidingTextStateAnimating = 0,
	GKSlidingTextStateStopped,
	GKSlidingTextStateStoppedExpected
};

@interface GKSlidingText()
@property (nonatomic, strong) NSMutableArray *layers;
@property (nonatomic, assign) NSInteger currentLayerIndex;
@property (nonatomic, assign) CGFloat textLength;
@property (nonatomic, assign) GKSlidingTextState state;
@property (nonatomic, assign) BOOL started;

- (void)_start;
- (void)_startInternalAnimation;
- (void)_startAnimationWhenStopped;
- (void)_commitAnimationForView:(CALayer *)animationLayer;
- (void)_cleanupSlidingText;

- (CATextLayer *)_defaultTextLayer;

@end

@implementation GKSlidingText


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Setter/Getter

- (void)setText:(NSString *) value{
    
    if([_text isEqualToString:value] && self.state == GKSlidingTextStateAnimating)
        return;
    
	
	_text = [value copy];
    
	[self _cleanupSlidingText];
	self.started = NO;
	
	[self setNeedsLayout];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods

- (void)_start{
	
	if(self.state == GKSlidingTextStateAnimating || self.text.length == 0)
		return;
	
    self.state = GKSlidingTextStateAnimating;
    
	self.textLength = [self.text sizeWithFont:self.font].width;
	
	if(self.textLength > CGRectGetWidth(self.frame)){
		
		self.started = YES;
		self.currentLayerIndex = 0;
		
		
		self.layers = [[NSMutableArray alloc] initWithCapacity:2];
		
		for(NSInteger containerCount = 0; containerCount < 2; containerCount++){
			
			CALayer *containerLayer = [CALayer layer];
			containerLayer.contentsScale = GKDeviceScale();
			containerLayer.bounds = CGRectMake(0, 0, self.textLength * 2 + 4 * 10, CGRectGetHeight(self.frame));
			containerLayer.position = CGPointMake(floor((self.textLength * 2 + 4 * 10) / 2), floor(CGRectGetHeight(self.frame) / 2));
			
			for(NSInteger count = 0; count < 2; count++){
				
				CGRect bounds = CGRectMake(0, 0, self.textLength, CGRectGetHeight(self.frame));
				CGPoint position = CGPointMake(floor(10 + (self.textLength / 2) + self.textLength * count + 20 * count), floor(CGRectGetHeight(self.frame)/2) + 3);
                
				CATextLayer *textLayer = [self _defaultTextLayer];
				textLayer.position = position;
				textLayer.bounds = bounds;
				
				[containerLayer addSublayer:textLayer];
			}
			
			[self.layers addObject:containerLayer];
			if(containerCount == 0)
				[self.layer addSublayer:containerLayer];
		}
		
		[self _startInternalAnimation];
		
	}else {
		
		self.layers = [[NSMutableArray alloc] initWithCapacity:1];
		
		CALayer *containerLayer = [CALayer layer];
		containerLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
		containerLayer.contentsScale = GKDeviceScale();
		
		CGRect frame = CGRectMake(0, 3, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
		CATextLayer *textLayer = [self _defaultTextLayer];
        textLayer.frame = frame;
		
		[containerLayer addSublayer:textLayer];
        
		[self.layer addSublayer:containerLayer];
		[self.layers addObject:containerLayer];
	}
}

- (void)_startAnimationWhenStopped{
    if(self.state == GKSlidingTextStateAnimating)
        return;
    
    [self _cleanupSlidingText];
	
    self.started = NO;
    [self setNeedsLayout];
}

- (void)_startInternalAnimation{
	CALayer *startLayer = self.layers[0];
	
	[self _commitAnimationForView: startLayer];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
	
	if(!flag){//if animation is canceled programmatically.
        self.state = GKSlidingTextStateStoppedExpected;
		return;
	}
    
	CALayer *animatedLayer = self.layers[self.currentLayerIndex];
	[animatedLayer removeFromSuperlayer];
	
	CGPoint oPoint = animatedLayer.position;
	oPoint.x = self.textLength + 20;
	animatedLayer.position = oPoint;
	
	self.currentLayerIndex++;
	if(self.currentLayerIndex == 2)
		self.currentLayerIndex = 0;
	
	animatedLayer = self.layers[self.currentLayerIndex];
	[animatedLayer setHidden:NO];
	[self _commitAnimationForView:animatedLayer];
}

- (void)_commitAnimationForView:(CALayer *) animationLayer{
	[self.layer addSublayer:animationLayer];
	
	CGPoint nPoint = animationLayer.position;
	nPoint.x = 0;
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
	[animation setToValue:[NSValue valueWithCGPoint:nPoint]];
	[animation setDuration:self.animationDuration];
	[animation setRemovedOnCompletion:YES];
	[animation setDelegate:self];
	
	[animationLayer addAnimation:animation forKey:@"position"];
}

- (CATextLayer *)_defaultTextLayer
{
	CATextLayer *textLayer = [CATextLayer layer];
	textLayer.backgroundColor = [UIColor clearColor].CGColor;
	textLayer.contentsScale = GKDeviceScale();
	textLayer.alignmentMode = kCAAlignmentCenter;
	
	textLayer.string = (id) self.text;
	textLayer.foregroundColor = self.textColor.CGColor;
	
	//set all the shado
	if (self.shadowColor != nil) {
		textLayer.shadowColor = self.shadowColor.CGColor;
		textLayer.shadowOffset = self.shadowOffset;
		textLayer.shadowRadius = 0.0f;
		textLayer.shadowOpacity = 1.0f;
	}

	textLayer.fontSize = self.font.pointSize;
	
	CFStringRef font = CFStringCreateWithCString(kCFAllocatorDefault, [[self.font fontName] UTF8String], kCFStringEncodingUTF8);
	textLayer.font = font;
	CFRelease(font);
	
	return textLayer;
}


#pragma mark -
#pragma mark UIView Methods

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = YES;
		
		self.animationDuration = 7;
		self.font = [UIFont systemFontOfSize:16];
		self.textColor = [UIColor blackColor];
	}
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
	[self _start];
}


#pragma mark -
#pragma mark Cleanup

- (void)_cleanupSlidingText{
    self.state = GKSlidingTextStateStopped;
	[[self layer] removeAllAnimations];
	
	for(CALayer *l in self.layers){
		[l removeAnimationForKey:@"position"];
		[l removeAllAnimations];
		[l removeFromSuperlayer];
	}
}

- (void)dealloc {
	[self _cleanupSlidingText];
}


@end
