#import "Constants.h"

@implementation Constants

+ (NSString *)transferManagerBucket
{
    return [[NSString stringWithFormat:@"%@", S3TRANSFERMANAGER_BUCKET] lowercaseString];
}

@end
