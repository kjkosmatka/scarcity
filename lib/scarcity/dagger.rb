module Scarcity
  
  class Dagger
    
    def initialize(options={}, &block)
      @daglines = Array.new
      self.instance_eval(&block)
      save(options[:file]) unless options[:file].nil?
    end
    
    def job(jobname, sdf, options={}, &block)
      options = {:dir => nil, :done => false}.merge(options)
      dir, done = [options[:dir], options[:done]]
      @daglines << Job.new(jobname, sdf, options, &block).daglines
    end
    def subdag(jobname, dagfile, options={}, &block)
      options[:type] = :subdag
      job(jobname, dagfile, options, &block)
    end
    def splice(jobname, dagfile, options={}, &block)
      options[:type] = :splice
      job(jobname, dagfile, options, &block)
    end
    
    def breed(parents, options={})
      options = {:children => []}.merge(options)
      children = options[:children]
      parents = [parents].flatten.join(' ')
      children = [children].flatten.join(' ')
      @daglines << "PARENT #{parents} CHILD #{children}"
    end
    
    def max_jobs(category, max)
      @daglines << "MAXJOBS #{category} #{max}"
    end
    
    def to_s
      @daglines.join("\n")
    end
    def save(filename)
      save!(filename) unless File.file?(filename)
    end
    def save!(filename)
      File.open(filename,'w') { |f| f.puts @daglines }
    end
    
  end
  
  class Job
    JOBTYPES = { 
      :job    => "JOB", 
      :splice => "SPLICE", 
      :subdag => "SUBDAG EXTERNAL" }
    attr_reader :daglines
    def initialize(jobname, sdf, options={}, &block)
      @daglines = Array.new
      @jobname = jobname
      options = {:dir => nil, :done => false, :type => :job}.merge(options)
      dir, done, type = [options[:dir], options[:done], options[:type]]
      build_job_dagline(jobname, sdf, dir, done, type)
      self.instance_eval(&block) if block_given?
    end
    def build_job_dagline(jobname, sdf, dir, done, type)
      jobtype = JOBTYPES[type]
      new_dagline = "#{jobtype} #{jobname} #{sdf}"
      new_dagline += " DIR #{dir}" unless dir.nil?
      new_dagline += " DONE" if done
      @daglines << new_dagline
    end
    
    def pre(script, options={})
      action "PRE", script, options
    end
    def post(script, options={})
      action "POST", script, options
    end
    def action(order, script, options={})
      options = { :args => nil }.merge(options)
      args = options[:args]
      dagline = "SCRIPT #{order} #{@jobname} #{script}"
      dagline += " #{args}" unless args.nil?
      @daglines << dagline
    end
    def priority(level)
      @daglines << "PRIORITY #{@jobname} #{level}"
    end
    def retries(times, options={})
      options = {:unless_exit => nil}.merge(options)
      unless_exit = options[:unless_exit]
      dagline = "RETRY #{@jobname} #{times}"
      dagline += " UNLESS-EXIT #{unless_exit}" unless unless_exit.nil?
      @daglines << dagline
    end
    def abort_dag_on(job_return_value, options={})
      options = {:dag_return_value => nil}.merge(options)
      dag_return_val = options[:dag_return_value]
      dagline = "ABORT-DAG-ON #{@jobname} #{job_return_value}"
      dagline += " RETURN #{dag_return_val}" unless dag_return_val.nil?
      @daglines << dagline
    end
    
    # escaped characters are NOT supported here.  you can cheat by double 
    # escaping things if you want
    def vars(hash)
      macros = hash.map { |k,v| "#{k}=\"#{v}\"" }.join(' ')
      @daglines << "VARS #{@jobname} #{macros}"
    end
    def category(name)
      @daglines << "CATEGORY #{@jobname} #{name}"
    end
  end
  
end