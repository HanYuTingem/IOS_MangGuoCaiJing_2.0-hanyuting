/*
 * Copyright 2010-2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import <Foundation/Foundation.h>

// Constants used to represent your AWS Credentials.
#define ACCESS_KEY_ID          @"R54RC9W47PE45WPCZZR0"
#define SECRET_KEY             @"ApcPtKxXjEGczCAGVv+SnLe1St84DB6kZ7lYDdNy"


// Constants for the Bucket
#define S3TRANSFERMANAGER_BUCKET         @"sinoglobal"


#define CREDENTIALS_ERROR_TITLE    @"Missing Credentials"
#define CREDENTIALS_ERROR_MESSAGE  @"AWS Credentials not configured correctly.  Please review the README file."

#define kRequestTagForSmallFile         @"tag-tm-small-file-0"
#define kRequestTagForBigFile           @"tag-tm-big-file-0"
#define kKeyForBigFile                  @"Congratulation"
#define kKeyForSmallFile                @"FixedPicture"

#define kSmallFileSize 1024*48 //48 kb
#define kBigFileSize 1024*1024*10  //10 megs

@interface Constants : NSObject

+ (NSString *)transferManagerBucket;

@end
