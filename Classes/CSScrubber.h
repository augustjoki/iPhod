//
//  CSScrubber.h
//  Scrubber
//
//  Created by August Joki on 3/26/09.
//  Copyright 2009 Concinnous Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCScrubberControlEventMovedCW 1 << 13
#define SCScrubberControlEventMovedCCW 1 << 14

@interface CSScrubber : UIControl {
  CGFloat startingTheta;
  CGPoint center;
}

@end
