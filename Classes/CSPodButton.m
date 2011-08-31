//
//  CSPodButton.m
//  Scrubber
//
//  Created by August Joki on 5/6/09.
//  Copyright 2009 Concinnous Software. All rights reserved.
//

#import "CSPodButton.h"


@implementation CSPodButton

@synthesize type;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
      // Initialization code
      self.opaque = NO;
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)coder {
  if (self = [super initWithCoder:coder]) {
    self.opaque = NO;
  }
  return self;
}


- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  [[UIColor whiteColor] setFill];
  CGContextAddEllipseInRect(context, rect);
  CGContextFillPath(context);
  
  [[UIColor redColor] setFill];
  UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
  CGMutablePathRef path = CGPathCreateMutable();
  switch (self.type) {
    case CSPodButtonTypeBackward: {
      CGFloat height = font.capHeight;
      CGRect bar = CGRectMake(rect.size.width / 2.0f - 7.0f, rect.size.height / 2.0f - height / 2.0f, 2.0f, height);
      CGPathAddRect(path, NULL, bar);
      CGFloat x = CGRectGetMaxX(bar) - 1.0f;
      CGFloat midY = CGRectGetMidY(bar);
      CGFloat minY = CGRectGetMinY(bar);
      CGFloat maxY = CGRectGetMaxY(bar);
      CGPathMoveToPoint(path, NULL, x, midY);
      x += 7.0f;
      CGPathAddLineToPoint(path, NULL, x, minY);
      CGPathAddLineToPoint(path, NULL, x, maxY);
      CGPathCloseSubpath(path);
      CGPathMoveToPoint(path, NULL, x - 1.0f, midY);
      x += 7.0f;
      CGPathAddLineToPoint(path, NULL, x, minY);
      CGPathAddLineToPoint(path, NULL, x, maxY);
      CGPathCloseSubpath(path);
      break;
    }
    case CSPodButtonTypeMenu: {
      NSString *menu = @"MENU";
      CGSize size = [menu sizeWithFont:font];
      CGRect fontRect = CGRectMake(rect.origin.x, rect.size.height / 2.0f - size.height / 2.0f, rect.size.width, size.height);
      [@"MENU" drawInRect:fontRect withFont:font lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
      break;
    }
    case CSPodButtonTypePlayPause: {
      CGFloat height = font.capHeight;
      CGRect bar = CGRectMake(rect.size.width / 2.0f + 8.0f, rect.size.height / 2.0f - height / 2.0f, 2.0f, height);
      CGPathAddRect(path, NULL, bar);
      CGFloat x = CGRectGetMinX(bar);
      CGFloat midY = CGRectGetMidY(bar);
      CGFloat minY = CGRectGetMinY(bar);
      CGFloat maxY = CGRectGetMaxY(bar);
      bar.origin.x = bar.origin.x - 4.0f;
      CGPathAddRect(path, NULL, bar);
      x -= 8.0f;
      CGPathMoveToPoint(path, NULL, x + 1.0f, midY);
      x -= 7.0f;
      CGPathAddLineToPoint(path, NULL, x, minY);
      CGPathAddLineToPoint(path, NULL, x, maxY);
      CGPathCloseSubpath(path);
      break;
    }
    case CSPodButtonTypeForward: {
      CGFloat height = font.capHeight;
      CGRect bar = CGRectMake(rect.size.width / 2.0f + 7.0f, rect.size.height / 2.0f - height / 2.0f, 2.0f, height);
      CGPathAddRect(path, NULL, bar);
      CGFloat x = CGRectGetMinX(bar);
      CGFloat midY = CGRectGetMidY(bar);
      CGFloat minY = CGRectGetMinY(bar);
      CGFloat maxY = CGRectGetMaxY(bar);
      CGPathMoveToPoint(path, NULL, x, midY);
      x -= 7.0f;
      CGPathAddLineToPoint(path, NULL, x, minY);
      CGPathAddLineToPoint(path, NULL, x, maxY);
      CGPathCloseSubpath(path);
      CGPathMoveToPoint(path, NULL, x + 1.0f, midY);
      x -= 7.0f;
      CGPathAddLineToPoint(path, NULL, x, minY);
      CGPathAddLineToPoint(path, NULL, x, maxY);
      CGPathCloseSubpath(path);
      break;
    }
    case CSPodButtonTypeSelect:
      // do nothing
      break;
  }
  CGContextAddPath(context, path);
  CGContextFillPath(context);
  CGPathRelease(path);
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event;
{
  CGFloat dist = sqrt(pow(point.x - self.frame.size.height / 2.0,2) + pow(point.y - self.frame.size.width / 2.0,2));
  if (dist > self.frame.size.height/2.0) {
    return NO;
  }
  return YES;
}


- (void)dealloc {
    [super dealloc];
}


@end
