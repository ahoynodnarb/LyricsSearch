//
//  LSQueueItem.m
//  LyricsSearch
//
//  Created by Brandon Yao on 4/29/22.
//

#import "LSTrackItem.h"

@implementation LSTrackItem
- (instancetype)initWithLyrics:(NSArray *)lyrics artImage:(UIImage *)artImage songName:(NSString *)songName artistName:(NSString *)artistName {
    if(self = [super init]) {
        self.lyrics = lyrics;
        self.artImage = artImage;
        self.songName = songName;
        self.artistName = artistName;
    }
    return self;
}
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    NSArray *lyrics = dict[@"lyrics"];
    UIImage *artImage = dict[@"artImage"];
    NSString *songName = dict[@"songName"];
    NSString *artistName = dict[@"artistName"];
    return [self initWithLyrics:lyrics artImage:artImage songName:songName artistName:artistName];
}
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    LSTrackItem *copy = [[LSTrackItem allocWithZone:zone] initWithLyrics:self.lyrics artImage:self.artImage songName:self.songName artistName:self.artistName];
    return copy;
}

@end
