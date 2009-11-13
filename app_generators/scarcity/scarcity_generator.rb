class ScarcityGenerator < RubiGen::Base

  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])

  default_options :author => nil

  attr_reader :name

  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @destination_root = File.expand_path(args.shift)
    @base_name = base_name
    extract_options
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
      m.file 'prejob.rb', 'app/scripts/prejob.rb', :chmod => 0755
      m.file 'postjob.rb', 'app/scripts/postjob.rb', :chmod => 0755
      m.file 'executable.rb', "app/executables/#{@base_name}.rb", :chmod => 0755
      m.file 'executable.submit', "app/submits/#{@base_name}.submit"
      m.template 'control.rb', "script/#{@base_name}", :chmod => 0755
      m.file 'environment.rb', "config/environment.rb"
      m.file 'boot.rb', 'config/boot.rb'
      m.file 'index.erb', "sinatra/views/index.erb"
      m.file 'stylesheet.css', "sinatra/stylesheets/stylesheet.css"
      m.file 'layout.erb', "sinatra/views/layout.erb"
      m.file 'webapp.rb', "sinatra/webapp.rb", :chmod => 0755
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
      sinatra/public
      sinatra/views
      sinatra/stylesheets
      script
      test
      tmp
    )
end