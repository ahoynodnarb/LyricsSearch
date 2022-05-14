//
//  LSTrackitem.h
//  LyricsSearch
//
//  Created by Brandon Yao on 4/29/22.
//

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SpotifyiOS.h>

@interface LSTrackItem : NSObject
@property (nonatomic, strong) UIImage *artImage;
@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) NSString *URI;
- (instancetype)initWithArtImage:(UIImage *)artImage songName:(NSString *)songName artistName:(NSString *)artistName duration:(NSInteger)duration URI:(NSString *)URI;
@end
