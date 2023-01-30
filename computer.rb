# Class emulating a shell.
class Computer
  @@users = {}
  @@commands = {
    'echo' => Proc.new {|s| puts s},
    'touch' => 0,
    'rm' => 0,
    'cp' => 0,
    'mv' => 0,
    'ls' => 0,
    'exit' => Proc.new { @shutdown = true }
  }

  def initialize(pcname, username, password)
    @username = username
    @password = password
    @pcname = pcname

    @@users[username] = password
    @working_dir = @files
    @files = {}
  end

  def create(filename, contents)
    @files[filename] = contents
    puts "New file created at #{@working_dir}, cunt."
  end

  def getcmd
    print "[#{@username}@#{@pcname} #{@working_dir}]$ "
    runcmd(gets)
  end

  def power_on
    loop do
      break if @shutdown

      getcmd
    end
  end

  def runcmd(cmd)
    cmd = cmd.split
    @@commands[cmd[0]].call(cmd[1..].join(' '))
  end

  def self.users
    @@users
  end
end

pieceofshit = Computer.new('pieceofshit', 'kill', 'lalilulelo')
pieceofshit.power_on
