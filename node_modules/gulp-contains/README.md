# gulp-contains [![Build Status](https://travis-ci.org/callumacrae/gulp-contains.svg?branch=master)](https://travis-ci.org/callumacrae/gulp-contains)

Throws an error or calls a callback if a given string is found in a file.

Useful for dumb quality checking.

## Install

```
$ npm install --save-dev gulp-contains
```

## Usage

The following code will throw an error if "../node_modules" is found in any
Sass or SCSS file.

```js
var gulp = require('gulp');
var contains = require('gulp-contains');

gulp.task('default', function () {
	gulp.src('./src/**/*.{sass, scss}')
		.pipe(contains('../node_modules'));
});
```

The contains function accepts a string, a regular expression or an array of either (any of
which, when matched, will cause an error to be thrown).

You can also specify a callback function, in which you can handle the error
yourself or choose to completely ignore it:

```js
var gulp = require('gulp');
var contains = require('gulp-contains');

gulp.task('default', function () {
	gulp.src('./src/**/*.{sass, scss}')
		.pipe(contains({
			search: '../node_modules',
			onFound: function (string, file, cb) {
				// string is the string that was found
				// file is the vinyl file object
				// cb is the through2 callback

				// return false to continue the stream
			}
		}));
});
```

## License

Released under the MIT license.