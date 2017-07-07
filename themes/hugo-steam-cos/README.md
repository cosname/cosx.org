# Steam

Steam is a minimal and customizable theme for bloggers and was developed by [Tommaso Barbato](//github.com/epistrephein). He created it as a slightly adapted version of the [Vapor](//github.com/sethlilly/Vapor) Ghost theme by [Seth Lilly](//github.com/sethlilly). Noteworthy features of this Hugo port are the integration of a comment-system powered by Disqus, the customizable appearance by changing theme colors, support for RSS feeds, syntax highlighting via Highlight.js for source code and the optional use of Google Analytics. Enough to read. Let's take the first steps to get started.

![Screenshot](https://raw.githubusercontent.com/digitalcraftsman/hugo-steam-theme/dev/images/screenshot.png)


## Installation

Inside the folder of your Hugo site run:

    $ cd themes
    $ git clone https://github.com/digitalcraftsman/hugo-steam-theme.git

For more information read the official [setup guide](//gohugo.io/overview/installing/) of Hugo.

### The config file

Take a look inside the [`exampleSite`](//github.com/digitalcraftsman/hugo-steam-theme/blob/dev/exampleSite/) folder of this theme. You'll find a file called [`config.toml`](//github.com/digitalcraftsman/hugo-steam-theme/blob/dev/exampleSite/config.toml).

To use it, copy the [`config.toml`](//github.com/digitalcraftsman/hugo-steam-theme/blob/dev/exampleSite/config.toml) in the root folder of your Hugo site. Feel free to change strings as you like to customize your website.

## Add links to the navigation

You can add custom pages like this by adding `menu = "main"` in the frontmatter:

```toml
+++
date  = "2015-08-22"
title = "About me"
menu  = "main"
+++
```

If no document contains menu = "main" in the frontmatter than the navigation will not be shown


## Customize theme colors

This theme features four different theme colors (green as default, blue, red and orange) that change the appearance of you Hugo site slightly. Just set the `themeColor` variable to the color you like.

Furthermore you can create your own theme. Under [`layouts/partials/themes`](//github.com/digitalcraftsman/hugo-steam-theme/tree/dev/layouts/partials/themes) you'll find a stylesheet template called [`custom-theme.html`](//github.com/digitalcraftsman/hugo-steam-theme/blob/dev/layouts/partials/themes/custom-theme.html). Customize the colors as you like and save the new theme with the schema `<myNewColor>-theme.html` within the same folder. As you can see, the color is the prefix of the stylesheet template. Therefore you just need to set `themeColor` in the [`configs`](//github.com/digitalcraftsman/hugo-steam-theme/blob/dev/exampleSite/config.toml)) to that self-defined prefix. 

## Comments

This theme features a comment system powered by Disqus. To enable it you have to add your Disqus shortname to the `disqusShortname` variable in the config file.

## Nearly finished

In order to see your site in action, run Hugo's built-in local server. 

    $ hugo server

Now enter [`localhost:1313`](http://localhost:1313) in the address bar of your browser.

## Changelog

You can find the latest changes and improvements of this theme in the [CHANGELOG.md](https://github.com/digitalcraftsman/hugo-steam-theme/blob/master/CHANGELOG.md)


## Contributing

Did you found a bug or got an idea for a new feature? Feel free to use the [issue tracker](//github.com/digitalcraftsman/hugo-steam-theme/issues) to let me know. Or make directly a [pull request](//github.com/digitalcraftsman/hugo-steam-theme/pulls).


## License

This theme is released under the MIT license. For more information read the [License](//github.com/digitalcraftsman/hugo-steam-theme/blob/master/LICENSE.md).


## Annotations

Thanks to 

- [Steve Francia](//github.com/spf13) for creating Hugo and the awesome community around the project.
- [Seth Lilly](//github.com/sethlilly) and [Tommaso Barbato](//github.com/epistrephein) for developing the original version(s) of this theme
