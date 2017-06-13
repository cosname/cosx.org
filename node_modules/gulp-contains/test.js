'use strict';

var contains = require('./');
var gutil = require('gulp-util');
var should = require('should');
var through = require('through2');

describe('gulp-contains tests', function () {
	it('shouldn\'t break good files', function (done) {
		var stream = contains('notfound');

		stream.on('data', function (file) {
			file.contents.length.should.be.above(5);
			done();
		});

		stream.write(new gutil.File({
			contents: new Buffer('something')
		}));
	});

	it('should error on bad files', function () {
		should.throws(function () {
			var stream = contains('notfound');

			stream.write(new gutil.File({
				contents: new Buffer('this should be notfound')
			}));
		}, /contains "notfound"/);
	});

	it('should error on bad files matching regexp', function () {
		should.throws(function () {
			var stream = contains(/(notfound)/);

			stream.write(new gutil.File({
				contents: new Buffer('this should be notfound')
			}));
		}, 'Your file contains "/(notfound)/", it should not.');
	});

	it('should accept array of strings to find', function () {
		should.throws(function () {
			var stream = contains(['something', 'notfound', 'something else']);

			stream.write(new gutil.File({
				contents: new Buffer('this should be notfound')
			}));
		}, /contains "notfound"/);
	});

	it('should accept array of regexps to find', function () {
		should.throws(function () {
			var stream = contains([/(notfound)/, /(somethingelse)/]);

			stream.write(new gutil.File({
				contents: new Buffer('this should be notfound')
			}));
		}, 'Your file contains "/(notfound)/", it should not.');
	});

	it('should accept mixed array of strings and regexps to find', function () {
		should.throws(function () {
			var stream = contains(["some string", /(notfound)/]);

			stream.write(new gutil.File({
				contents: new Buffer('this should be notfound')
			}));
		}, 'Your file contains "/(notfound)/", it should not.');
	});

	it('should allow you to pass own error handler', function (done) {
		var stream = contains({
			search: 'notfound',
			onFound: function (str) {
				str.should.equal('notfound');
				done();
			}
		});

		stream.pipe(through.obj(function () {
			throw new Error('Stream continued! :(');
		}));

		stream.write(new gutil.File({
			contents: new Buffer('this should be notfound')
		}));
	});

	it('should continue the stream when told to', function (done) {
		var stream = contains({
			search: 'notfound',
			onFound: function (str) {
				str.should.equal('notfound');
				return false;
			}
		});

		stream.pipe(through.obj(function () {
			done();
		}));

		stream.write(new gutil.File({
			contents: new Buffer('this should be notfound')
		}));
	})
});
