//
//  CSScrubber.m
//  Scrubber
//
//  Created by August Joki on 3/26/09.
//  Copyright 2009 Concinnous Software. All rights reserved.
//

#import "CSScrubber.h"

#define scrubber_size 190
#define scrubber_hole 65

#define theta_threshold (M_PI/12.0)

@interface CSScrubber ()

- (void)setUp;

@end


@implementation CSScrubber

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, scrubber_size, scrubber_size)]) {
      [self setUp];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)coder {
  if (self = [super initWithCoder:coder]) {
    [self setUp];
  }
  return self;
}


- (void)setUp {
  self.opaque = NO;
  center.x = self.bounds.size.width / 2.0;
  center.y = self.bounds.size.height / 2.0;
}


- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  [[UIColor whiteColor] setFill];  
  CGContextAddEllipseInRect(context, rect);
  
  CGRect hole = CGRectMake(rect.origin.x + (rect.size.width - scrubber_hole) / 2.0,
                           rect.origin.y + (rect.size.height - scrubber_hole) / 2.0,
                           scrubber_hole, scrubber_hole);
  CGContextAddEllipseInRect(context, hole);
  
  CGContextEOFillPath(context);
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event;
{
  CGFloat dist = sqrt(pow(point.x - center.x,2) + pow(point.y - center.y,2));
  if (dist > scrubber_size/2.0 || dist < scrubber_hole/2.0) {
    return NO;
  }
  return YES;
}


- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
{
  CGPoint point = [touch locationInView:self];
  startingTheta = atan2(point.y - center.y, point.x - center.x) + M_PI;
  return YES;
}


- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
{
  // pi <= theta < 3pi/2 -> lower right
  // 3pi/2 <= theta < 2pi -> lower left
  // pi/2 <= theta < pi -> upper right
  // 0 <= theta < pi/2 -> upper left
  CGPoint point = [touch locationInView:self];
  CGFloat theta = atan2(point.y - center.y, point.x - center.x) + M_PI;
  
  CGFloat delta = theta - startingTheta;
  if (fabsf(delta) > M_PI/4.0) {
    startingTheta = theta;
    return YES;
  }
  if (-theta_threshold < delta &&
      delta < theta_threshold) {
    return YES;
  }
  
  if (startingTheta >= 0) { // startingTheta in lower half
    if (theta >= 0) { // theta in lower half
      if (theta - startingTheta < 0) {
        [self sendActionsForControlEvents:SCScrubberControlEventMovedCCW];
      } else if (theta - startingTheta > 0) {
        [self sendActionsForControlEvents:SCScrubberControlEventMovedCW];
      }
    } else if (theta < -M_PI/2.0) { // theta in upper left
      [self sendActionsForControlEvents:SCScrubberControlEventMovedCW];
    } else { // theta in upper right
      [self sendActionsForControlEvents:SCScrubberControlEventMovedCCW];
    }
  } else { // startingTheta in upper half
    if (theta < 0) { // theta in upper half
      if (theta - startingTheta < 0) {
        [self sendActionsForControlEvents:SCScrubberControlEventMovedCCW];
      } else if (theta - startingTheta > 0) {
        [self sendActionsForControlEvents:SCScrubberControlEventMovedCW];
      }
    } else if (theta > M_PI/2.0) { // theta in lower left
      [self sendActionsForControlEvents:SCScrubberControlEventMovedCW];
    } else { // theta in lower right
      [self sendActionsForControlEvents:SCScrubberControlEventMovedCCW];
    }
  }
  startingTheta = theta;
  return YES;
}


- (void)dealloc {
    [super dealloc];
}


@end
