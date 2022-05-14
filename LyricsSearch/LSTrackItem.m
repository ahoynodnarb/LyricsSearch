//
//  LSTrackitem.m
//  LyricsSearch
//
//  Created by Brandon Yao on 4/29/22.
//

#import "LSTrackItem.h"

@implementation LSTrackItem
- (instancetype)initWithArtImage:(UIImage *)artImage songName:(NSString *)songName artistName:(NSString *)artistName duration:(NSInteger)duration URI:(NSString *)URI {
    if(self = [super init]) {
        self.artImage = artImage;
        self.songName = songName;
        self.artistName = artistName;
        self.duration = duration;
        self.URI = URI;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"songName: %@ artistName: %@ duration: %ld", self.songName, self.artistName, (long)self.duration];
}
@end
