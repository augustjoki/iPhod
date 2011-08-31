//
//  CSGroupTableViewController.m
//  Scrubber
//
//  Created by August Joki on 5/7/09.
//  Copyright 2009 Concinnous Software. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

#import "CSGroupTableViewController.h"

@interface CSGroupTableViewController ()

- (void)highlight:(NSIndexPath *)indexPath;

@end


@implementation CSGroupTableViewController

@synthesize groups, grouping, delegate;


- (NSInteger)tableView:(UITableView *)view numberOfRowsInSection:(NSInteger)section;
{
  return groups.count;
}


- (UITableViewCell *)tableView:(UITableView *)view cellForRowAtIndexPath:(NSIndexPath *)path;
{
  NSString *identifier = @"Identifier";
  UITableViewCell *cell = [view dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
  }
  id group = [groups objectAtIndex:path.row];
  if ([group isKindOfClass:[NSString class]]) {
    cell.textLabel.text = group;
  }
  else {
    MPMediaItem *item = nil;
    
    if ([group isKindOfClass:[MPMediaItemCollection class]]) {
      item = ((MPMediaItemCollection *)group).representativeItem;
    }
    else {
      item = (MPMediaItem *)group;
    }
    
    NSString *property = nil;
    switch (grouping) {
      case MPMediaGroupingAlbum:
        property = MPMediaItemPropertyAlbumTitle;
        break;
      case MPMediaGroupingArtist:
        property = MPMediaItemPropertyArtist;
        break;
      case MPMediaGroupingPodcastTitle:
        property = MPMediaItemPropertyPodcastTitle;
        break;
      case MPMediaGroupingComposer:
        property = MPMediaItemPropertyComposer;
        break;
      case MPMediaGroupingGenre:
        property = MPMediaItemPropertyGenre;
        break;
      default:
        property = MPMediaItemPropertyTitle;
        break;
    }
    cell.textLabel.text = [item valueForProperty:property];
  }
  
  [self performSelector:@selector(highlight:) withObject:path afterDelay:0];
  
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSIndexPath *path = [NSIndexPath indexPathForRow:highlighted inSection:0];
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
  cell.highlighted = NO;
  
  highlighted = indexPath.row;
  
  [delegate groupTableViewController:self didSelectRowAtIndexPath:indexPath];
  [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
  cell = [self.tableView cellForRowAtIndexPath:indexPath];
  cell.highlighted = YES;
}


- (void)moveUp {
  if (highlighted == 0) {
    return;
  }
  NSIndexPath *path = [NSIndexPath indexPathForRow:highlighted inSection:0];
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
  cell.highlighted = NO;
  
  highlighted--;
  path = [NSIndexPath indexPathForRow:highlighted inSection:0];
  cell = [self.tableView cellForRowAtIndexPath:path];
  cell.highlighted = YES;
  
  [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:NO];
}


- (void)moveDown {
  if (highlighted == groups.count - 1) {
    return;
  }
  NSIndexPath *path = [NSIndexPath indexPathForRow:highlighted inSection:0];
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
  cell.highlighted = NO;
  
  highlighted++;
  path = [NSIndexPath indexPathForRow:highlighted inSection:0];
  cell = [self.tableView cellForRowAtIndexPath:path];
  cell.highlighted = YES;
  
  [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:NO];
}


- (void)select {
  NSIndexPath *path = [NSIndexPath indexPathForRow:highlighted inSection:0];
  [delegate groupTableViewController:self didSelectRowAtIndexPath:path];
}


- (void)highlight:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
  cell.highlighted = (indexPath.row == highlighted);
}


- (void)dealloc {
  [groups release];
  [super dealloc];
}


@end
