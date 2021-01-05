//
//  GrainSource.h
//  GrainSwift
//
//  Created by lucas kuzma on 1/5/21.
//

#ifndef GrainSource_h
#define GrainSource_h

@import Foundation;
@import AVFoundation;

@interface GrainSource : NSObject

+ (AVAudioSourceNode *)createSourceNodeWithBuffer:(AVAudioPCMBuffer*)buffer length:(AVAudioFrameCount)length;

+ (double)getDensity;
+ (double)increaseDensity;

@end

#endif /* GrainSource_h */
