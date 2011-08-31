//
//  CSItemViewController.m
//  Scrubber
//
//  Created by August Joki on 5/8/09.
//  Copyright 2009 Concinnous Software. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

#import "CSItemViewController.h"


@implementation CSItemViewController

@synthesize song, musicPlayer;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  albumLabel.text = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
  artistLabel.text = [song valueForProperty:MPMediaItemPropertyArtist];
  titleLabel.text = [song valueForProperty:MPMediaItemPropertyTitle];
  MPMediaItemArtwork *artwork = [song valueForProperty:MPMediaItemPropertyArtwork];
  UIImage *image = [artwork imageWithSize:imageView.bounds.size];
  imageView.image = image;
  
  NSSet *set = [NSSet setWithObject:[MPMediaPropertyPredicate predicateWithValue:titleLabel.text forProperty:MPMediaItemPropertyTitle]];
  MPMediaQuery *query = [[MPMediaQuery alloc] initWithFilterPredicates:set];
  [musicPlayer setQueueWithQuery:query];
  [query release];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateChange) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];
  [musicPlayer beginGeneratingPlaybackNotifications];
}


- (void)stateChange {
  progress.progress = musicPlayer.currentPlaybackTime / [[song valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue];
}


- (void)playpause {
  if (musicPlayer.playbackState == MPMusicPlaybackStatePaused || musicPlayer.playbackState == MPMusicPlaybackStateStopped) {
    [musicPlayer play];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(stateChange) userInfo:nil repeats:YES];
  }
  else if (musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
    [musicPlayer pause];
    [timer invalidate];
  }
}


- (void)forward;
{
  [musicPlayer beginSeekingForward];
  [self performSelector:@selector(stopSeeking) withObject:nil afterDelay:1.0f];
}


- (void)backward;
{
  [musicPlayer beginSeekingBackward];
  [self performSelector:@selector(stopSeeking) withObject:nil afterDelay:1.0f];
}


- (void)stopSeeking {
  [musicPlayer endSeeking];
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
  [musicPlayer stop];
  [musicPlayer endGeneratingPlaybackNotifications];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];
}


- (void)dealloc {
    [super dealloc];
}


@end
