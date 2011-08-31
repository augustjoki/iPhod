//
//  CSItemViewController.h
//  Scrubber
//
//  Created by August Joki on 5/8/09.
//  Copyright 2009 Concinnous Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CSItemViewController : UIViewController {
  IBOutlet UILabel *albumLabel, *artistLabel, *titleLabel;
  IBOutlet UIProgressView *progress;
  IBOutlet UIImageView *imageView;
  
  MPMediaItem *song;  
  MPMusicPlayerController *musicPlayer;
  
  NSTimer *timer;
}

@property(nonatomic, retain) MPMediaItem *song;
@property(nonatomic, retain) MPMusicPlayerController *musicPlayer;

- (void)playpause;
- (void)forward;
- (void)backward;

@end
