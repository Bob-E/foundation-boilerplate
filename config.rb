require 'slim'
Slim::Engine.default_options[:pretty] = true # Avoid HTML minification for people who don't know slim

set :js_dir,     'assets/javascripts'
set :css_dir,    'assets/stylesheets'
set :images_dir, 'assets/images'

activate :autoprefixer, browsers: ['last 2 versions', 'ie 8', 'ie 9']
activate :livereload
activate :syntax

activate :navtree do |options|
  options.data_file = 'tree.yml'
  options.source_dir = 'source' # The `source` directory we want to represent in our nav tree.
  options.ignore_files = [
    'sitemap.xml',
    'robots.txt',
    'human.txt',
    'favicon_base.png',
    'CNAME',
    'index.html.slim',
    'about.html.slim',
    'start.html.slim',
    '404.html.slim'
  ]
  options.ignore_dir = ['assets', 'views'] # An array of directories we want to ignore when building our tree.
  options.home_title = 'Home' # The default link title of the home page (located at "/"), if otherwise not detected.
  options.promote_files = ['index.html'] # Any files we might want to promote to the front of our navigation
  options.ext_whitelist = [] # If you add extensions (like '.md') to this array, it builds a whitelist of filetypes for inclusion in the navtree.
end

activate :deploy do |deploy|
  deploy.method       = :git
  deploy.branch       = 'gh-pages'
  deploy.build_before = true # always use --no-clean options
end

page "/sitemap.xml", layout: false

# Add bower's directory to sprockets asset path
after_configuration do
  @bower_config = JSON.parse(IO.read("#{root}/.bowerrc"))
  sprockets.append_path File.join "#{root}", @bower_config["directory"]
end

configure :build do
  activate :favicon_maker do |f|
    f.template_dir  = File.join(root, 'source/assets/images/logos/')
    f.output_dir    = File.join(root, 'build')
    f.icons = {
      "favicon_base.png" => [
        { icon: "chrome-touch-icon-192x192.png" },
        { icon: "apple-touch-icon.png", size: "152x152" },
        { icon: "ms-touch-icon-144x144-precomposed.png", size: "144x144" },
        { icon: "favicon-196x196.png" },
        { icon: "favicon-160x160.png" },
        { icon: "favicon-96x96.png" },
        { icon: "favicon-32x32.png" },
        { icon: "favicon-16x16.png" },
        { icon: "favicon.ico", size: "64x64,32x32,24x24,16x16" },
      ]
    }
  end

  activate :minify_css
  activate :minify_javascript
  activate :gzip
  activate :asset_hash

  activate :sitemap, hostname: data.settings.site.url

  activate :robots,
    rules: [{:user_agent => '*', :allow => %w(/)}],
    sitemap: data.settings.site.url+'sitemap.xml'

  # Use this for gh-pages
  activate :relative_assets
  set :relative_links, true
end
