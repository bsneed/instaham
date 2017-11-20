//
//  InstagramPost+CoreDataProperties.h
//  Instaham
//
//  Created by Sneed, Brandon on 11/19/17.
//  Copyright © 2017 Hammy. All rights reserved.
//
//

#import "InstagramPost+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface InstagramPost (CoreDataProperties)

+ (NSFetchRequest<InstagramPost *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *captionText;
@property (nonatomic) int32_t commentCount;
@property (nullable, nonatomic, copy) NSString *imageURL;
@property (nonatomic) int32_t likeCount;
@property (nullable, nonatomic, copy) NSString *postID;
@property (nullable, nonatomic, copy) NSString *profileImageURL;
@property (nonatomic) int64_t time;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, retain) NSSet<InstagramComment *> *comments;

@end

@interface InstagramPost (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(InstagramComment *)value;
- (void)removeCommentsObject:(InstagramComment *)value;
- (void)addComments:(NSSet<InstagramComment *> *)values;
- (void)removeComments:(NSSet<InstagramComment *> *)values;

@end

NS_ASSUME_NONNULL_END
