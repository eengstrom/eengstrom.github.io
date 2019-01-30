
# Irregular Motif

This is the "source" repo for my [personal ramblings and random postings](https://eengstrom.github.io/) which is hosted via [GitHub Pages](https://pages.github.com/) using [Jekyll](https://jekyllrb.com/) and [Minima Theme](https://github.com/jekyll/minima).

Content in this repo and on my website is licensed under the [Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).

Anything else below are simply my (meta-)notes on how I set things up or other random GitHub Pages or Jekyll references.

----

# META Notes

 * On setting up [GitHub Pages](https://pages.github.com/) and [Jekyll](https://jekyllrb.com/),
 * ... largely following ["Setting up GitHub Pages locally with Jekyll"](https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/),
 * ... and building on [Jekyll on GitHub Pages](https://help.github.com/articles/using-jekyll-as-a-static-site-generator-with-github-pages/),
 * ... using tips/pointers from [Jonathan McGlone](http://jmcglone.com/guides/github-pages/) (just a random find),
 * ... to eventually use the combination for blogging using GitHub GISTs.

# Regular Usage

 * run `./serve.sh`,
 * add posts(s) to `_posts`,
 * ... iterate ...
 * `add`, `commit`, and `push` to GitHub, which implicitly publishes.

# Setup

  * Create a repository on GitHub called `USER.github.io`, or via API:

        curl -u 'eengstrom' https://api.github.com/user/repos -d '{"name":"eengstrom.github.io"}'
        git clone git@github.com:eengstrom/eengstrom.github.io.git
        cd eengstrom.github.io
        git remote rename origin github
        git branch jekyll-setup
        git push -u github jekyll-setup

  * Install Ruby and Jekyll

        brew install ruby
        prepend PATH ${BREW_HOME:-}/opt/ruby/bin
        gem install bundler jekyll
        prepend PATH ${BREW_HOME:-}/lib/ruby/gems/2.5.0/bin

  * Create new jekyll

        jekyll new .
        # edit `Gemfile` and uncomment `gem "github-pages" ...`

# Customizations

## Crimson

I'm using `#DC143C` as my color code for many things.

## Adding favicons

Followed [Jekyll Minima Docs](https://github.com/jekyll/minima#add-your-favicons), using [RealFavIconGenerator.net](https://realfavicongenerator.net/), with modified icons from [The Noun Project](https://thenounproject.com/) (under CC-by, by [Laura Breier](https://thenounproject.com/laura1435/)).

## Modifying stock headers/footers

Tips from [Jekyll Minima Docs](https://github.com/jekyll/minima#customization)

    mkdir _includes
    cp -p $(bundle show minima)/_includes/footer.html _includes
    edit _includes/footer.html

# Things to investigate

 - Import old wordpress posts using [Jekyll's importers](http://import.jekyllrb.com/)
 - http://getbootstrap.com/getting-started/
 - https://experimentingwithcode.com/creating-a-jekyll-blog-with-bootstrap-4-and-sass-part-1/
 - [A curl tutorial using GitHub's API](https://gist.github.com/caspyin/2288960)
 - https://stackoverflow.com/questions/2423777/is-it-possible-to-create-a-remote-repo-on-github-from-the-cli
