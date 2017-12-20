//
//  UIView+Orientation.m
//

#import "UIView+STAOrientation.h"

@implementation UIView (STAOrientation)

+ (ViewOrientation)viewOrientationForSize:(CGSize)size {
    return (size.width > size.height) ? ViewOrientationLandscape : ViewOrientationPortrait;
}

- (ViewOrientation)viewOrientation {
    return [[self class] viewOrientationForSize:self.bounds.size];
}

- (BOOL)isViewOrientationPortrait {
    return [self viewOrientation] == ViewOrientationPortrait;
}

- (BOOL)isViewOrientationLandscape {
    return [self viewOrientation] == ViewOrientationLandscape;
}

@end
