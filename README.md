# Open Granular

Open source granular synthesizer for iOS, written in Swift using SwiftUI.



## Where we are

<img src="Meta%20Assets/iPhone.png" width="200px" />



## How to get one

You can build from source or [install a copy](https://apps.apple.com/us/app/open-granular/id1549682361) directly from the App Store.

<a href="https://apps.apple.com/us/app/open-granular/id1549682361"><img src="Meta%20Assets/AppStore.svg" width="100px" /></a>



## How to load your own sounds

You can share sounds from other applications, like _Voice Memos_. More details in [Part 5](http://the.strange.agency/blog/open-grain-05/).



## What this thing does

You may first wish to peruse the [Wikipedia entry on Granular Synthesis](https://en.wikipedia.org/wiki/Granular_synthesis).

For a deeper dive, have a look at [Microsound](https://www.amazon.com/Microsound-MIT-Press-Curtis-Roads/dp/0262681544/).



## What this button does

Some controls work in the horizontal and vertical directions. The vertical direction adds a random jitter to the parameter.

Some controls display two `lfo:` labels. Dragging these vertically sets the amount of LFO applied to the parameter. Similarly, the `env:` label lets you add envelope modulation to the respective parameter.


control | effect
--- | ---
density<sup>1</sup> | number of grains playing at once
ramp | amount of smoothing applied to each grain
position<sup>2</sup> | where in the source buffer grains are coming from
size | size of each grain
spread | spacing between subsequent grains
pitch | playback speed a.k.a pitch
attack | duration of amp envelope attack portion
release | duration of amp envelope release portion
lfo | low frequency oscillator modulator period
volume | overall output volume


1. The number of grains playable at once depends on your device's CPU. Too many grains will result in crunch or silence on slower devices.
2. Touching the top waveform enables the amp envelope and lets you play by tapping. To get back to continuous playback, simply touch the `position` control.


## Why we are here

I wanted to explore Swift in the context of audio and see how much I could get away with. It seemed like a ride worth taking others on. It also made for an opportunity to monkey with SwiftUI, as my clients are still a little bit wary of diving in.



## How we got here

1. [Part 1: Intro](http://the.strange.agency/blog/open-grain-01/)
1. [Part 2: Loading Audio](http://the.strange.agency/blog/open-grain-02/)
1. [Part 3: Making it Grain](http://the.strange.agency/blog/open-grain-03/)
1. [Part 4: Control](http://the.strange.agency/blog/open-grain-04/)
1. [Part 5: Sharing Sounds](http://the.strange.agency/blog/open-grain-05/)
1. [Part 6: Jitter](http://the.strange.agency/blog/open-grain-06/)
1. [Part 7: Mixing Sounds](http://the.strange.agency/blog/open-grain-07/)
1. [Part 8: More Touchy](http://the.strange.agency/blog/open-grain-08/)
1. [Part 9: Pitch Control](http://the.strange.agency/blog/open-grain-09/)

