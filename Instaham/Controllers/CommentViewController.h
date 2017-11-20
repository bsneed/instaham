//
//  CommentViewController.h
//  Instaham
//
//  Created by Sneed, Brandon on 11/18/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InstagramPost;

@interface CommentViewController : UITableViewController

@property (nonatomic, retain) InstagramPost * _Nullable post;

+ (CommentViewController * _Nonnull)fromStoryboard;

@end
