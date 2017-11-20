//
//  InstagramCell.m
//  Instaham
//
//  Created by Sneed, Brandon on 11/18/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import "InstagramCell.h"

@implementation InstagramCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.commentButton addTarget:self action:@selector(runActionBlock:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)runActionBlock:(id)sender {
    if (self.commentAction) {
        self.commentAction();
    }
}

@end
