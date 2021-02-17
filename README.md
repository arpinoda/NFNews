# NFNews
<a href="https://dribbble.com/shots/4909274-News-App-Interaction">
  <img src="Design/final.gif" height="600px" alt="Final product - Implementing Cuberto's interaction design" />
</a>
<i>Dribbble shot on the left, final product on the right (running in Simulator)</i>

## About the Project
Having a go at implementing Cuberto’s "News App Interaction", with data being pulled from NewsApi.org. This has been on the hobby list for quite a while, very excited with the initial result.

## Credit
Cuberto "News App Interaction" - https://dribbble.com/shots/4909274-News-App-Interaction

## Project Setup
- Clone the repository
- Open nfnews.xcodeproj
- Create & initialize an Xcode environment variable entitled “NEWS_API_KEY” within Run scheme
- Run the project

## Requirements
- iOS 11+
- NewsApi.org developer key https://newsapi.org/register

## Features
- Compatible with hundreds of news sources around the world
- ThemeManager to allow iOS <= 12 users to dynamically change UI theme within app
- FontManager to centralize font logic and provide dynamic scaling
- MVVM + Coordinator patterns
- No storyboards


## Built with native iOS frameworks & technologies
- UIKit
- Autolayout 
- URLSession

## Implementation Notes
### View Hierarchy - Home Tab

News data is contained within a single HomeTableView. Each HomeTableViewCell represents a unique news source (e.g. ESPN) and contains an AppRotatedLabel, HomeTableViewDragHandle, and UICollectionView. Each HomeCollectionViewCell represents one news article and contains a HomeCollectionViewTitle, HomeCollectionViewSubtitle, and HomeCollectionViewImageView.

### Design Assets
Created by referencing the animated GIF:
- Icons
- Colors & theme
- Typefaces & sizing
- Margins & padding
- Animation/Interaction timeline

## Areas of Improvement
- Build into a reusable UI component 
- Expand app's functionality - profile, favorites, & search scenes
- Implement Dark Theme
- Client side persistence via CoreData
