//
//  CSGroupTableViewController.h
//  Scrubber
//
//  Created by August Joki on 5/7/09.
//  Copyright 2009 Concinnous Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSGroupTableViewDelegate;

@interface CSGroupTableViewController : UITableViewController {
  NSArray *groups;
  MPMediaGrouping grouping;
  NSUInteger highlighted;
  
  id<CSGroupTableViewDelegate> delegate;
}

@property(nonatomic, retain) NSArray *groups;
@property(nonatomic, assign) MPMediaGrouping grouping;
@property(nonatomic, assign) id<CSGroupTableViewDelegate> delegate;

- (void)moveUp;
- (void)moveDown;
- (void)select;

@end


@protocol CSGroupTableViewDelegate

- (void)groupTableViewController:(CSGroupTableViewController *)gc didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
