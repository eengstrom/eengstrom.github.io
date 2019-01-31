
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

# Regular References

  * [Kramdown syntax](https://kramdown.gettalong.org/syntax.html)
  * [Jekyll cheatsheet](https://devhints.io/jekyll)
  * [Minima theme](https://github.com/jekyll/minima)

# Regular Usage

 * run `./serve.sh`,
 * add posts(s) to `_posts`,
 * ... iterate ...
 * `add`, `commit`, and `push` to GitHub, which implicitly publishes.

# Setup

  * Create a repository on GitHub called `USER.github.io`, or
    via [GitHub's API](https://gist.github.com/caspyin/2288960)
    (c.f. [this](https://stackoverflow.com/questions/2423777/is-it-possible-to-create-a-remote-repo-on-github-from-the-cli))

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

## Migrate from self-hosted Wordpress

Using [Jekyll's wordpress importer](http://import.jekyllrb.com/docs/wordpress/), and a bit of hackery:

    gem install --user-install unidecode sequel mysql2 htmlentities jekyll-import
    # https://serverfault.com/questions/127794/forward-local-port-or-socket-file-to-remote-socket-file
    socat "UNIX-LISTEN:./mysqld.sock,reuseaddr,fork" \
          EXEC:'ssh user@wphost.example.net socat STDIO UNIX-CONNECT\:/var/run/mysqld/mysqld.sock'
    # test
    #mysql -S ./mysqld.sock -u USER -p
    # convert
    ruby -r rubygems -e 'require "jekyll-import";
       JekyllImport::Importers::WordPress.run({
           "dbname"         => "DBNAME",
           "user"           => "USER",
           "password"       => "PASSWORD",
           "host"           => "localhost",
           "port"           => "3306",
           "table_prefix"   => "wp_",
           "socket"         => "./mysqld.sock",
        })'
    cd _posts
    dos2unix *
    # https://github.com/aaronsw/html2text
    pip install html2text
    for f in *.html; do
       md=$(echo "$f" | sed 's/html$/md/')
       (
         awk '/---/ {mark++} mark<=1' < "$f";
         echo "---"
         awk '/---/ {mark++} mark>=2' < "$f" \
           | html2text - \
           | tail -n +2
       ) >"$md"
    done
    mv *.md ../../_posts

# Things to investigate

 - tag cloud(s)
   - https://github.com/pattex/jekyll-tagging
   - https://superdevresources.com/tag-cloud-jekyll/
   - http://longqian.me/2017/02/09/github-jekyll-tag/
   - http://tomnorian.com/a-liquid-tag-cloud-for-jekyll-blogs.html
 - https://stackoverflow.com/questions/45769857/css-to-add-to-jekyll-minima-not-completely-override-it?rq=1
 - add CV and other ideas from https://github.com/jmcglone/jmcglone.github.io
 - http://getbootstrap.com/getting-started/
 - https://experimentingwithcode.com/creating-a-jekyll-blog-with-bootstrap-4-and-sass-part-1/
 - [line numbering code blocks](http://abeysuriya.com/2015/09/17/jekyll-syntax-highlighting.html)
