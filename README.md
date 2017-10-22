# p5.js for iOS
Hey there! This repository is the main code for my p5.js ios app. Feel free to list any issues or contribute. There is room for a lot of improvement. If you find a bug please only file an issue. I will add it to the list below if nessecary.

I noticed there are quite some people that prefer an iPad over a laptop because of its mobility and I find myself wanting to just quickly code some idea on my iPhone as well. Sadly there wasn't a good native p5.js (or even javascript) app available and the online p5 editor on p5js.org doesn't really work that well on mobile devices.

I don't know if anyone will ever bother looking at this code, but please keep in mind I am not a proffesional app creator and I therefore don't really know how things are 'suppost' to be done but rather I know how to do things in a way that they'll work.

# App store
The app can be found here:
https://itunes.apple.com/app/p5-js-editor/id1296619254

# To do list
* clean up code
* check if devices memory is full

### Known bugs
* (fixed) Difference between " and “, ' and ’, causes javascript errors
* (fixed) Project menu shows up behind the keyboard (iPhone)
* (fixed) Syntax highlighting doesn't update when text is pasted
* unable to scroll in the webView
* canvas is selectable in webView (very irritating)
* prevent user from entering non-alphanumerical project names (as it will be a folder)

### New features
* (added) ES6
* (added) DOM_JS should be automatically imported
* (working on atm) Multiple js files per project
* sound library should be imported by default
* commonly used character keyboard-row
* Download zip file / push to github
* Open zip file / clone from github
* autocomplete
