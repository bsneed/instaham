//
//  InstagramPost+CoreDataProperties.m
//  Instaham
//
//  Created by Sneed, Brandon on 11/19/17.
//  Copyright © 2017 Hammy. All rights reserved.
//
//

#import "InstagramPost+CoreDataProperties.h"

@implementation InstagramPost (CoreDataProperties)

+ (NSFetchRequest<InstagramPost *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"InstagramPost"];
}

@dynamic captionText;
@dynamic commentCount;
@dynamic imageURL;
@dynamic likeCount;
@dynamic postID;
@dynamic profileImageURL;
@dynamic time;
@dynamic userName;
@dynamic comments;

@end
