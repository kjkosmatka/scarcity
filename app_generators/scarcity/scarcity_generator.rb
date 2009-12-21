require 'yaml'

class ScarcityGenerator < RubiGen::Base

  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])

  default_options :author => nil

  attr_reader :name, :segments_dir, :data_sources_dir

  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @destination_root = File.expand_path(args.shift)
    @base_name = base_name
    extract_options
    @segments_dir = '/replace/with/your/runs/path'
    @data_sources_dir = '/replace/with/your/data/path'
    if File.exist?(File.expand_path('~/.scarcityrc'))
      config = YAML::load(File.read(File.expand_path('~/.scarcityrc')))
      @segments_dir = config['segments_dir']
      @data_sources_dir = config['data_sources_dir']
    end
  end

  def manifest
    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory ''
      BASEDIRS.each { |path| m.directory path }

      # Create stubs
      # m.template "template.rb",  "some_file_after_erb.rb"
      # m.template_copy_each ["template.rb", "template2.rb"]
      # m.file     "file",         "some_file_copied"
      # m.file_copy_each ["path/to/file", "path/to/file2"]
      m.file 'null.submit', 'lib/submits/null.submit'
      m.file 'prejob.rb', 'app/scripts/prejob.py', :chmod => 0755
      m.file 'postjob.rb', 'app/scripts/postjob.py', :chmod => 0755
      m.file 'executable.rb', "app/executables/#{@base_name}.py", :chmod => 0755
      m.file 'executable.submit', "app/submits/#{@base_name}.submit"
      m.template 'control.rb', "script/#{@base_name}", :chmod => 0755
      m.template 'environment.rb', "config/environment.rb"
      m.template 'boot.rb', 'config/boot.rb'
      m.file 'return_codes.yml', 'config/return_codes.yml'
      m.file 'views/index.erb', "sinatra/views/index.erb"
      m.file 'views/segment.erb', 'sinatra/views/segment.erb'
      m.file 'views/documentation.erb', 'sinatra/views/documentation.erb'
      m.file 'views/stylesheet.css', "sinatra/public/css/stylesheet.css"
      m.file 'views/layout.erb', "sinatra/views/layout.erb"
      m.file 'views/segments.erb', 'sinatra/views/segments.erb'
      m.file 'views/data.erb', 'sinatra/views/data.erb'
      m.file 'views/configuration.erb', 'sinatra/views/configuration.erb'
      m.file 'views/webapp.rb', "sinatra/webapp.rb", :chmod => 0755
      m.file 'server', "script/server", :chmod => 0755
      m.template 'provisions_builder.rb', "config/builders/provisions_builder.rb"
      m.template 'dag_builder.rb', "config/builders/dag_builder.rb"

      m.dependency "install_rubigen_scripts", [destination_root, 'soar'],
        :shebang => options[:shebang], :collision => :force
    end
  end

  protected
    def banner
      <<-EOS
Creates a ...

USAGE: #{spec.name} name
EOS
    end

    def add_options!(opts)
      opts.separator ''
      opts.separator 'Options:'
      # For each option below, place the default
      # at the top of the file next to "default_options"
      # opts.on("-a", "--author=\"Your Name\"", String,
      #         "Some comment about this option",
      #         "Default: none") { |o| options[:author] = o }
      opts.on("-v", "--version", "Show the #{File.basename($0)} version number and quit.")
    end

    def extract_options
      # for each option, extract it into a local variable (and create an "attr_reader :author" at the top)
      # Templates can access these value via the attr_reader-generated methods, but not the
      # raw instance variable value.
      # @author = options[:author]
    end

    # Installation skeleton.  Intermediate directories are automatically
    # created so don't sweat their absence here.
    BASEDIRS = %w(
      app/submits
      app/scripts
      app/executables
      config/builders
      doc
      lib/tasks
      lib/core
      lib/submits
      log
      sinatra/public/css
      sinatra/views
      script
      test
      tmp
    )
end