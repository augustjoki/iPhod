//
//  CSPodButton.h
//  Scrubber
//
//  Created by August Joki on 5/6/09.
//  Copyright 2009 Concinnous Software. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _CSPodButtonType {
  CSPodButtonTypeBackward,
  CSPodButtonTypeMenu,
  CSPodButtonTypePlayPause,
  CSPodButtonTypeForward,
  CSPodButtonTypeSelect
} CSPodButtonType;


@interface CSPodButton : UIButton {
#if TARGET_IPHONE_SIMULATOR
  CSPodButtonType type;
#endif
}

@property(nonatomic) CSPodButtonType type;

@end
