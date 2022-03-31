
## Readme
### GitHubProfileExplorer

An app written in Swift that provides an interface to search for GitHub users, and traverse their followers.


##### Requirements

Create a simple application that demonstrates understanding of the following:
* Basic project structure, demonstrating competence with Swift
* API interaction
* Navigation
* Local storage
* Expressed in testable code
* Leveraging standard UI elements and design patterns
* Command of development tools like source control and build environments


##### App Description

The app is built using storyboards for visual declaration, but not for segue control. That responsibility is caught by the SceneDelegate, where a Router is instantiated through a DependencyProvider. The Router then instantiates an initial ViewController and sets it on the Window.

The SearchViewController landing page presents a searchBar, that when populated with > 0 characters, will enable a button. The search term is then sent to a UserViewController screen that presents the searched user's information, as well as populating a table with their followers' pictures, names, and a row that's clickable to see that follower's info. The tableView is filterable using a local cache and delegate callback.

URLSession calls's are only made after a test to see if the User's info has already been fetched within an expiration of 5 minutes. Realm is used to store and retreive historic fetches.

Additional comments are inline.


##### Setup
It uses SPM to fetch Realm, but it should only take a moment to download.


##### Top 5 most played songs during development
1. [Keys N Krates - Glitter (Netsky Remix)](https://open.spotify.com/track/1Ak1KCXZ16bpl6w73VhUNb?si=2f6db5a4177e451b)
2. [Phil Tangent - Lately](https://open.spotify.com/track/0Y3rBgAds2mctvJO9MS62e?si=aee2fb4d202e4d1e)
3. [Boom Jinx - We Know (Vintage & Morelli Remix)](https://open.spotify.com/track/1G21N8RN3LN891gywCWzzg?si=1debee6b385249a9)
4. [Wande - Blessed Up (Remix)](https://open.spotify.com/track/0kjroUpjoVG4Y4fVkCzkIP?si=2d25d6883b4c4076)
5. [Keys N Krates - Getaway](https://open.spotify.com/track/2ogfjFHciNDr7kJf3LRsgN?si=e5bd53dd1b8742ed)