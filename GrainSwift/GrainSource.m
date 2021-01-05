//
//  GrainSource.m
//  GrainSwift
//
//  Created by lucas kuzma on 1/5/21.
//

#import "GrainSource.h"

struct Grain {
    UInt32 index;
};

#define COUNT 20000

int bufferLength = 0;
int bufferIndex = 0;
struct Grain grains[COUNT];
double density = 0.1;
int grainCount = 0;

@implementation GrainSource

+ (double)getDensity
{
    return density;
}

+ (double)increaseDensity
{
    density += 0.1;
    density = MIN(density, 1.0);
    return density;
}

+ (AVAudioSourceNode *)createSourceNodeWithBuffer:(AVAudioPCMBuffer*)buffer length:(AVAudioFrameCount)length
{
    density = 0.1;
    bufferLength = length;
    bufferIndex = length/2;
    
    return [[AVAudioSourceNode alloc] initWithRenderBlock:^OSStatus(BOOL * _Nonnull isSilence, const AudioTimeStamp * _Nonnull timestamp, AVAudioFrameCount frameCount, AudioBufferList * _Nonnull outputData)
    {
        float * __nonnull const * __nullable channelData = buffer.floatChannelData;
        
        for (int i=0; i<frameCount; i++)
        {
            if (grainCount < density * COUNT) {
                grainCount++;
            }
            
            float amplitude = 1.0 / grainCount;
            
            for (int c=0; c<2; c++) {
                
                float sample = 0;
                for (int g=0; g<grainCount; g++) {
                    int grainIndex = (bufferIndex + grains[g].index) % bufferLength;
                    sample += channelData[c][grainIndex];
                    grains[g].index = (grains[g].index + 1) % 44100;
                }
                
                float *outData = (float*)outputData->mBuffers[c].mData;
                outData[i] = sample * amplitude;
            }
        }
        
        return noErr;
    }];
}

@end
