# Regular Usage

 * run `./serve.sh`
 * add posts(s) to `_posts`
 * ... iterate
 * add and push via `git add`, etc
 * push to github, which implicitly publishes.

# META Notes

... on setting up [GitHub Pages](https://pages.github.com/) and [Jekyll](https://jekyllrb.com/)
... and building on [Jekyll on GitHub Pages](https://help.github.com/articles/using-jekyll-as-a-static-site-generator-with-github-pages/)
... to eventually use the combination for blogging using GitHub GISTs.

Useful tips/pointers during my excursion:
 - http://jmcglone.com/guides/github-pages/

# Setup

Largely following ["Setting up GitHub Pages locally with Jekyll"](https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/) to bootstrap my site.

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
        # uncomment gem "github-pages

# Importing my old WordPress

Using [Jekyll's importers](http://import.jekyllrb.com/):

# Things to investigate

 - http://getbootstrap.com/getting-started/
 - https://experimentingwithcode.com/creating-a-jekyll-blog-with-bootstrap-4-and-sass-part-1/

 - [A curl tutorial using GitHub's API](https://gist.github.com/caspyin/2288960)
 - https://stackoverflow.com/questions/2423777/is-it-possible-to-create-a-remote-repo-on-github-from-the-cli
