//
//  IPhodViewController.m
//  iPhod
//
//  Created by August Joki on 3/25/09.
//  Copyright Concinnous Software 2009. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <objc/runtime.h>

#import "IPhodViewController.h"
#import "CSScrubber.h"
#import "CSPodButton.h"
#import "CSItemViewController.h"


#define kSteps 20

@implementation IPhodViewController


- (id)initWithCoder:(NSCoder *)coder {
  if (self = [super initWithCoder:coder]) {
    unsigned int count;
    Method *methods = class_copyMethodList(object_getClass([MPMediaQuery class]), &count);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int ii = 0; ii < count; ii++) {
      SEL selector = method_getName(methods[ii]);
      NSString *name = NSStringFromSelector(selector);
      if ([name hasSuffix:@"Query"]) {
        NSString *type = [name stringByReplacingOccurrencesOfString:@"Query" withString:@""];
        [array insertObject:type atIndex:0];
      }
    }
    mediaTypes = [array copy];
    [array release];
  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  [scrubber addTarget:self action:@selector(scrubberMovedCW) forControlEvents:SCScrubberControlEventMovedCW];
  [scrubber addTarget:self action:@selector(scrubberMovedCCW) forControlEvents:SCScrubberControlEventMovedCCW];
  
  backward.type = CSPodButtonTypeBackward;
  menu.type = CSPodButtonTypeMenu;
  playpause.type = CSPodButtonTypePlayPause;
  forward.type = CSPodButtonTypeForward;
  select.type = CSPodButtonTypeSelect;
  
  musicViewController = [[CSGroupTableViewController alloc] initWithNibName:@"CSGroupTableViewController" bundle:nil];
  musicViewController.delegate = self;
  musicViewController.groups = mediaTypes;
  musicViewController.title = @"Music";
  
  menuController = [[UINavigationController alloc] initWithRootViewController:musicViewController];
  menuController.delegate = self;
  menuController.navigationBarHidden = YES;
  menuController.view.frame = musicViewController.view.frame;
  
  [logo removeFromSuperview];
  [musicViewController viewWillAppear:NO];
  [display addSubview:menuController.view];
  //[display addSubview:groupViewController.view];
  CGRect frame = menuController.view.frame;
  frame.origin.y = frame.origin.y + displayLabel.bounds.size.height + 1.0f;
  menuController.view.frame = frame;
  displayLabel.text = musicViewController.title;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)scrubberMovedCW; // down
{
  UIViewController *topController = menuController.topViewController;
  if ([topController isKindOfClass:[CSGroupTableViewController class]]) {
    [(CSGroupTableViewController *)topController moveDown];
  }
  else if ([topController isKindOfClass:[CSItemViewController class]]) {
    [(CSItemViewController *)topController forward];
  }
}


- (void)scrubberMovedCCW; // up
{
  UIViewController *topController = menuController.topViewController;
  if ([topController isKindOfClass:[UITableViewController class]]) {
    [(CSGroupTableViewController *)topController moveUp];
  }
  else if ([topController isKindOfClass:[CSItemViewController class]]) {
    [(CSItemViewController *)topController backward];
  }
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
  if ([displaySpinner isAnimating]) {
    [displaySpinner stopAnimating];
  }
}


- (IBAction)buttonPressed:(id)sender;
{
  if (sender == backward) {
    // not handled here
  }
  else if (sender == menu) {
    NSArray *controllers = menuController.viewControllers;
    if (controllers.count >= 2) {
      UIViewController *previousViewController = [controllers objectAtIndex:controllers.count - 2];
      [menuController popViewControllerAnimated:YES];
      displayLabel.text = previousViewController.title;
    }
  }
  else if (sender == playpause) {
    UIViewController *vc = menuController.topViewController;
    if ([vc isKindOfClass:[CSItemViewController class]]) {
      [(CSItemViewController *)vc playpause];
    }
    else {
      if (musicPlayer == nil) {
        return;
      }
      if (musicPlayer.playbackState == MPMusicPlaybackStatePaused || musicPlayer.playbackState == MPMusicPlaybackStateStopped) {
        [musicPlayer play];
      }
      else if (musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        [musicPlayer pause];
      }      
    }
  }
  else if (sender == forward) {
    // not handled here
  }
  else if (sender == select) {
    if ([menuController.topViewController isKindOfClass:[CSGroupTableViewController class]]) {
      CSGroupTableViewController *controller = (CSGroupTableViewController *)menuController.topViewController;
      [controller select];
    }
  }
  else {
    return;
  }
}


- (void)createNewController:(NSArray *)array;
{
  MPMediaQuery *query = [array objectAtIndex:0];
  NSString *title = [[array objectAtIndex:1] capitalizedString];
  CSGroupTableViewController *groupViewController = [[CSGroupTableViewController alloc] initWithNibName:@"CSGroupTableViewController" bundle:nil];
  groupViewController.delegate = self;
  groupViewController.groups = query.collections;
  groupViewController.grouping = query.groupingType;
  groupViewController.title = title;
  [menuController pushViewController:groupViewController animated:YES];
  [groupViewController release];
  displayLabel.text = title;
}


- (void)groupTableViewController:(CSGroupTableViewController *)controller didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (controller == musicViewController) {
    NSString *title = [mediaTypes objectAtIndex:indexPath.row];
    NSString *type = [title stringByAppendingString:@"Query"];
    SEL selector = NSSelectorFromString(type);
    MPMediaQuery *query = [MPMediaQuery performSelector:selector];
    [displaySpinner startAnimating];
    NSArray *array = [NSArray arrayWithObjects:query, title, nil];
    [self performSelector:@selector(createNewController:) withObject:array afterDelay:0];
  }
  else {
    id group = [controller.groups objectAtIndex:indexPath.row];
    if ([group isKindOfClass:[MPMediaItem class]]) {
      MPMediaItem *item = (MPMediaItem *)group;
      CSItemViewController *itemController = [[CSItemViewController alloc] initWithNibName:@"CSItemViewController" bundle:nil];
      itemController.song = item;
      musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
      itemController.musicPlayer = musicPlayer;
      [menuController pushViewController:itemController animated:YES];
      [itemController release];
      displayLabel.text = nil;
    }
    else if ([group isKindOfClass:[MPMediaItemCollection class]]) {
      CSGroupTableViewController *gc = [[CSGroupTableViewController alloc] initWithNibName:NSStringFromClass([CSGroupTableViewController class]) bundle:nil];
      gc.delegate = self;
      MPMediaItemCollection *collection = (MPMediaItemCollection *)group;
      MPMediaGrouping grouping = controller.grouping;
      if (grouping == MPMediaGroupingArtist) {
        MPMediaQuery *query = [MPMediaQuery albumsQuery];
        MPMediaPredicate *pred = [MPMediaPropertyPredicate predicateWithValue:[collection.representativeItem valueForProperty:MPMediaItemPropertyArtist] forProperty:MPMediaItemPropertyArtist];
        [query addFilterPredicate:pred];
        gc.groups = query.collections;
        gc.grouping = MPMediaGroupingAlbum;
      }
      else {
        gc.groups = collection.items;
        gc.grouping = MPMediaGroupingTitle;
      }
      [menuController pushViewController:gc animated:YES];
      UITableViewCell *cell = [controller.tableView cellForRowAtIndexPath:indexPath];
      gc.title = cell.textLabel.text;
      [gc release];
      displayLabel.text = cell.textLabel.text;
    }
  }
}


- (void)dealloc {
  [display release];
  [backward release];
  [menu release];
  [playpause release];
  [forward release];
  [select release];
  [scrubber release];
  [mediaTypes release];
  [musicViewController release];
  [menuController release];
  [super dealloc];
}

@end
