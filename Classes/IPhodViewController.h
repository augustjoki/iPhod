//
//  IPhodViewController.h
//  iPhod
//
//  Created by August Joki on 3/25/09.
//  Copyright Concinnous Software 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "CSGroupTableViewController.h"

@class CSScrubber, CSPodButton;

@interface IPhodViewController : UIViewController <UINavigationControllerDelegate,
CSGroupTableViewDelegate> {
  IBOutlet UIView *display;
  IBOutlet UILabel *displayLabel;
  IBOutlet UIActivityIndicatorView *displaySpinner;
  IBOutlet UIImageView *logo;
  IBOutlet CSPodButton *backward;
  IBOutlet CSPodButton *menu;
  IBOutlet CSPodButton *playpause;
  IBOutlet CSPodButton *forward;
  IBOutlet CSPodButton *select;
  IBOutlet CSScrubber *scrubber;
  
  NSArray *mediaTypes;
  UINavigationController *menuController;
  CSGroupTableViewController *musicViewController;
  MPMusicPlayerController *musicPlayer;
}

- (IBAction)buttonPressed:(id)sender;

@end

