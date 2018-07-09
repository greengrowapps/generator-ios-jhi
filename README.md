# generator-ios-jhi [![NPM version][npm-image]][npm-url] [![Build Status][travis-image]][travis-url] [![Dependency Status][daviddm-image]][daviddm-url]
> Scaffolds an iOS app that uses an Jhipster generated api

## Installation

First, install [Yeoman](http://yeoman.io) and generator-ios-jhi using [npm](https://www.npmjs.com/) (we assume you have pre-installed [node.js](https://nodejs.org/)).

```bash
npm install -g yo
npm install -g generator-ios-jhi
```

## Usage

Create a folder and go inside

```bash
mkdir my-ios-project && cd my-ios-project
```

then generate the code:

```bash
yo ios-jhi
```


install cocoa pods (skip if already installed)

```bash
sudo gem install cocoapods
```

install dependencies

```bash
pod install
```

open the xcworkspace file with XCode

Set the url where you have your jhipster app running in the app delegate. Then run the app. You should be able to sign in.


## Configure Social Login

On your web/api project use the [jhipster-social-login-api](https://github.com/greengrowapps/generator-jhipster-social-login-api) to add the extra controllers that you need and follow the instructions

For Google:
You will need 2 [Credentials](https://console.developers.google.com/apis/credentials?project=_). The web credential that uses the server and a iOS credential for the app.

Copy the Client ID from your iOS credential and replace YOUR_GOOGLE_CLIENT_ID in AppDelegate and Plist.info
Copy the Reversed Client ID from your iOS credential and replace YOUR_GOOGLE_REVERSED_CLIENT_ID and in YOUR_GOOGLE_URL_SCHEME Plist.info
Copy the Client ID from the credential that uses the server and replace YOUR_GOOGLE_SERVER_CLIENT_ID in the AppDelegate

You should be able to sign in with Google

For Facebook:

Copy your App identifier (only numbers) and replace YOUR_FACEBOOK_ID in Plist.info then replace YOUR_FACEBOOK_URL_SCHEME with "fb" concatenated with yout facebook id

You should be able to sign in with Facebook

## Configure Firebase push notifications

Create an iOS App in your [Firebase console](https://console.firebase.google.com), download the GoggleService-Info.plist and replace the existing in project


## Getting To Know Yeoman

 * Yeoman has a heart of gold.
 * Yeoman is a person with feelings and opinions, but is very easy to work with.
 * Yeoman can be too opinionated at times but is easily convinced not to be.
 * Feel free to [learn more about Yeoman](http://yeoman.io/).

## License

Apache-2.0 © [Green grow apps](https://www.greengrowapps.com)


[npm-image]: https://badge.fury.io/js/generator-ios-jhi.svg
[npm-url]: https://npmjs.org/package/generator-ios-jhi
[travis-image]: https://travis-ci.org/greengrowapps/generator-ios-jhi.svg?branch=master
[travis-url]: https://travis-ci.org/greengrowapps/generator-ios-jhi
[daviddm-image]: https://david-dm.org/greengrowapps/generator-ios-jhi.svg?theme=shields.io
[daviddm-url]: https://david-dm.org/greengrowapps/generator-ios-jhi
